import Foundation

// Clean-room port of Abbott's Phase 5 block primitive:
//   key setup:     lib+0x5dec48..0x5defb0
//   block encrypt: lib+0x5e41b4..0x5e45e4
//   wire block:    lib+0x5defec..0x5df414
//
// This is a table-driven AES-like primitive, not CommonCrypto AES. The static
// tables (libaes_*) come from the installed runtime-tables blob.

public enum LibAESError: Error {
    case missingResource(String)
    case invalidKeyLength(Int)
    case invalidInputLength(Int)
    case invalidContextLength(Int)
}

public enum LibAES {
    public static let contextSize = 0x10b0

    public static func blockEncryptor(rawKey: Data) throws -> AESBlockEncrypt {
        let ctx = try keySetup(rawKey: rawKey)
        return { block in
            try blockEncrypt(block, context: ctx)
        }
    }

    public static func phase5BlockEncryptor(rawKey: Data) throws -> AESBlockEncrypt {
        let ctx = try keySetup(rawKey: rawKey)
        return { block in
            try phase5BlockEncrypt(block, context: ctx)
        }
    }

    public static func keySetup(rawKey: Data) throws -> Data {
        guard rawKey.count == 16 else { throw LibAESError.invalidKeyLength(rawKey.count) }
        let t = try LibAESTables.shared.get()
        var ctx = [UInt8](repeating: 0, count: contextSize)
        ctx.replaceSubrange(0..<16, with: rawKey)

        var outOff = 0x10
        var constA = 0x08     // 0x276bc4 - 0x276bbc
        var constB = 0xa8     // 0x276c64 - 0x276bbc
        var loopCtr = -4
        var w13 = libAESReadU32(ctx, 0x0c)

        while true {
            let w14 = libAESReadU32(t.keyexpConsts, constA - 8)
            loopCtr += 4
            let keepGoing = loopCtr < 0x24

            w13 = u32(w14 ^ ror32(w13, 24))
            var sub = subword(table: t.keyexpTables, value: w13, group: 0)
            let prev0 = libAESReadU32(ctx, outOff - 0x10)
            let prev1 = libAESReadU32(ctx, outOff - 0x0c)
            var w15 = u32(prev0 ^ libAESReadU32(t.keyexpConsts, constB - 8))
            w13 = u32(w15 ^ sub)
            putU32(&ctx, outOff, w13)

            w13 = u32(libAESReadU32(t.keyexpConsts, constA - 4) ^ w13)
            sub = subword(table: t.keyexpTables, value: w13, group: 1)
            var w14Mix = u32(prev1 ^ libAESReadU32(t.keyexpConsts, constB - 4))
            w13 = u32(w14Mix ^ sub)
            putU32(&ctx, outOff + 0x04, w13)

            w13 = u32(libAESReadU32(t.keyexpConsts, constA) ^ w13)
            sub = subword(table: t.keyexpTables, value: w13, group: 2)
            let prev2 = libAESReadU32(ctx, outOff - 0x08)
            let prev3 = libAESReadU32(ctx, outOff - 0x04)
            w15 = u32(prev2 ^ libAESReadU32(t.keyexpConsts, constB))
            w13 = u32(w15 ^ sub)
            putU32(&ctx, outOff + 0x08, w13)

            w13 = u32(libAESReadU32(t.keyexpConsts, constA + 0x04) ^ w13)
            constA += 0x10
            sub = subword(table: t.keyexpTables, value: w13, group: 3)
            w14Mix = u32(prev3 ^ libAESReadU32(t.keyexpConsts, constB + 0x04))
            constB += 0x10
            w13 = u32(w14Mix ^ sub)
            putU32(&ctx, outOff + 0x0c, w13)

            outOff += 0x10
            if !keepGoing { break }
        }

        for group in 0..<4 {
            let off = 0xa0 + group * 4
            putU32(&ctx, off, subword(table: t.finalKeyTables, value: libAESReadU32(ctx, off), group: group))
        }

        for tableIdx in 0..<16 {
            let wordTableIdx = Int(libAESReadU32(t.finalTableIndex, tableIdx * 4))
            let wordTableBase = wordTableIdx * 0x400
            let mapBase = tableIdx * 0x100
            let keyWord = libAESReadU32(ctx, 0xa0 + (tableIdx >> 2) * 4)
            let shift = UInt32(24 - 8 * (tableIdx & 3))
            let dst = 0xb0 + tableIdx * 0x100

            for i in 0..<256 {
                let mixed = u32(keyWord ^ libAESReadU32(t.finalTableWords, wordTableBase + i * 4))
                ctx[dst + i] = t.finalTableMap[mapBase + Int((mixed >> shift) & 0xff)]
            }
        }

        return Data(ctx)
    }

    public static func blockEncrypt(_ plaintext: Data, context ctx: Data) throws -> Data {
        guard plaintext.count == 16 else { throw LibAESError.invalidInputLength(plaintext.count) }
        guard ctx.count >= contextSize else { throw LibAESError.invalidContextLength(ctx.count) }

        let t = try LibAESTables.shared.get()
        let pt = [UInt8](plaintext)
        let ctxBytes = [UInt8](ctx)

        var state = [UInt8](repeating: 0, count: 16)
        for c in 0..<4 {
            for r in 0..<4 {
                let ti = c * 4 + (3 - r)
                state[c * 4 + r] = t.round1Tables[ti * 0x100 + Int(pt[ti])] ^ ctxBytes[c * 4 + r]
            }
        }

        var w16 = libAESReadU32(state, 0)
        var w17 = libAESReadU32(state, 4)
        var w14 = libAESReadU32(state, 8)
        var w13 = libAESReadU32(state, 12)
        var x8 = 0
        var w11: UInt32 = 0
        var w15: UInt32 = 0

        while true {
            w11 = w17 & 0xff
            w15 = ubfx(w13, 16, 8)
            var w0 = ubfx(w14, 8, 8)
            var x11i = w11
            var w3 = w16 >> 24
            var w6 = libAESReadU32(ctxBytes, 0x10 + x8)
            var w7 = libAESReadU32(ctxBytes, 0x14 + x8)
            var x15i = w15
            var x0i = w0
            w11 = tableWord(t.round2Tables, table: 7, index: x11i)
            var w5 = w14 & 0xff
            var w4 = ubfx(w13, 8, 8)
            w3 = tableWord(t.round2Tables, table: 0, index: w3)
            var x5i = w5
            w15 = tableWord(t.round2Tables, table: 13, index: x15i)
            w0 = tableWord(t.round2Tables, table: 10, index: x0i)
            w11 = u32(w11 ^ w6)
            w6 = ubfx(w16, 16, 8)
            var w19 = w17 >> 24
            w11 = u32(w11 ^ w15)
            w15 = u32(w0 ^ w3)
            x0i = w4
            w3 = tableWord(t.round2Tables, table: 11, index: x5i)
            var x4i = w6
            x5i = w19
            w6 = w13 & 0xff
            w0 = tableWord(t.round2Tables, table: 14, index: x0i)
            w19 = w14 >> 24
            w4 = tableWord(t.round2Tables, table: 1, index: x4i)
            w5 = tableWord(t.round2Tables, table: 4, index: x5i)
            var x6i = w6
            w3 = u32(w3 ^ w7)
            let x7i = w19
            w11 = u32(w11 ^ w15)
            w15 = u32(w3 ^ w0)
            w0 = u32(w4 ^ w5)
            w6 = tableWord(t.round2Tables, table: 15, index: x6i)
            w19 = libAESReadU32(ctxBytes, 0x18 + x8)
            w4 = libAESReadU32(ctxBytes, 0x1c + x8)
            w3 = tableWord(t.round2Tables, table: 8, index: x7i)
            let w7i = ubfx(w17, 16, 8)
            let w14i = ubfx(w14, 16, 8)
            let w17i = ubfx(w17, 8, 8)
            let w13i = w13 >> 24
            w5 = u32(w19 ^ w6)
            let w6i = ubfx(w16, 8, 8)
            let w16i = w16 & 0xff
            let w16t = tableWord(t.round2Tables, table: 3, index: w16i)
            let w7t = tableWord(t.round2Tables, table: 5, index: w7i)
            let w14t = tableWord(t.round2Tables, table: 9, index: w14i)
            let w6t = tableWord(t.round2Tables, table: 2, index: w6i)
            let w17t = tableWord(t.round2Tables, table: 6, index: w17i)
            let w13t = tableWord(t.round2Tables, table: 12, index: w13i)
            w16 = u32(w4 ^ w16t)
            w3 = u32(w5 ^ w3)
            w5 = u32(w6t ^ w7t)
            w14 = u32(w17t ^ w14t)
            w16 = u32(w16 ^ w13t)
            w13 = u32(w15 ^ w0)
            w15 = u32(w3 ^ w5)
            w14 = u32(w14 ^ w16)

            if x8 == 0x80 { break }

            w17 = w13 & 0xff
            w16 = w11 >> 24
            w0 = ubfx(w15, 8, 8)
            w4 = ubfx(w11, 16, 8)
            let x17i = w17
            w5 = w15 & 0xff
            w3 = ubfx(w14, 16, 8)
            w6 = ubfx(w14, 8, 8)
            w16 = tableWord(t.round2Tables, table: 0, index: w16)
            x0i = w0
            x4i = w4
            w17 = tableWord(t.round2Tables, table: 7, index: x17i)
            w7 = w13 >> 24
            x5i = w5
            let x3iFirst = w3
            w0 = tableWord(t.round2Tables, table: 10, index: x0i)
            w4 = tableWord(t.round2Tables, table: 1, index: x4i)
            w16 = u32(w17 ^ w16)
            w17 = tableWord(t.round2Tables, table: 11, index: x5i)
            x5i = w6
            x6i = w7
            w16 = u32(w16 ^ w0)
            w0 = tableWord(t.round2Tables, table: 13, index: x3iFirst)
            let oldX8 = x8
            x8 += 0x20
            w17 = u32(w17 ^ w4)
            w3 = tableWord(t.round2Tables, table: 14, index: x5i)
            w4 = tableWord(t.round2Tables, table: 4, index: x6i)
            w5 = w14 & 0xff
            let w14tmp = w14 >> 24
            w6 = ubfx(w11, 8, 8)
            w3 = u32(w3 ^ w4)
            x5i = w5
            let w11tmp = w11 & 0xff
            let w7rk = libAESReadU32(ctxBytes, 0x20 + oldX8)
            let w4rk = libAESReadU32(ctxBytes, 0x24 + oldX8)
            w17 = u32(w17 ^ w3)
            let x14i = w14tmp
            x11i = w11tmp
            let x3i = w6
            w0 = u32(w0 ^ w7rk)
            w17 = u32(w17 ^ w4rk)
            let w4idx = ubfx(w15, 16, 8)
            w16 = u32(w16 ^ w0)
            w0 = tableWord(t.round2Tables, table: 15, index: x5i)
            let w5idx = ubfx(w13, 8, 8)
            let w15tmp = w15 >> 24
            let w13tmp = ubfx(w13, 16, 8)
            x4i = w4idx
            x5i = w5idx
            let w14v = tableWord(t.round2Tables, table: 12, index: x14i)
            let w11v = tableWord(t.round2Tables, table: 3, index: x11i)
            x15i = w15tmp
            let x13i = w13tmp
            let w4v = tableWord(t.round2Tables, table: 9, index: x4i)
            let w6rk = libAESReadU32(ctxBytes, 0x28 + oldX8)
            let w12rk = libAESReadU32(ctxBytes, 0x2c + oldX8)
            let w5v = tableWord(t.round2Tables, table: 6, index: x5i)
            let w3v = tableWord(t.round2Tables, table: 2, index: x3i)
            let w15v = tableWord(t.round2Tables, table: 8, index: x15i)
            let w13v = tableWord(t.round2Tables, table: 5, index: x13i)
            w11 = u32(w14v ^ w11v)
            w0 = u32(w0 ^ w6rk)
            w4 = u32(w5v ^ w4v)
            w14 = u32(w0 ^ w3v)
            w13 = u32(w15v ^ w13v)
            w11 = u32(w4 ^ w11)
            w14 = u32(w14 ^ w13)
            w13 = u32(w11 ^ w12rk)
        }

        var out = Data(count: 16)
        out[0] = dyn(ctxBytes, 0x0b0, w11 >> 24)
        out[1] = dyn(ctxBytes, 0x1b0, w14 >> 16)
        out[2] = dyn(ctxBytes, 0x2b0, w15 >> 8)
        out[3] = dyn(ctxBytes, 0x3b0, w13)
        out[4] = dyn(ctxBytes, 0x4b0, w13 >> 24)
        out[5] = dyn(ctxBytes, 0x5b0, w11 >> 16)
        out[6] = dyn(ctxBytes, 0x6b0, w14 >> 8)
        out[7] = dyn(ctxBytes, 0x7b0, w15)
        out[8] = dyn(ctxBytes, 0x8b0, w15 >> 24)
        out[9] = dyn(ctxBytes, 0x9b0, w13 >> 16)
        out[10] = dyn(ctxBytes, 0xab0, w11 >> 8)
        out[11] = dyn(ctxBytes, 0xbb0, w14)
        out[12] = dyn(ctxBytes, 0xcb0, w14 >> 24)
        out[13] = dyn(ctxBytes, 0xdb0, w15 >> 16)
        out[14] = dyn(ctxBytes, 0xeb0, w13 >> 8)
        out[15] = dyn(ctxBytes, 0xfb0, w11)
        return out
    }

    public static func phase5BlockEncrypt(_ plaintext: Data, context ctx: Data) throws -> Data {
        guard plaintext.count == 16 else { throw LibAESError.invalidInputLength(plaintext.count) }
        guard ctx.count >= contextSize else { throw LibAESError.invalidContextLength(ctx.count) }

        let t = try LibAESTables.shared.get()
        let pt = [UInt8](plaintext)
        let ctxBytes = [UInt8](ctx)
        let r1 = t.phase5Round1Tables

        var w16 = u32(
            libAESReadU32(ctxBytes, 0x00)
            ^ (UInt32(r1[0x000 + Int(pt[0])]) << 24)
            ^ (UInt32(r1[0x100 + Int(pt[1])]) << 16)
            ^ (UInt32(r1[0x200 + Int(pt[2])]) << 8)
            ^ UInt32(r1[0x300 + Int(pt[3])])
        )
        var w14 = u32(
            libAESReadU32(ctxBytes, 0x04)
            ^ (UInt32(r1[0x400 + Int(pt[4])]) << 24)
            ^ (UInt32(r1[0x500 + Int(pt[5])]) << 16)
            ^ (UInt32(r1[0x600 + Int(pt[6])]) << 8)
            ^ UInt32(r1[0x700 + Int(pt[7])])
        )
        var w13 = u32(
            libAESReadU32(ctxBytes, 0x08)
            ^ (UInt32(r1[0x800 + Int(pt[8])]) << 24)
            ^ (UInt32(r1[0x900 + Int(pt[9])]) << 16)
            ^ (UInt32(r1[0xa00 + Int(pt[10])]) << 8)
            ^ UInt32(r1[0xb00 + Int(pt[11])])
        )
        var w15 = u32(
            libAESReadU32(ctxBytes, 0x0c)
            ^ (UInt32(r1[0xc00 + Int(pt[12])]) << 24)
            ^ (UInt32(r1[0xd00 + Int(pt[13])]) << 16)
            ^ (UInt32(r1[0xe00 + Int(pt[14])]) << 8)
            ^ UInt32(r1[0xf00 + Int(pt[15])])
        )

        var x8 = 0
        var w11: UInt32 = 0
        while true {
            (w11, w14, w13, w15) = phase5FirstHalf(t.phase5RoundTables, w16: w16, w14: w14, w13: w13, w15: w15, ctx: ctxBytes, x8: x8)
            if x8 == 0x80 { break }
            (w16, w14, w13, w15) = phase5SecondHalf(t.phase5RoundTables, w11: w11, w14: w14, w13: w13, w15: w15, ctx: ctxBytes, x8: x8)
            x8 += 0x20
        }

        var out = Data(count: 16)
        out[0] = dyn(ctxBytes, 0x0b0, w11 >> 24)
        out[1] = dyn(ctxBytes, 0x1b0, w14 >> 16)
        out[2] = dyn(ctxBytes, 0x2b0, w13 >> 8)
        out[3] = dyn(ctxBytes, 0x3b0, w15)
        out[4] = dyn(ctxBytes, 0x4b0, w14 >> 24)
        out[5] = dyn(ctxBytes, 0x5b0, w13 >> 16)
        out[6] = dyn(ctxBytes, 0x6b0, w15 >> 8)
        out[7] = dyn(ctxBytes, 0x7b0, w11)
        out[8] = dyn(ctxBytes, 0x8b0, w13 >> 24)
        out[9] = dyn(ctxBytes, 0x9b0, w15 >> 16)
        out[10] = dyn(ctxBytes, 0xab0, w11 >> 8)
        out[11] = dyn(ctxBytes, 0xbb0, w14)
        out[12] = dyn(ctxBytes, 0xcb0, w15 >> 24)
        out[13] = dyn(ctxBytes, 0xdb0, w11 >> 16)
        out[14] = dyn(ctxBytes, 0xeb0, w14 >> 8)
        out[15] = dyn(ctxBytes, 0xfb0, w13)
        return out
    }
}

// MARK: - Private helpers

@inline(__always) private func u32(_ x: UInt32) -> UInt32 { x }

@inline(__always) private func ubfx(_ x: UInt32, _ lsb: Int, _ width: Int) -> UInt32 {
    (x >> UInt32(lsb)) & ((UInt32(1) << UInt32(width)) - 1)
}

@inline(__always) private func ror32(_ x: UInt32, _ shift: Int) -> UInt32 {
    (x >> UInt32(shift)) | (x << UInt32(32 - shift))
}

@inline(__always) private func libAESReadU32(_ b: [UInt8], _ off: Int) -> UInt32 {
    UInt32(b[off]) | (UInt32(b[off + 1]) << 8) | (UInt32(b[off + 2]) << 16) | (UInt32(b[off + 3]) << 24)
}

@inline(__always) private func putU32(_ b: inout [UInt8], _ off: Int, _ v: UInt32) {
    b[off] = UInt8(v & 0xff)
    b[off + 1] = UInt8((v >> 8) & 0xff)
    b[off + 2] = UInt8((v >> 16) & 0xff)
    b[off + 3] = UInt8((v >> 24) & 0xff)
}

@inline(__always) private func subword(table: [UInt8], value: UInt32, group: Int) -> UInt32 {
    let base = group * 0x400
    let b0 = Int(value & 0xff)
    let b1 = Int((value >> 8) & 0xff)
    let b2 = Int((value >> 16) & 0xff)
    let b3 = Int((value >> 24) & 0xff)
    return UInt32(table[base + 0x300 + b0])
        | (UInt32(table[base + 0x100 + b2]) << 16)
        | (UInt32(table[base + 0x200 + b1]) << 8)
        | (UInt32(table[base + b3]) << 24)
}

@inline(__always) private func tableWord(_ table: [UInt32], table tableIdx: Int, index: UInt32) -> UInt32 {
    table[tableIdx * 256 + Int(index & 0xff)]
}

@inline(__always) private func dyn(_ ctx: [UInt8], _ off: Int, _ idx: UInt32) -> UInt8 {
    ctx[off + Int(idx & 0xff)]
}

private func phase5FirstHalf(
    _ t: [UInt32],
    w16: UInt32,
    w14: UInt32,
    w13: UInt32,
    w15: UInt32,
    ctx: [UInt8],
    x8: Int
) -> (UInt32, UInt32, UInt32, UInt32) {
    let rk0 = libAESReadU32(ctx, 0x10 + x8)
    let rk1 = libAESReadU32(ctx, 0x14 + x8)
    let rk2 = libAESReadU32(ctx, 0x18 + x8)
    let rk3 = libAESReadU32(ctx, 0x1c + x8)

    let out11 = u32(
        tableWord(t, table: 0, index: w16 >> 24)
        ^ rk0
        ^ tableWord(t, table: 15, index: w15)
        ^ tableWord(t, table: 5, index: ubfx(w14, 16, 8))
        ^ tableWord(t, table: 10, index: ubfx(w13, 8, 8))
    )

    let out14 = u32(
        (rk1 ^ tableWord(t, table: 3, index: w16) ^ tableWord(t, table: 9, index: ubfx(w13, 16, 8)))
        ^ (tableWord(t, table: 4, index: w14 >> 24) ^ tableWord(t, table: 14, index: ubfx(w15, 8, 8)))
    )

    let out13 = u32(
        tableWord(t, table: 13, index: ubfx(w15, 16, 8))
        ^ tableWord(t, table: 7, index: w14)
        ^ tableWord(t, table: 2, index: ubfx(w16, 8, 8))
        ^ tableWord(t, table: 8, index: w13 >> 24)
        ^ rk2
    )

    let out15 = u32(
        (tableWord(t, table: 6, index: ubfx(w14, 8, 8)) ^ rk3)
        ^ (tableWord(t, table: 12, index: w15 >> 24) ^ tableWord(t, table: 11, index: w13))
        ^ tableWord(t, table: 1, index: ubfx(w16, 16, 8))
    )

    return (out11, out14, out13, out15)
}

private func phase5SecondHalf(
    _ t: [UInt32],
    w11: UInt32,
    w14: UInt32,
    w13: UInt32,
    w15: UInt32,
    ctx: [UInt8],
    x8: Int
) -> (UInt32, UInt32, UInt32, UInt32) {
    let rk0 = libAESReadU32(ctx, 0x20 + x8)
    let rk1 = libAESReadU32(ctx, 0x24 + x8)
    let rk2 = libAESReadU32(ctx, 0x28 + x8)
    let rk3 = libAESReadU32(ctx, 0x2c + x8)

    let out16 = u32(
        tableWord(t, table: 15, index: w15)
        ^ tableWord(t, table: 0, index: w11 >> 24)
        ^ tableWord(t, table: 10, index: ubfx(w13, 8, 8))
        ^ tableWord(t, table: 5, index: ubfx(w14, 16, 8))
        ^ rk0
    )

    let out14 = u32(
        (tableWord(t, table: 4, index: w14 >> 24)
            ^ tableWord(t, table: 3, index: w11)
            ^ tableWord(t, table: 14, index: ubfx(w15, 8, 8)))
        ^ rk1
        ^ tableWord(t, table: 9, index: ubfx(w13, 16, 8))
    )

    let out13 = u32(
        (tableWord(t, table: 13, index: ubfx(w15, 16, 8))
            ^ rk2
            ^ tableWord(t, table: 2, index: ubfx(w11, 8, 8)))
        ^ tableWord(t, table: 8, index: w13 >> 24)
        ^ tableWord(t, table: 7, index: w14)
    )

    let out15 = u32(
        (tableWord(t, table: 11, index: w13)
            ^ tableWord(t, table: 1, index: ubfx(w11, 16, 8))
            ^ rk3)
        ^ (tableWord(t, table: 12, index: w15 >> 24)
            ^ tableWord(t, table: 6, index: ubfx(w14, 8, 8)))
    )

    return (out16, out14, out13, out15)
}

private final class LibAESTables {
    let round1Tables: [UInt8]
    let round2Tables: [UInt32]
    let phase5Round1Tables: [UInt8]
    let phase5RoundTables: [UInt32]
    let keyexpTables: [UInt8]
    let keyexpConsts: [UInt8]
    let finalKeyTables: [UInt8]
    let finalTableIndex: [UInt8]
    let finalTableMap: [UInt8]
    let finalTableWords: [UInt8]

    private init() throws {
        round1Tables = try Self.loadBytes("libaes_round1_tables_278dc2")
        let round2Bytes = try Self.loadBytes("libaes_round2_9_tables_279dc4")
        var words: [UInt32] = []
        words.reserveCapacity(round2Bytes.count / 4)
        for off in stride(from: 0, to: round2Bytes.count, by: 4) {
            words.append(libAESReadU32(round2Bytes, off))
        }
        round2Tables = words
        phase5Round1Tables = try Self.loadBytes("libaes_5defec_round1_tables_26f621")
        keyexpTables = try Self.loadBytes("libaes_keyexp_tables_275bbb")
        keyexpConsts = try Self.loadBytes("libaes_keyexp_consts_276bbc")
        finalKeyTables = try Self.loadBytes("libaes_final_key_tables_276cfc")
        finalTableIndex = try Self.loadBytes("libaes_final_table_index_277cfc")
        finalTableMap = try Self.loadBytes("libaes_final_table_map_277d3c")
        finalTableWords = try Self.loadBytes("libaes_final_table_words_270624")
        var phase5Words: [UInt32] = []
        phase5Words.reserveCapacity(finalTableWords.count / 4)
        for off in stride(from: 0, to: finalTableWords.count, by: 4) {
            phase5Words.append(libAESReadU32(finalTableWords, off))
        }
        phase5RoundTables = phase5Words
    }

    static let shared = SuccessCache { try LibAESTables() }

    private static func loadBytes(_ name: String) throws -> [UInt8] {
        [UInt8](try RemoteRuntimeTables.data(named: name))
    }
}
