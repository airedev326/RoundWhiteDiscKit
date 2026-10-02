import Foundation

extension FirstPairSourceSlice {
    public static func builder5bcf98P256Outputs(
        scalarWindowLE: Data,
        sensorPointXYBE: Data
    ) throws -> Builder5bcf98P256Outputs {
        guard scalarWindowLE.count >= 70 else {
            throw FirstPairSourceSliceError.invalidP256ScalarLength(scalarWindowLE.count)
        }
        guard sensorPointXYBE.count >= 64 else {
            throw FirstPairSourceSliceError.invalidP256PointLength(sensorPointXYBE.count)
        }
        let affine = try P256ScalarMultiplier.AffinePoint(
            xBE: Array(sensorPointXYBE.prefix(32)),
            yBE: Array(sensorPointXYBE.dropFirst(32).prefix(32))
        )
        let product = try P256ScalarMultiplier.multiply(
            scalarLE: Array(scalarWindowLE.prefix(70)),
            point: affine
        )
        return Builder5bcf98P256Outputs(
            xOutput70: product.x.littleEndianPadded70,
            yOutput70: product.y.littleEndianPadded70
        )
    }

    public static func builder6388f0HighSeedStreamStartSeedsFromScalarP256(
        scalarWindowLE: Data,
        sensorPointXYBE: Data,
        x1Source: Data? = nil,
        x2Source: Data? = nil,
        scalar: UInt64? = nil
    ) throws -> Builder6388f0HighSeedStreamStartSeeds {
        let outputs = try builder5bcf98P256Outputs(
            scalarWindowLE: scalarWindowLE,
            sensorPointXYBE: sensorPointXYBE
        )
        return try builder6388f0HighSeedStreamStartSeedsFrom5bcf98Outputs(
            firstOutput70: outputs.xOutput70,
            secondOutput70: outputs.yOutput70,
            x1Source: x1Source,
            x2Source: x2Source,
            scalar: scalar
        )
    }
}

private enum P256ScalarMultiplier {
    struct AffinePoint {
        let x: Field
        let y: Field

        init(xBE: [UInt8], yBE: [UInt8]) throws {
            let x = try Field(bigEndian32: xBE)
            let y = try Field(bigEndian32: yBE)
            let rhs = x.squared() * x - x.times3() + Field.b
            guard y.squared() == rhs else {
                throw FirstPairSourceSliceError.invalidP256Point
            }
            self.x = x
            self.y = y
        }

        init(x: Field, y: Field) {
            self.x = x
            self.y = y
        }
    }

    private struct JacobianPoint {
        var x: Field
        var y: Field
        var z: Field
        var infinity: Bool

        static let infinity = JacobianPoint(x: .zero, y: .one, z: .zero, infinity: true)

        init(_ affine: AffinePoint) {
            self.x = affine.x
            self.y = affine.y
            self.z = .one
            self.infinity = false
        }

        init(x: Field, y: Field, z: Field, infinity: Bool = false) {
            self.x = x
            self.y = y
            self.z = z
            self.infinity = infinity
        }
    }

    static func multiply(scalarLE: [UInt8], point: AffinePoint) throws -> AffinePoint {
        guard let topBit = highestSetBit(scalarLE) else {
            throw FirstPairSourceSliceError.invalidP256Point
        }
        var result = JacobianPoint.infinity
        for bit in stride(from: topBit, through: 0, by: -1) {
            result = double(result)
            if scalarBit(scalarLE, bit) {
                result = addMixed(result, point)
            }
        }
        return try affine(result)
    }

    private static func double(_ point: JacobianPoint) -> JacobianPoint {
        if point.infinity || point.y == .zero {
            return .infinity
        }

        let yy = point.y.squared()
        let yyyy = yy.squared()
        let zz = point.z.squared()
        let zzzz = zz.squared()
        let s = (point.x * yy).times4()
        let m = (point.x.squared() - zzzz).times3()
        let x3 = m.squared() - s.doubled()
        let y3 = m * (s - x3) - yyyy.times8()
        let z3 = point.y.doubled() * point.z
        return JacobianPoint(x: x3, y: y3, z: z3)
    }

    private static func addMixed(_ point: JacobianPoint, _ addend: AffinePoint) -> JacobianPoint {
        if point.infinity {
            return JacobianPoint(addend)
        }

        let z1z1 = point.z.squared()
        let u2 = addend.x * z1z1
        let s2 = addend.y * point.z * z1z1
        let h = u2 - point.x
        if h == .zero {
            return s2 == point.y ? double(point) : .infinity
        }

        let hh = h.squared()
        let i = hh.times4()
        let j = h * i
        let r = (s2 - point.y).doubled()
        let v = point.x * i
        let x3 = r.squared() - j - v.doubled()
        let y3 = r * (v - x3) - (point.y * j).doubled()
        let z3 = (point.z + h).squared() - z1z1 - hh
        return JacobianPoint(x: x3, y: y3, z: z3)
    }

    private static func affine(_ point: JacobianPoint) throws -> AffinePoint {
        guard !point.infinity else {
            throw FirstPairSourceSliceError.invalidP256Point
        }
        let zInv = point.z.inverted()
        let zInv2 = zInv.squared()
        let zInv3 = zInv2 * zInv
        return AffinePoint(
            x: point.x * zInv2,
            y: point.y * zInv3
        )
    }

    private static func highestSetBit(_ scalarLE: [UInt8]) -> Int? {
        for byteIndex in stride(from: scalarLE.count - 1, through: 0, by: -1) {
            let byte = scalarLE[byteIndex]
            if byte == 0 {
                continue
            }
            for bit in stride(from: 7, through: 0, by: -1) where (byte & UInt8(1 << bit)) != 0 {
                return byteIndex * 8 + bit
            }
        }
        return nil
    }

    private static func scalarBit(_ scalarLE: [UInt8], _ bit: Int) -> Bool {
        ((scalarLE[bit / 8] >> UInt8(bit & 7)) & 1) != 0
    }
}

private struct Field: Equatable {
    var l0: UInt64
    var l1: UInt64
    var l2: UInt64
    var l3: UInt64

    static let zero = Field(0, 0, 0, 0)
    static let one = Field(1, 0, 0, 0)
    static let modulus = Field(0xffff_ffff_ffff_ffff, 0x0000_0000_ffff_ffff, 0, 0xffff_ffff_0000_0001)
    static let carryCorrection = Field(1, 0xffff_ffff_0000_0000, 0xffff_ffff_ffff_ffff, 0x0000_0000_ffff_fffe)
    static let b = Field(0x3bce_3c3e_27d2_604b, 0x651d_06b0_cc53_b0f6, 0xb3eb_bd55_7698_86bc, 0x5ac6_35d8_aa3a_93e7)

    init(_ l0: UInt64, _ l1: UInt64, _ l2: UInt64, _ l3: UInt64) {
        self.l0 = l0
        self.l1 = l1
        self.l2 = l2
        self.l3 = l3
    }

    init(limbs: [UInt64]) {
        self.init(limbs[0], limbs[1], limbs[2], limbs[3])
    }

    init(bigEndian32 bytes: [UInt8]) throws {
        guard bytes.count == 32 else {
            throw FirstPairSourceSliceError.invalidP256PointLength(bytes.count)
        }
        self.init(
            Self.readUInt64BE(bytes, 24),
            Self.readUInt64BE(bytes, 16),
            Self.readUInt64BE(bytes, 8),
            Self.readUInt64BE(bytes, 0)
        )
    }

    var limbs: [UInt64] { [l0, l1, l2, l3] }

    var littleEndianPadded70: Data {
        var out = Data()
        out.reserveCapacity(70)
        for limb in limbs {
            var value = limb.littleEndian
            withUnsafeBytes(of: &value) { out.append(contentsOf: $0) }
        }
        out.append(contentsOf: repeatElement(UInt8(0), count: 38))
        return out
    }

    static func +(lhs: Field, rhs: Field) -> Field {
        let (sum, carry) = addRaw(lhs, rhs)
        if carry {
            let (corrected, _) = addRaw(sum, carryCorrection)
            return corrected >= modulus ? subRaw(corrected, modulus) : corrected
        }
        return sum >= modulus ? subRaw(sum, modulus) : sum
    }

    static func -(lhs: Field, rhs: Field) -> Field {
        if lhs >= rhs {
            return subRaw(lhs, rhs)
        }
        let diff = subRaw(rhs, lhs)
        return subRaw(modulus, diff)
    }

    static func *(lhs: Field, rhs: Field) -> Field {
        var product = [UInt64](repeating: 0, count: 8)
        let a = lhs.limbs
        let b = rhs.limbs
        for i in 0..<4 {
            for j in 0..<4 {
                addProduct(&product, index: i + j, a[i], b[j])
            }
        }
        return reduce(product)
    }

    static func >=(lhs: Field, rhs: Field) -> Bool {
        compare(lhs, rhs) >= 0
    }

    func squared() -> Field { self * self }
    func doubled() -> Field { self + self }
    func times3() -> Field { self.doubled() + self }
    func times4() -> Field { self.doubled().doubled() }
    func times8() -> Field { self.times4().doubled() }

    func inverted() -> Field {
        let exponent = Field(0xffff_ffff_ffff_fffd, 0x0000_0000_ffff_ffff, 0, 0xffff_ffff_0000_0001)
        var result = Field.one
        for bit in stride(from: 255, through: 0, by: -1) {
            result = result.squared()
            if exponent.bit(bit) {
                result = result * self
            }
        }
        return result
    }

    private func bit(_ bit: Int) -> Bool {
        ((limbs[bit / 64] >> UInt64(bit & 63)) & 1) != 0
    }

    private static func compare(_ lhs: Field, _ rhs: Field) -> Int {
        let a = lhs.limbs
        let b = rhs.limbs
        for index in stride(from: 3, through: 0, by: -1) {
            if a[index] < b[index] { return -1 }
            if a[index] > b[index] { return 1 }
        }
        return 0
    }

    private static func addRaw(_ lhs: Field, _ rhs: Field) -> (Field, Bool) {
        let a = lhs.limbs
        let b = rhs.limbs
        var out = [UInt64](repeating: 0, count: 4)
        var carry = false
        for index in 0..<4 {
            let first = a[index].addingReportingOverflow(b[index])
            let second = first.partialValue.addingReportingOverflow(carry ? 1 : 0)
            out[index] = second.partialValue
            carry = first.overflow || second.overflow
        }
        return (Field(limbs: out), carry)
    }

    private static func subRaw(_ lhs: Field, _ rhs: Field) -> Field {
        let a = lhs.limbs
        let b = rhs.limbs
        var out = [UInt64](repeating: 0, count: 4)
        var borrow = false
        for index in 0..<4 {
            let first = a[index].subtractingReportingOverflow(b[index])
            let second = first.partialValue.subtractingReportingOverflow(borrow ? 1 : 0)
            out[index] = second.partialValue
            borrow = first.overflow || second.overflow
        }
        return Field(limbs: out)
    }

    private static func addProduct(_ product: inout [UInt64], index: Int, _ lhs: UInt64, _ rhs: UInt64) {
        let multiplied = lhs.multipliedFullWidth(by: rhs)
        var carry = addWord(&product, index: index, word: multiplied.low)
        carry = addWord(&product, index: index + 1, word: multiplied.high &+ carry)
        if multiplied.high == UInt64.max && carry == 0 {
            carry = 1
        }
        var carryIndex = index + 2
        while carry != 0 {
            carry = addWord(&product, index: carryIndex, word: carry)
            carryIndex += 1
        }
    }

    private static func addWord(_ limbs: inout [UInt64], index: Int, word: UInt64) -> UInt64 {
        let result = limbs[index].addingReportingOverflow(word)
        limbs[index] = result.partialValue
        return result.overflow ? 1 : 0
    }

    private static func reduce(_ limbs: [UInt64]) -> Field {
        var remainder = Field.zero
        for bit in stride(from: limbs.count * 64 - 1, through: 0, by: -1) {
            remainder = shiftAppendBitModP(remainder, bitSet(limbs, bit))
        }
        return remainder
    }

    private static func shiftAppendBitModP(_ value: Field, _ bit: Bool) -> Field {
        let limbs = value.limbs
        var out = [UInt64](repeating: 0, count: 4)
        var carry: UInt64 = bit ? 1 : 0
        for index in 0..<4 {
            let nextCarry = limbs[index] >> 63
            out[index] = (limbs[index] << 1) | carry
            carry = nextCarry
        }

        var shifted = Field(limbs: out)
        if carry != 0 {
            let (corrected, _) = addRaw(shifted, carryCorrection)
            shifted = corrected
        } else if shifted >= modulus {
            shifted = subRaw(shifted, modulus)
        }
        return shifted >= modulus ? subRaw(shifted, modulus) : shifted
    }

    private static func bitSet(_ limbs: [UInt64], _ bit: Int) -> Bool {
        ((limbs[bit / 64] >> UInt64(bit & 63)) & 1) != 0
    }

    private static func readUInt64BE(_ bytes: [UInt8], _ offset: Int) -> UInt64 {
        var value: UInt64 = 0
        for index in 0..<8 {
            value = (value << 8) | UInt64(bytes[offset + index])
        }
        return value
    }
}
