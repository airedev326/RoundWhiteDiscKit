import Foundation

// Post-pairing data plane wire format.
//
// Decoded from live BLE captures: encrypted post-authorization notifications
// share the same outer framing:
//
//     [ encrypted_payload | seq_byte | type_byte (often 0x00) ]
//
// `seq_byte` is a per-channel monotonic counter advancing 0x01..0x0n.
//
// `type_byte` distinguishes record kinds within a channel; for the
// realtime/backfill streams it has been observed as 0x00.
//
// The `encrypted_payload` is AES-CCM-128 ciphertext under the session
// key derived during pairing. The CCM nonce is per-channel + seq;
// exact construction is still under investigation (see
// `findings/IPHONE_POC_PLAN.md` Gap #1).
//
// `DataFrame` parses the OUTER framing; it does NOT decrypt. Callers
// pass the parsed `encrypted` bytes to `DataPlaneCrypto` once a session key is
// available.

public struct DataFrame: Equatable, Sendable {
    public let encrypted: Data
    public let seq: UInt8
    public let type: UInt8

    public static func parse(_ raw: Data) throws -> DataFrame {
        guard raw.count >= 3 else { throw DataFrameError.tooShort(raw.count) }
        let trailerStart = raw.endIndex - 2
        let encrypted = raw.subdata(in: raw.startIndex..<trailerStart)
        let seq = raw[trailerStart]
        let type = raw[trailerStart + 1]
        return DataFrame(encrypted: encrypted, seq: seq, type: type)
    }

    /// The final two bytes are carried on the wire little-endian. Earlier
    /// notes called them `[seq, type]`; data-plane CCM nonce construction uses
    /// them as the 16-bit packet sequence.
    public var sequenceNumber: UInt16 {
        UInt16(seq) | (UInt16(type) << 8)
    }

    /// Encode for the wire — useful for round-trip tests and for any
    /// path that builds frames on the phone side (e.g. session-control
    /// writes on handle 0x0011).
    public var raw: Data {
        var out = Data(capacity: encrypted.count + 2)
        out.append(encrypted)
        out.append(seq)
        out.append(type)
        return out
    }
}

public enum DataFrameError: Error, Equatable {
    case tooShort(Int)
}
