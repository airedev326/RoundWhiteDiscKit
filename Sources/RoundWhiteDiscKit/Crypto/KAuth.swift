import Foundation

// kAuth blob unwrap — based on the algorithm decoded from the
// Path B captures on 2026-05-01.
//
// ✅ LABEL DERIVATION RESOLVED 2026-05-03: the 12-byte KBKDF label is
// **bytes [0..12) of the wrapped blob, in plaintext**. This was verified
// by static decode of the SKB SecureData IMPORT path (lib+0x5b6b94 →
// vt[+0x50] handler → cipher provider lib+0x5d78d4 → label-writer
// lib+0x5d5f7c → memcpy to ctx+0xcc8). Independent confirmation via the
// captured DBKey wrapped blob `db_identifier_wrapped_57b.bin`: bytes
// [0..12) match the captured label `0747879091d4babe26957e76` exactly,
// AND match offset 0xcc8 in every cipher_fn ctx capture from
// `captures/path_b_kauth_unwrap_2026_05_01/cf_ctx/`. So the label is
// extracted, not derived externally. See
// `findings/LABEL_WRITER_LOCATED_2026_05_03.md`.
//
// For an actual kAuth blob (149 bytes from Libre3PatchContext.xml), the
// label is `blob[0..12]`. For the test data in KAuthTests.swift, that's
// `c89383590200000000000000` (4-byte session nonce + 8-byte type/length
// header). Different kAuth sessions have different nonces → different
// labels → different KBKDF outputs.
//
// ⚠ FOLLOW-UP 2026-05-03: independent confirmation via static decode of
// SKB child[5] (lib+0x5e4df8). helper_5c7af4(kAuth=0x5f38cad7) returns
// bucket 4, but every child in the chain at lib+0x5b6d04 gates on
// `cmp w0, 1` (bucket 1 = wrap_db_key family). So the 110-call
// orchestrator at lib+0x5e32b0 — and by extension the captures this
// file is calibrated against — is wrap_db_key UNWRAP, NOT real kAuth.
// Implication: the cipher math below (KBKDF, GHASH subkey via AES_K(0))
// is likely CORRECT for wrap_db_key replay and the static K1/K2 echo,
// but the actual kAuth UNWRAP path is still unidentified. See
// `findings/SESSION_2026_05_02_kauth_correction.md` for the analysis.
//
// ⚠ NAMING CAVEAT 2026-05-02: the path_b captures we built this against
// were RE-INTERPRETED as `unWrapDBKey` invocations (per memory
// `kauth-unwrap-algorithm-decoded.md`), NOT real kAuth-blob unwrap.
// The SKB engine for both paths uses the same shape (KBKDF-style 5-block
// `aes_K(label || counter_BE32)` + GHASH subkey + AES-GCM tag), but
// the underlying AES primitive may differ:
//   - wrap_db_key path  — uses cipher_fn at lib+0x5d2324 (white-box A)
//   - actual kAuth path — uses lib+0x5e41b4 (white-box B, encoded
//                          S-box at lib+0x278dc2). Verified independent
//                          of cipher_fn (lib+0x5e41b4 has no BL out;
//                          all logic inline T-table EORs).
//
// This file currently uses `CipherFn.aes_K` for both functions, which
// makes it CORRECT for wrap_db_key replay (the basis of our tests) but
// INCORRECT for unwrapping a real kAuth blob from `Libre3PatchContext.xml`.
// A second cipher_fn-equivalent port for lib+0x5e41b4 (with the
// lib+0x278dc2 encoded S-box bundled as a resource) is needed before
// real-blob unwrap will work. See `findings/STANDARD_AES_LOCATION_2026_05_02.md`
// for the surrounding architecture.
//
// What we know FOR SURE (from the live capture in
// captures/path_b_kauth_unwrap_2026_05_01/, treated as the wrap_db_key
// reference even though originally labeled kAuth):
//
//   1. The lib's KBKDF, when invoked with a 12-byte LABEL, produces
//      derived blocks via:
//          KDF[i] = aes_K(label_12B || i_BE32)   for i ∈ {1, 2, ...}
//      No CMAC pre-XOR — direct AES counter mode (memory
//      `lib-kbkdf-is-direct-aes-counter.md`). 5 blocks (80B) generated
//      during reconnect.
//   2. The lib also computes L = AES_K(0) once (= `42ec5204…a555`),
//      which is the standard AES-GCM GHASH subkey H.
//   3. Across 3 captured kAuth blobs, EXACTLY 80 bytes vary per session,
//      matching the 80B keystream perfectly. The varying byte ranges are:
//          blob[0:4]      4B   nonce
//          blob[49:65]    16B  block A
//          blob[69:93]    24B  block B
//          blob[97:113]   16B  block C
//          blob[129:149]  20B  trailer (tag + 4B suffix?)
//      All other bytes are static lib state (K1, K2, framing).
//
// What we DON'T yet know:
//   - The label-derivation function — currently the label must be
//     extracted per-pairing via a one-shot LLDB capture (HW bp at
//     lib+0x5d6060, dump 12B from [x20]).
//   - The exact chunk-to-KDF-block pairing for the encryption. Naive
//     concat-XOR doesn't decrypt cleanly; the construction is likely
//     AES-GCM with KDF[1] as the S0 tag mask and KDF[2..5] as the
//     64B encryption keystream, but we haven't yet pinned down
//     which 64B in the blob is the ciphertext vs which 16B is the tag.
//   - Whether the cipher_fn used by wrap_db_key and the white-box AES
//     used by real kAuth (lib+0x5e41b4) embed the same K under different
//     encodings. If so, a single bundled K would suffice.
//
// This file therefore implements:
//   - The bits we KNOW (varying-byte slicing, KDF, AES_K(0))
//   - An `unwrap(blob, label)` API that returns raw derived material
//     so callers can experiment with chunk-to-KDF pairings

public enum KAuthError: Error {
    case wrongBlobSize(Int)
    case wrongLabelSize(Int)
    case unwrapNotYetSpecified
    case tagMismatch
}

public struct KAuthFields: Equatable {
    public let r1: Data
    public let r2: Data
    public let nonce1: Data
    public let kEnc: Data
    public let ivEnc: Data
    public let exportedKAuth: Data
}

/// The 4 decrypted ciphertext blocks of a kAuth blob (plaintext form).
///
/// The iOS pristine `Libre3.CGMSensor` class declares 7 instance fields
/// (verified via `__swift5_reflstr` extraction 2026-05-03):
///   patchEphemeral, r1, r2, nonce1, kEnc, ivEnc, exportedkAuth.
///
/// Of these, `patchEphemeral`, `r1`, `r2` come from the BLE wire flow
/// (Phase 4 / Phase 5 / Phase 6 respectively) — NOT from the kAuth
/// blob. The remaining 4 (nonce1, kEnc, ivEnc, exportedkAuth) are
/// stored encrypted in the kAuth blob and recovered via this unwrap.
///
/// **Hypothesized mapping** (in Swift declaration order, which usually
/// matches blob layout):
///   blockA (16B) → nonce1
///   blockB (24B) → kEnc (16B) + 8B trailing pad
///   blockC (16B) → ivEnc
///   blockD (20B) → exportedkAuth (16B) + 4B trailing pad
///
/// The mapping is unverified pending end-to-end sensor pairing test.
public struct UnwrappedKAuth: Equatable, Sendable {
    /// Block A: 16 bytes from blob[49..65]. Hypothesized = `nonce1`.
    public let blockA: Data
    /// Block B: 24 bytes from blob[69..93]. Hypothesized = `kEnc` (first 16B) + 8B pad.
    public let blockB: Data
    /// Block C: 16 bytes from blob[97..113]. Hypothesized = `ivEnc`.
    public let blockC: Data
    /// Block D: 20 bytes from blob[129..149]. Hypothesized = `exportedkAuth` (first 16B) + 4B pad.
    public let blockD: Data
    /// 12-byte nonce from blob[0..12] (= label used for KBKDF).
    public let nonce12: Data

    // MARK: - Hypothesized field accessors

    /// Hypothesized `nonce1` field — first 16 bytes of blockA.
    public var nonce1: Data { blockA }

    /// Hypothesized `kEnc` field — first 16 bytes of blockB.
    public var kEnc: Data { blockB.prefix(16) }

    /// Hypothesized `ivEnc` field — first 16 bytes of blockC.
    public var ivEnc: Data { blockC }

    /// Hypothesized `exportedkAuth` field — first 16 bytes of blockD.
    public var exportedkAuth: Data { blockD.prefix(16) }
}

public enum KAuth {

    /// Total kAuth blob size as observed across all captures.
    public static let blobSize = 149

    /// The 5 byte-ranges that vary per-session (encrypted content).
    public static let variableRanges: [Range<Int>] = [
        0..<4,       // 4B — nonce/session id
        49..<65,     // 16B — encrypted block A
        69..<93,     // 24B — encrypted block B
        97..<113,    // 16B — encrypted block C
        129..<149,   // 20B — trailer (tag + 4B?)
    ]

    /// Pull the static K1, K2 from the blob (verbatim copies of lib data).
    public static func staticKeys(from blob: Data) throws -> (k1: Data, k2: Data) {
        guard blob.count == blobSize else { throw KAuthError.wrongBlobSize(blob.count) }
        let k1 = blob.subdata(in: 17..<33)
        let k2 = blob.subdata(in: 33..<49)
        return (k1, k2)
    }

    /// Extract the 12-byte KBKDF label from a wrapped blob.
    ///
    /// The lib's SecureData IMPORT format places the 12-byte label in
    /// plaintext at the start of the blob. Verified against the captured
    /// DBKey wrap blob (`captures/pristine_realm_2026_05_02/db_identifier_wrapped_57b.bin`)
    /// where bytes `[0..12)` = `0747879091d4babe26957e76` = the captured
    /// LLDB label = the bytes at ctx+0xcc8 in every cf_ctx dump.
    ///
    /// For kAuth blobs, this is `nonce_4B || header_8B`, giving a
    /// per-session-unique label.
    public static func extractLabel(from blob: Data) throws -> Data {
        guard blob.count >= 12 else { throw KAuthError.wrongBlobSize(blob.count) }
        return blob.subdata(in: 0..<12)
    }

    /// Concatenate the variable bytes of a kAuth blob into an 80B sequence.
    public static func variableBytes(from blob: Data) throws -> Data {
        guard blob.count == blobSize else { throw KAuthError.wrongBlobSize(blob.count) }
        var out = Data()
        out.reserveCapacity(80)
        for r in variableRanges {
            out.append(blob.subdata(in: r))
        }
        return out
    }

    /// Run the lib's KBKDF: `block_i = aes_K(label_12B || i_BE32)` for i in 1..n.
    public static func kdf(label: Data, blockCount: Int) throws -> Data {
        return try kdf(label: label, startCounter: 1, blockCount: blockCount)
    }

    /// KBKDF with explicit starting counter. The decrypt keystream uses
    /// counters [2..5]; counter=1 is reserved for the tag-mask block (S0).
    public static func kdf(label: Data, startCounter: Int, blockCount: Int) throws -> Data {
        guard label.count == 12 else { throw KAuthError.wrongLabelSize(label.count) }
        var out = Data()
        out.reserveCapacity(blockCount * 16)
        for i in startCounter ..< (startCounter + blockCount) {
            var input = Data(label)
            input.append(UInt8((i >> 24) & 0xff))
            input.append(UInt8((i >> 16) & 0xff))
            input.append(UInt8((i >>  8) & 0xff))
            input.append(UInt8(i         & 0xff))
            out.append(try CipherFn.aes_K(input))
        }
        return out
    }

    /// Decrypt a wrapped blob via the verified XOR-CTR algorithm.
    ///
    /// Verified bit-exact 2026-05-03 against the captured DBKey wrap pair
    /// (`captures/pristine_realm_2026_05_02/db_identifier_wrapped_57b.bin`
    /// → `realm_db_key_64b.bin`):
    ///
    /// ```
    /// label = blob[0..12]
    /// keystream = AES_K(label || 0x00000002) || AES_K(label || 0x00000003)
    ///           || AES_K(label || 0x00000004) || AES_K(label || 0x00000005)
    /// plaintext = blob[12..] XOR keystream[0..(blob.count - 12)]
    /// ```
    ///
    /// counter=1 (`KAuth.kdf(label, startCounter:1, blockCount:1)`) is
    /// reserved for the tag-mask block S0; the actual encryption keystream
    /// starts at counter=2. This matches the SKB engine's lib+0x5d6a40 core
    /// (CCM-family CTR mode with counter offset of 1).
    public static func ctrDecrypt(blob: Data) throws -> Data {
        guard blob.count >= 12 else { throw KAuthError.wrongBlobSize(blob.count) }
        let label = try extractLabel(from: blob)
        let body = Array(blob.subdata(in: 12..<blob.count))   // re-index from 0
        let blocksNeeded = max((body.count + 15) / 16, 1)
        let keystream = Array(try kdf(label: label, startCounter: 2, blockCount: blocksNeeded))
        return Data((0..<body.count).map { body[$0] ^ keystream[$0] })
    }

    /// Unwrap a 149-byte kAuth blob into its 4 plaintext ciphertext-blocks
    /// plus the 12-byte nonce/label.
    ///
    /// The kAuth blob has SCATTERED encryption: 4 ciphertext regions
    /// interspersed with K1/K2 plaintext + counter prefixes (see
    /// memory `kauth-blob-format-decoded.md`). The XOR-CTR decryption
    /// uses a single contiguous keystream `KDF[2..N]`; we map each
    /// encrypted region to the corresponding sequential keystream
    /// segment.
    ///
    /// **Hypothesis** — same algorithm that's bit-exact-verified for
    /// DBKey unwrap. Cannot directly validate against pristine without
    /// runtime capture (blocked per memory `lldb-early-attach-blocked.md`).
    /// End-to-end sensor-pairing test is the validation oracle.
    public static func unwrap149Blob(_ blob: Data) throws -> UnwrappedKAuth {
        guard blob.count == blobSize else { throw KAuthError.wrongBlobSize(blob.count) }
        let label = try extractLabel(from: blob)

        // Per `variableRanges` minus the leading nonce: 4 encrypted blocks
        // at blob[49..65], blob[69..93], blob[97..113], blob[129..149].
        // Total = 16 + 24 + 16 + 20 = 76 bytes.
        let encrypted: [Range<Int>] = [49..<65, 69..<93, 97..<113, 129..<149]
        let totalEnc = encrypted.map { $0.count }.reduce(0, +)
        precondition(totalEnc == 76)

        // Generate enough keystream (5 blocks = 80B is sufficient)
        let keystream = Array(try kdf(label: label, startCounter: 2, blockCount: 5))

        // Sequentially map each encrypted region to the next chunk of keystream
        var ksOffset = 0
        var blocks: [Data] = []
        for range in encrypted {
            let ciphertext = Array(blob.subdata(in: range))
            let plaintext = Data((0..<ciphertext.count).map {
                ciphertext[$0] ^ keystream[ksOffset + $0]
            })
            blocks.append(plaintext)
            ksOffset += ciphertext.count
        }

        return UnwrappedKAuth(
            blockA: blocks[0],
            blockB: blocks[1],
            blockC: blocks[2],
            blockD: blocks[3],
            nonce12: label
        )
    }

    /// Compute L = AES_K(0^16). This is the GHASH subkey H if the lib uses GCM.
    public static func ghashSubkey() throws -> Data {
        try CipherFn.aes_K(Data(count: 16))
    }

    /// Unwrap a kAuth blob. The 12-byte KBKDF label is extracted from
    /// the blob's first 12 bytes (the SecureData IMPORT format places it
    /// there in plaintext — see file header). The exact chunk-to-KDF-block
    /// pairing for the encrypted segments isn't yet pinned down, so this
    /// returns the raw derived material for callers to experiment with.
    public static func unwrap(blob: Data) throws -> UnwrapMaterial {
        guard blob.count == blobSize else { throw KAuthError.wrongBlobSize(blob.count) }
        let label    = try extractLabel(from: blob)          // 12 B = blob[0..12]
        let varBytes = try variableBytes(from: blob)         // 80 B
        let H        = try ghashSubkey()                      // L (likely GCM GHASH H)
        let kdf      = try kdf(label: label, blockCount: 5)   // 80 B
        return UnwrapMaterial(varBytes: varBytes, H: H, kdf: kdf)
    }

    /// Variant taking an explicit label, for replay against captured ctx
    /// where the label was captured separately (e.g., DBKey unwrap captures).
    public static func unwrap(blob: Data, label: Data) throws -> UnwrapMaterial {
        guard blob.count == blobSize else { throw KAuthError.wrongBlobSize(blob.count) }
        guard label.count == 12 else { throw KAuthError.wrongLabelSize(label.count) }
        let varBytes = try variableBytes(from: blob)        // 80 B
        let H        = try ghashSubkey()                     // L (likely GCM GHASH H)
        let kdf      = try kdf(label: label, blockCount: 5)  // 80 B
        return UnwrapMaterial(varBytes: varBytes, H: H, kdf: kdf)
    }

    /// Raw derived material from `unwrap`. Once the chunk-to-KDF pairing is
    /// nailed down, the actual `KAuthFields` will be derived here and the
    /// API will switch to returning `KAuthFields` directly.
    public struct UnwrapMaterial: Sendable {
        public let varBytes: Data    // 80 B of per-session ciphertext+tag
        public let H: Data            // 16 B AES_K(0) — likely GCM GHASH subkey
        public let kdf: Data          // 80 B = KDF[1..5] concatenated
    }
}
