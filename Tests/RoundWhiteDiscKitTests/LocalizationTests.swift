import XCTest
@testable import RoundWhiteDiscKit

/// Guards the shipped `.lproj` catalogs. These read the *packaged* resources
/// out of the module bundle, not the source files, so a catalog that fails to
/// make it through SwiftPM's resource processing fails here too.
final class LocalizationTests: XCTestCase {
    private static let languages = [
        "en", "de", "es", "fr", "it", "ja", "nl", "pl", "ru", "zh-Hans",
    ]

    /// Every key in the catalogs. The English source text *is* the key, so this
    /// list doubles as a pin on the English wording: changing a call site
    /// without updating the catalogs fails `testEveryLocaleHasExactlyTheKeys`.
    private static let keys = [
        "Hold the TOP of your iPhone very close to the Sensor",
        "Libre 3 NFC scan complete.",
        "Libre 3 sensor read.",
        "Libre 3 sensor activated.",
        "Libre 3 receiver switched.",
        "More than one tag detected.",
        "Bluetooth unavailable",
        "Bluetooth powered off",
        "Bluetooth permission denied",
        "BLE connect failed: %@",
        "BLE timeout: %@",
    ]

    /// SwiftPM lowercases localization directory names when it packages them, so
    /// the `zh-Hans.lproj` in `Sources` ships as `zh-hans.lproj`. Resolve the
    /// name the bundle actually uses instead of assuming our spelling survived —
    /// otherwise these tests fail on a case-sensitive filesystem. Do not
    /// "fix" the source directory to lowercase: `zh-Hans` is the correct
    /// identifier, and CFBundle matches it case-insensitively at runtime
    /// (see `testDeviceLanguagePreferenceResolvesToShippedCatalog`).
    private func shippedIdentifier(for language: String) throws -> String {
        try XCTUnwrap(
            Bundle.module.localizations.first {
                $0.caseInsensitiveCompare(language) == .orderedSame
            },
            "missing localization: \(language)"
        )
    }

    /// `.strings` ship as either the text format or a compiled binary plist
    /// depending on the build pipeline; `NSDictionary(contentsOf:)` reads both.
    private func table(for language: String) throws -> [String: String] {
        let url = try XCTUnwrap(
            Bundle.module.url(
                forResource: "Localizable",
                withExtension: "strings",
                subdirectory: nil,
                localization: try shippedIdentifier(for: language)
            ),
            "\(language).lproj/Localizable.strings is missing from the bundle"
        )
        return try XCTUnwrap(
            NSDictionary(contentsOf: url) as? [String: String],
            "\(language).lproj/Localizable.strings is not a readable strings table"
        )
    }

    func testAllLocalizationsArePackaged() throws {
        for language in Self.languages {
            XCTAssertNoThrow(try shippedIdentifier(for: language))
        }
    }

    /// The guarantee that actually matters: a device set to one of these
    /// languages — including a region variant, and including the `zh-Hans`
    /// spelling SwiftPM lowercased on disk — lands on our catalog rather than
    /// falling back to English. A language we do not ship must fall back.
    func testDeviceLanguagePreferenceResolvesToShippedCatalog() throws {
        let shipped = Bundle.module.localizations

        for language in Self.languages {
            let expected = try shippedIdentifier(for: language)
            for preference in [language, "\(language)-XX"] {
                XCTAssertEqual(
                    Bundle.preferredLocalizations(from: shipped, forPreferences: [preference]),
                    [expected],
                    "device language \(preference) did not resolve to \(expected)"
                )
            }
        }

        // Traditional Chinese is deliberately not shipped and must not be
        // silently served the Simplified catalog.
        XCTAssertEqual(
            Bundle.preferredLocalizations(from: shipped, forPreferences: ["zh-Hant"]),
            ["en"]
        )
    }

    func testEveryLocaleHasExactlyTheKeys() throws {
        let expected = Set(Self.keys)
        for language in Self.languages {
            let keys = Set(try table(for: language).keys)
            XCTAssertEqual(
                keys, expected,
                "\(language): missing \(expected.subtracting(keys).sorted()), " +
                "unexpected \(keys.subtracting(expected).sorted())"
            )
        }
    }

    /// With the English text as the key, `en.lproj` must map each key to itself.
    /// That keeps `localizedDescription` on an English device byte-identical to
    /// the literals these strings replaced.
    func testEnglishCatalogMapsEachKeyToItself() throws {
        let table = try table(for: "en")
        for key in Self.keys {
            XCTAssertEqual(table[key], key)
        }
    }

    /// A translation equal to its English key means the entry was copied but
    /// never translated. If a language ever legitimately shares the English
    /// wording, give it an explicit `value:` at the call site instead.
    func testTranslationsAreNonEmptyAndActuallyTranslated() throws {
        for language in Self.languages where language != "en" {
            for (key, value) in try table(for: language) {
                XCTAssertFalse(
                    value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                    "\(language): empty value for \(key)"
                )
                XCTAssertNotEqual(value, key, "\(language): \(key) is untranslated")
            }
        }
    }

    /// A dropped or duplicated `%@` turns `String(format:)` into garbage — or a
    /// crash, once a translator adds a second one.
    func testFormatSpecifiersMatchEnglish() throws {
        for language in Self.languages {
            let table = try table(for: language)
            for key in Self.keys {
                let value = try XCTUnwrap(table[key])
                XCTAssertEqual(
                    value.components(separatedBy: "%@").count,
                    key.components(separatedBy: "%@").count,
                    "\(language): %@ count differs from English for \(key)"
                )
                XCTAssertFalse(
                    value.contains("%s") || value.contains("%d"),
                    "\(language): \(key) uses a specifier the call site does not pass"
                )
            }
        }
    }

    /// End-to-end through the same helper the call sites use: a lookup against a
    /// specific locale must return that locale's text, not the English key.
    /// This is what would silently break if the catalogs stopped being compiled
    /// into the bundle.
    func testLookupReturnsTranslationForNonEnglishLocale() throws {
        let identifier = try shippedIdentifier(for: "de")
        let url = try XCTUnwrap(Bundle.module.url(forResource: identifier, withExtension: "lproj"))
        let german = try XCTUnwrap(Bundle(url: url))

        XCTAssertEqual(
            german.localizedString(forKey: "Bluetooth powered off", value: nil, table: nil),
            "Bluetooth ist ausgeschaltet"
        )
        XCTAssertEqual(
            german.localizedString(forKey: "Libre 3 sensor activated.", value: nil, table: nil),
            "Libre 3 Sensor aktiviert."
        )
    }

    /// `LocalizedString` must resolve against the resource bundle. The failure
    /// mode this catches is the helper being copied from a framework verbatim,
    /// where `Bundle(for:)` finds the code bundle, reports no localizations, and
    /// every lookup silently falls through to the key.
    ///
    /// Asserted without pinning a language: the result only has to be one of the
    /// shipped translations, so this holds whatever locale the test host runs in.
    func testHelperResolvesAgainstTheResourceBundle() throws {
        XCTAssertFalse(Bundle.module.localizations.isEmpty)

        let key = "Bluetooth powered off"
        var shippedValues = Set<String>()
        for language in Self.languages {
            shippedValues.insert(try XCTUnwrap(table(for: language)[key]))
        }

        XCTAssertTrue(
            shippedValues.contains(LocalizedString(key, comment: "test")),
            "helper did not resolve to any shipped translation"
        )
    }

    /// `description` feeds logs and bug reports, so it must stay English even
    /// when the user's device is not.
    func testScannerErrorDescriptionStaysEnglish() {
        XCTAssertEqual(SensorScannerError.bluetoothUnavailable.description, "Bluetooth unavailable")
        XCTAssertEqual(SensorScannerError.bluetoothPoweredOff.description, "Bluetooth powered off")
        XCTAssertEqual(SensorScannerError.bluetoothUnauthorized.description, "Bluetooth permission denied")
        XCTAssertEqual(SensorScannerError.connectionFailed("why").description, "BLE connect failed: why")
        XCTAssertEqual(SensorScannerError.timeout("why").description, "BLE timeout: why")
    }
}
