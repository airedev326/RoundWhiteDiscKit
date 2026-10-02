import Foundation

// RFC 4493 AES-CMAC, generic over a 16-byte block cipher.
// Default block cipher is the white-box AES_K from CipherFn.

public typealias AESBlockEncrypt = (Data) throws -> Data

public enum AESCMAC {

    /// L = AES_K(0), K1 = double(L), K2 = double(K1).
    public static func subkeys(aes: AESBlockEncrypt = CipherFn.aes_K) throws -> (L: Data, k1: Data, k2: Data) {
        let zero = Data(count: 16)
        let L = try aes(zero)
        let k1 = gf128Double(L)
        let k2 = gf128Double(k1)
        return (L, k1, k2)
    }

    /// RFC 4493 AES-CMAC over `message`.
    public static func mac(_ message: Data, aes: AESBlockEncrypt = CipherFn.aes_K) throws -> Data {
        let (_, k1, k2) = try subkeys(aes: aes)
        var n = (message.count + 15) / 16
        var lastBlock = Data(count: 16)
        var lastXor = k1

        if n == 0 {
            n = 1
            lastBlock[0] = 0x80
            lastXor = k2
        } else {
            let lastStart = (n - 1) * 16
            let lastChunk = message.subdata(in: lastStart..<message.count)
            if lastChunk.count == 16 {
                lastBlock = lastChunk
                lastXor = k1
            } else {
                let padLen = 16 - lastChunk.count
                lastBlock = lastChunk + Data([0x80]) + Data(count: padLen - 1)
                lastXor = k2
            }
        }
        lastBlock = xor(lastBlock, lastXor)

        var X = Data(count: 16)
        for i in 0..<(n - 1) {
            let block = message.subdata(in: (i * 16)..<((i + 1) * 16))
            let Y = xor(X, block)
            X = try aes(Y)
        }
        let Y = xor(X, lastBlock)
        return try aes(Y)
    }

    /// RFC 4493 GF(2^128) doubling with reduction polynomial 0x87.
    static func gf128Double(_ input: Data) -> Data {
        precondition(input.count == 16)
        var out = Data(count: 16)
        var carry: UInt8 = 0
        for i in (0..<16).reversed() {
            let b = input[i]
            out[i] = UInt8((Int(b) << 1) & 0xff) | carry
            carry = (b & 0x80) >> 7
        }
        if (input[0] & 0x80) != 0 {
            out[15] ^= 0x87
        }
        return out
    }
}

@inline(__always) func xor(_ a: Data, _ b: Data) -> Data {
    precondition(a.count == b.count)
    var out = Data(count: a.count)
    for i in 0..<a.count { out[i] = a[i] ^ b[i] }
    return out
}
