import Foundation

public enum NFCActivationCommandCode: UInt8, Sendable, Equatable {
    case activate = 0xa0
    case switchReceiver = 0xa8
}

public enum NFCActivationCommand {
    public static let readPatchInfo = Data([0x02, 0xa1, 0x7a])
    public static let manufacturerCode: UInt8 = 0x7a
    /// CoreNFC automatically inserts the ISO15693 manufacturer code for
    /// `customCommand`, so the A1 command has no app-supplied parameters.
    public static let readPatchInfoCustomRequestParameters = Data()

    public static func accountlessReceiverID(from uniqueID: String) -> UInt32 {
        Libre3ReceiverID.accountlessValue(from: uniqueID)
    }

    public static func metcrc(timeSeconds: UInt32, receiverID: UInt32) -> Data {
        var body = Data()
        appendLE(timeSeconds, to: &body)
        appendLE(receiverID, to: &body)
        appendLE(abbottCRC16(body), to: &body)
        return body
    }

    public static func customRequestParameters(timeSeconds: UInt32, receiverID: UInt32) -> Data {
        metcrc(timeSeconds: timeSeconds, receiverID: receiverID)
    }

    public static func command(
        code: NFCActivationCommandCode,
        timeSeconds: UInt32,
        receiverID: UInt32
    ) -> Data {
        var out = Data([0x02, code.rawValue, 0x7a])
        out.append(metcrc(timeSeconds: timeSeconds, receiverID: receiverID))
        return out
    }

    public static func abbottCRC16(_ data: Data) -> UInt16 {
        var crc: UInt16 = 0xffff
        for byte in data {
            crc ^= UInt16(reverse8(byte)) << 8
            for _ in 0..<8 {
                if (crc & 0x8000) != 0 {
                    crc = (crc << 1) ^ 0x1021
                } else {
                    crc <<= 1
                }
            }
        }
        return crc
    }

    private static func appendLE(_ value: UInt32, to data: inout Data) {
        data.append(UInt8(value & 0xff))
        data.append(UInt8((value >> 8) & 0xff))
        data.append(UInt8((value >> 16) & 0xff))
        data.append(UInt8((value >> 24) & 0xff))
    }

    private static func appendLE(_ value: UInt16, to data: inout Data) {
        data.append(UInt8(value & 0xff))
        data.append(UInt8((value >> 8) & 0xff))
    }

    private static func reverse8(_ value: UInt8) -> UInt8 {
        var x = value
        var out: UInt8 = 0
        for _ in 0..<8 {
            out = (out << 1) | (x & 1)
            x >>= 1
        }
        return out
    }
}
