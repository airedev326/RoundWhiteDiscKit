import Foundation

// Post-authorization data-plane AES-CCM helper.
//
//   key      = Phase 6 kEnc (16B)
//   nonce13  = seq16_LE || packetDescriptor3 || ivEnc8
//   tag      = 4B CCM tag appended to ciphertext
//
// The packet descriptors are small static constants. Live validation can try
// all descriptors and accept only a valid CCM tag, which keeps the app useful
// while we finish pinning descriptor-to-characteristic ownership.

public enum DataPlanePacketKind: UInt8, CaseIterable, Sendable {
    case kind0 = 0
    case handshake = 1
    case kind2 = 2
    case kind3 = 3
    case kind4 = 4
    case kind5 = 5
    case kind6 = 6
    case patchData = 7

    /// Outbound patchControl command writes.
    public static let patchControlWrite: DataPlanePacketKind = .kind0

    public var descriptor: Data {
        switch self {
        case .kind0: return Data([0x00, 0x00, 0x00])
        case .handshake: return Data([0x00, 0x00, 0x0f])
        case .kind2: return Data([0x00, 0x00, 0xf0])
        case .kind3: return Data([0x00, 0x0f, 0x00])
        case .kind4: return Data([0x00, 0xf0, 0x00])
        case .kind5: return Data([0x0f, 0x00, 0x00])
        case .kind6: return Data([0xf0, 0x00, 0x00])
        case .patchData: return Data([0x44, 0x00, 0x00])
        }
    }
}

public struct DataPlaneDecryptResult: Equatable, Sendable {
    public let kind: DataPlanePacketKind
    public let plaintext: Data
}

public struct DataPlaneCrypto: Sendable {
    public static let tagSize = 4

    public let kEnc: Data
    public let ivEnc: Data

    public init(kEnc: Data, ivEnc: Data) throws {
        guard kEnc.count == 16 else { throw DataPlaneCryptoError.wrongKEncSize(kEnc.count) }
        guard ivEnc.count == 8 else { throw DataPlaneCryptoError.wrongIVEncSize(ivEnc.count) }
        self.kEnc = kEnc
        self.ivEnc = ivEnc
    }

    public init(sessionMaterial: Phase6SessionMaterial) throws {
        try self.init(kEnc: sessionMaterial.kEnc, ivEnc: sessionMaterial.ivEnc)
    }

    public func nonce(sequence: UInt16, kind: DataPlanePacketKind) -> Data {
        var out = Data(capacity: 13)
        out.append(UInt8(sequence & 0xff))
        out.append(UInt8((sequence >> 8) & 0xff))
        out.append(kind.descriptor)
        out.append(ivEnc)
        return out
    }

    public func decrypt(_ frame: DataFrame, kind: DataPlanePacketKind) throws -> Data {
        guard frame.encrypted.count >= Self.tagSize else {
            throw DataPlaneCryptoError.payloadTooShort(frame.encrypted.count)
        }
        let tagStart = frame.encrypted.count - Self.tagSize
        let ciphertext = frame.encrypted.subdata(in: 0..<tagStart)
        let tag = frame.encrypted.subdata(in: tagStart..<frame.encrypted.count)
        return try AESCCM.decrypt(
            nonce: nonce(sequence: frame.sequenceNumber, kind: kind),
            ciphertext: ciphertext,
            tag: tag,
            aes: AESCCM.commonCryptoBlockEncrypt(key: kEnc)
        )
    }

    public func decryptTryingAllKinds(_ frame: DataFrame) throws -> DataPlaneDecryptResult {
        for kind in DataPlanePacketKind.allCases {
            if let plaintext = try? decrypt(frame, kind: kind) {
                return DataPlaneDecryptResult(kind: kind, plaintext: plaintext)
            }
        }
        throw DataPlaneCryptoError.noDescriptorMatched
    }

    public func encrypt(
        plaintext: Data,
        sequence: UInt16,
        kind: DataPlanePacketKind
    ) throws -> DataFrame {
        let (ciphertext, tag) = try AESCCM.encrypt(
            nonce: nonce(sequence: sequence, kind: kind),
            plaintext: plaintext,
            tagLength: Self.tagSize,
            aes: AESCCM.commonCryptoBlockEncrypt(key: kEnc)
        )
        return DataFrame(
            encrypted: ciphertext + tag,
            seq: UInt8(sequence & 0xff),
            type: UInt8((sequence >> 8) & 0xff)
        )
    }
}

public enum DataPlaneCryptoError: Error, Equatable {
    case wrongKEncSize(Int)
    case wrongIVEncSize(Int)
    case payloadTooShort(Int)
    case noDescriptorMatched
}
