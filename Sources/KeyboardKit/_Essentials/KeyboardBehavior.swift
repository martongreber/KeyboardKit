//
//  KeyboardBehavior.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-12-28.
//  Copyright © 2020-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be implemented by any classes that can
/// define keyboard-specific behaviors.
///
/// Some types, like ``KeyboardAction/StandardHandler`` will
/// use this protocol to make certain decisions.
///
/// KeyboardKit will automatically setup a standard protocol
/// implementation in ``KeyboardInputViewController/services``
/// when the keyboard is launched. You can change or replace
/// it at any time to customize the keyboard behavior.
///
/// See the <doc:Essentials> for more information.
public protocol KeyboardBehavior {
    
    typealias Gesture = Gestures.KeyboardGesture
    
    /// The range that backspace should delete.
    var backspaceRange: Keyboard.BackspaceRange { get }
    
    /// The preferred keyboard type after an action gesture.
    func preferredKeyboardType(
        after gesture: Gesture,
        on action: KeyboardAction
    ) -> Keyboard.KeyboardType
    
    /// Whether to end the sentence after a gesture action.
    func shouldEndSentence(
        after gesture: Gesture,
        on action: KeyboardAction
    ) -> Bool
    
    /// Whether to switch to capslock after a gesture action.
    func shouldSwitchToCapsLock(
        after gesture: Gesture,
        on action: KeyboardAction
    ) -> Bool
    
    /// Whether to switch to the preferred keyboard type after
    /// a gesture action.
    func shouldSwitchToPreferredKeyboardType(
        after gesture: Gesture,
        on action: KeyboardAction
    ) -> Bool

    /// Whether to switch to a preferred keyboard type after
    /// the text document proxy text changes.
    func shouldSwitchToPreferredKeyboardTypeAfterTextDidChange() -> Bool
}
