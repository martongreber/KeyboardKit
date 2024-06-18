//
//  AutocompleteProvider.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2019-07-04.
//  Copyright © 2019-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be implemented by any classes that can
/// return autocomplete suggestions as the user types.
///
/// Simply call ``autocompleteSuggestions(for:)`` to perform
/// an autocomplete operation that returns suggestions for a
/// text in the current ``locale``.
///
/// KeyboardKit does not have a standard provider, as it has
/// for other services. Instead, a disabled provider will be
/// used until you register a custom provider, or register a
/// valid KeyboardKit Pro license key.
///
/// See <doc:Autocomplete-Article> for more information.
public protocol AutocompleteProvider: AnyObject {
    
    /// The currently applied locale.
    var locale: Locale { get set }


    /// Get autocomplete suggestions for the provided `text`.
    func autocompleteSuggestions(
        for text: String
    ) async throws -> [Autocomplete.Suggestion]
    
    
    /// Whether or not the provider can ignore words.
    var canIgnoreWords: Bool { get }

    /// Whether or not the provider can lean words.
    var canLearnWords: Bool { get }

    /// The provider's currently ignored words.
    var ignoredWords: [String] { get }

    /// The provider's currently learned words.
    var learnedWords: [String] { get }


    /// Whether or not the provider has ignored a certain word.
    func hasIgnoredWord(_ word: String) -> Bool

    /// Whether or not the provider has learned a certain word.
    func hasLearnedWord(_ word: String) -> Bool

    /// Make the provider ignore a certain word.
    func ignoreWord(_ word: String)

    /// Make the provider learn a certain word.
    func learnWord(_ word: String)

    /// Remove a certain ignored word from the provider.
    func removeIgnoredWord(_ word: String)

    /// Make the provider unlearn a certain word.
    func unlearnWord(_ word: String)
}
