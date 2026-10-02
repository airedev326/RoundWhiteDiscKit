//
//  LocalizedString.swift
//  RoundWhiteDiscKit
//

import Foundation

/// Module-scoped localization for RoundWhiteDiscKit: looks strings up in the package's
/// own resource bundle rather than the host app's global table (mirrors
/// LibreLoop's LocalizedString).
///
/// Resolves `Bundle.module` where the LoopKit-family helpers use
/// `Bundle(for: SomeType.self)`. RoundWhiteDiscKit is a SwiftPM package, so its
/// resources live in a generated resource bundle beside the code; `Bundle(for:)`
/// would find the code bundle, report no localizations, and make every lookup
/// fall through to the key.
///
/// Only text an end user actually reads belongs here. Diagnostic output stays
/// English on purpose — `CustomStringConvertible` descriptions, pairing
/// transcripts, and hex dumps end up in logs and bug reports, where a
/// locale-dependent value cannot be compared across users.
func LocalizedString(_ key: String, tableName: String? = nil, value: String? = nil, comment: String) -> String {
    let bundle = Bundle.module
    if let value = value {
        return NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value, comment: comment)
    }
    return NSLocalizedString(key, tableName: tableName, bundle: bundle, comment: comment)
}
