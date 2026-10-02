import Foundation

// Two KDF flavors:
//
// 1) `KBKDF.derive(label:length:)` — the lib's ACTUAL construction (verified
//    empirically 2026-05-02). NOT NIST 800-108 CMAC. Plain AES counter mode:
//
//      out_block_i = CipherFn.aes_K(label_12B || counter_4B_BE)   for i ∈ {1, 2, ...}
//
//    See findings/skb_kbkdf_chain.md and memory lib-kbkdf-is-direct-aes-counter.md.
//
// 2) `KBKDF.nist800108(label:context:lBits:)` — standard NIST SP 800-108
//    Counter-mode KBKDF with CMAC-AES128 PRF. Kept here for completeness; the
//    lib does NOT use this construction in any path we've observed.

public enum KBKDF {

    /// Lib's KDF: `out_block_i = aes(label || counter_BE32)`.
    public static func derive(
        label: Data,
        length: Int,
        aes: AESBlockEncrypt = CipherFn.aes_K
    ) throws -> Data {
        guard label.count == 12 else { throw CipherFnError.invalidInputLength(label.count) }
        guard length > 0 else { return Data() }
        var out = Data()
        out.reserveCapacity(((length + 15) / 16) * 16)
        var counter: UInt32 = 1
        while out.count < length {
            var block = Data(label)
            block.append(UInt8((counter >> 24) & 0xff))
            block.append(UInt8((counter >> 16) & 0xff))
            block.append(UInt8((counter >> 8) & 0xff))
            block.append(UInt8(counter & 0xff))
            out.append(try aes(block))
            counter &+= 1
        }
        return out.prefix(length)
    }

    /// NIST SP 800-108 Counter-mode KBKDF, CMAC-AES128 PRF.
    /// `M = i_BE32 || label || 0x00 || context || L_BE32`.
    public static func nist800108(
        label: Data,
        context: Data,
        lBits: Int = 128,
        aes: AESBlockEncrypt = CipherFn.aes_K
    ) throws -> Data {
        let outLen = lBits / 8
        let n = (outLen + 15) / 16
        var output = Data()
        let lField = u32be(UInt32(lBits))
        for i in 1...n {
            var m = Data()
            m.append(u32be(UInt32(i)))
            m.append(label)
            m.append(0x00)
            m.append(context)
            m.append(lField)
            output.append(try AESCMAC.mac(m, aes: aes))
        }
        return output.prefix(outLen)
    }
}

@inline(__always) func u32be(_ x: UInt32) -> Data {
    Data([
        UInt8((x >> 24) & 0xff),
        UInt8((x >> 16) & 0xff),
        UInt8((x >> 8) & 0xff),
        UInt8(x & 0xff),
    ])
}
