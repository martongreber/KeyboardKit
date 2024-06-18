//
//  Keyboard+AutocapitalizationType.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2023-03-26.
//  Copyright © 2020-2024 Daniel Saidi. All rights reserved.
//

import Foundation

public extension Keyboard {
 
    /// This enum defines keyboard auto-capitalization types.
    ///
    /// The ``KeyboardContext/autocapitalizationTypeOverride``
    /// property can be set to override the default behavior
    /// defined by the currently active text-field.
    enum AutocapitalizationType: String, CaseIterable {

        // All characters should be auto-capitalized.
        case allCharacters

        // All new sentences should be auto-capitalized.
        case sentences

        // All new words should be auto-capitalized.
        case words

        // Auto-capitalization should not be applied.
        case none
    }
}

#if os(iOS) || os(tvOS) || os(visionOS)
import UIKit

public extension UITextAutocapitalizationType {

    /// Map this type to a ``Keyboard/AutocapitalizationType``.
    var keyboardType: Keyboard.AutocapitalizationType {
        switch self {
        case .none: .none
        case .words: .words
        case .sentences: .sentences
        case .allCharacters: .allCharacters
        @unknown default: .none
        }
    }
}
#endif
