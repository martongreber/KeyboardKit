//
//  DemoLayoutProvider.swift
//  KeyboardPro
//
//  Created by Daniel Saidi on 2022-12-21.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import KeyboardKitPro

/// This provider inherits the standard provider, then makes
/// demo-specific adjustments to the standard layout.
///
/// The provider will inject a locale switcher to the layout,
/// if the keyboard context has many locales. 
///
/// Uncomment the `tryInsertDictationButton` call on line 26
/// to inject a dictation button into the layout.
///
/// The ``KeyboardViewController`` shows how you can replace
/// the standard provider with this custom one.
class DemoLayoutProvider: KeyboardLayout.StandardProvider {

    override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        let layout = super.keyboardLayout(for: context)
        // layout.tryInsertDictationButton()
        guard context.locales.count > 1 else { return layout }
        layout.tryInsertLocaleSwitcher()
        return layout
    }
}

private extension KeyboardLayout {

    func tryInsertDictationButton() {
        guard let item = tryCreateBottomRowItem(for: .dictation) else { return }
        itemRows.insert(item, after: .space, atRow: bottomRowIndex)
    }

    func tryInsertLocaleSwitcher() {
        guard let item = tryCreateBottomRowItem(for: .nextLocale) else { return }
        itemRows.insert(item, after: .space, atRow: bottomRowIndex)
    }
}
