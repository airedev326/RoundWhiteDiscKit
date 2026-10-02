import Foundation

// Parser for the pristine Abbott app's `Libre3PatchContext.xml` file.
// This file lives at:
//   /data/data/com.freestylelibre3.app.us/shared_prefs/Libre3PatchContext.xml
// on Android. It contains a single base64-encoded 149-byte kAuth blob
// inside a `<string name="Libre3PatchContext">...</string>` element.
//
// For the iPhone takeover-mode PoC, the user pulls this XML from their
// Android device and the iOS app decodes it to recover the kAuth state.
//
// Example XML:
//   <?xml version='1.0' encoding='utf-8' standalone='yes' ?>
//   <map>
//       <string name="Libre3PatchContext">PDzH+AIAAAAAAAAAEAAAAACWlXdL...</string>
//   </map>

public enum Libre3PatchContextError: Error {
    case stringNodeNotFound
    case base64DecodeFailed
    case wrongBlobSize(Int)
}

public enum Libre3PatchContextLoader {

    /// Decode the kAuth blob from `Libre3PatchContext.xml` content.
    /// Returns the raw 149-byte blob ready for `KAuth.unwrap149Blob(_:)`.
    public static func loadKAuthBlob(fromXML xmlData: Data) throws -> Data {
        guard let xmlText = String(data: xmlData, encoding: .utf8) else {
            throw Libre3PatchContextError.stringNodeNotFound
        }
        // The XML structure is fixed and trivial — no need for a full XML
        // parser dependency. Match the single `<string>` element by name.
        let pattern = #"<string\s+name="Libre3PatchContext">([^<]+)</string>"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(
                in: xmlText,
                range: NSRange(xmlText.startIndex..., in: xmlText)
              ),
              match.numberOfRanges >= 2,
              let captureRange = Range(match.range(at: 1), in: xmlText)
        else {
            throw Libre3PatchContextError.stringNodeNotFound
        }
        let b64 = String(xmlText[captureRange])
        guard let blob = Data(base64Encoded: b64) else {
            throw Libre3PatchContextError.base64DecodeFailed
        }
        guard blob.count == KAuth.blobSize else {
            throw Libre3PatchContextError.wrongBlobSize(blob.count)
        }
        return blob
    }

    /// Convenience: load + unwrap in one shot.
    public static func loadAndUnwrap(fromXML xmlData: Data) throws -> UnwrappedKAuth {
        let blob = try loadKAuthBlob(fromXML: xmlData)
        return try KAuth.unwrap149Blob(blob)
    }
}
