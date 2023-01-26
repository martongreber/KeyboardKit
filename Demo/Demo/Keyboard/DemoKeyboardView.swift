//
//  DemoKeyboardView.swift
//  KeyboardKitDemo
//
//  Created by Daniel Saidi on 2020-06-10.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import SwiftUI

/**
 This keyboard view is used by all `SystemKeyboard`-specific
 demo keyboards that use KeyboardKit and not KeyboardKit Pro.

 The view adds an autocomplete toolbar over the keyboard and
 automatically hides it if the keyboard state doesn't prefer
 autocomplete to be performed. Note that the height is still
 allocated, since keyboard input and action callouts need it.
 
 Note that the view must also observe a `KeyboardContext` in
 order to redraw whenever the context changes. If it doesn't,
 it will not redraw when it should. This shouldn't be needed,
 but currently is.
 */
struct DemoKeyboardView: View {

    var controller: KeyboardInputViewController
    
    @EnvironmentObject
    private var autocompleteContext: AutocompleteContext

    @EnvironmentObject
    private var keyboardContext: KeyboardContext

    var body: some View {
        VStack(spacing: 0) {
            if keyboardContext.prefersAutocomplete {
                autocompleteToolbar
            }
            SystemKeyboard(controller: controller)
        }
    }
}


// MARK: - Private Views

private extension DemoKeyboardView {

    var autocompleteToolbar: some View {
        AutocompleteToolbar(
            suggestions: autocompleteContext.suggestions,
            locale: keyboardContext.locale,
            action: controller.insertAutocompleteSuggestion
        ).opacity(keyboardContext.prefersAutocomplete ? 1 : 0)  // Still allocate height
    }
}