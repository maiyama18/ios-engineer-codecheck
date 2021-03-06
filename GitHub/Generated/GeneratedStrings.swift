// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Error {
    /// Search query is empty. Please input some words.
    internal static let emptySearchQuery = L10n.tr("Localizable", "error.empty_search_query")
    /// Input may be invalid. Please review your input.
    internal static let invalidInput = L10n.tr("Localizable", "error.invalid_input")
    /// Server is now unavailable. Please try again later!
    internal static let serverError = L10n.tr("Localizable", "error.server_error")
    /// You have sent too many request. Please try again later!
    internal static let tooManyRequest = L10n.tr("Localizable", "error.too_many_request")
    /// Something went wrong. Please try again later!
    internal static let unexpectedError = L10n.tr("Localizable", "error.unexpected_error")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
