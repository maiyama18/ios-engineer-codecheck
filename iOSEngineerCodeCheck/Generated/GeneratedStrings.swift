// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Common {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "common.cancel")
    /// Error
    internal static let error = L10n.tr("Localizable", "common.error")
    /// OK
    internal static let ok = L10n.tr("Localizable", "common.ok")
  }

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

  internal enum GitHub {
    internal enum SortOrder {
      /// Best Match
      internal static let bestMatch = L10n.tr("Localizable", "git_hub.sort_order.best_match")
      /// Forks
      internal static let forks = L10n.tr("Localizable", "git_hub.sort_order.forks")
      /// Stars
      internal static let stars = L10n.tr("Localizable", "git_hub.sort_order.stars")
      /// Updated
      internal static let updated = L10n.tr("Localizable", "git_hub.sort_order.updated")
    }
  }

  internal enum RepositoryDetail {
    /// Open URL
    internal static let openUrl = L10n.tr("Localizable", "repository_detail.open_url")
    /// Share URL
    internal static let shareUrl = L10n.tr("Localizable", "repository_detail.share_url")
  }

  internal enum SearchBar {
    /// Search
    internal static let placeholder = L10n.tr("Localizable", "search_bar.placeholder")
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
