//
//  Keyboard+ButtonContent.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-01-10.
//  Copyright © 2021-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension Keyboard {
    
    /// This view renders the content of a keyboard button.
    ///
    /// The view adapts its content to fit the action, state
    /// and services that are passed in.
    ///
    /// The view sets up gestures, line limits, offset, etc.
    /// according to the provided `styleProvider`.
    struct ButtonContent: View {
        
        /// Create a keyboard button content view.
        ///
        /// - Parameters:
        ///   - action: The keyboard action to use.
        ///   - styleProvider: The style provider to use.
        ///   - keyboardContext: The keyboard context to use.
        public init(
            action: KeyboardAction,
            styleProvider: KeyboardStyleProvider,
            keyboardContext: KeyboardContext
        ) {
            self.action = action
            self.styleProvider = styleProvider
            self.keyboardContext = keyboardContext
        }
        
        private let action: KeyboardAction
        private let styleProvider: KeyboardStyleProvider
        private let keyboardContext: KeyboardContext
        
        public var body: some View {
            bodyContent
                .padding(styleProvider.buttonContentInsets(for: action))
                .contentShape(Rectangle())
        }
    }
}

private extension Keyboard.ButtonContent {

    @ViewBuilder
    var bodyContent: some View {
        if let image = styleProvider.buttonImage(for: action) {
            image.scaleEffect(styleProvider.buttonImageScaleFactor(for: action))
        } else if action == .space {
            spaceView
        } else if let text = styleProvider.buttonText(for: action) {
            textView(for: action, text: text)
        } else {
            Text("")
        }
    }
    
    var spaceImage: Image? {
        styleProvider.buttonImage(for: .space)
    }
    
    var spaceView: some View {
        let text = styleProvider.buttonText(for: action) ?? ""
        let showLocale = keyboardContext.locales.count > 1
        let localeName = keyboardContext.locale.localizedLanguageName
        return Keyboard.SpaceContent(
            localeText: showLocale ? localeName : text,
            spaceText: text
        )
    }
    
    func textView(for action: KeyboardAction, text: String) -> some View {
        Keyboard.ButtonTitle(
            text: text,
            action: action
        )
    }
}

#Preview {
    
    let multiLocaleContext: KeyboardContext = {
        let context = KeyboardContext.preview
        context.locales = [
            KeyboardLocale.english.locale,
            KeyboardLocale.swedish.locale
        ]
        return context
    }()
    
    func preview(
        for action: KeyboardAction,
        multiLocale: Bool = false
    ) -> some View {
        Keyboard.ButtonContent(
            action: action,
            styleProvider: .preview,
            keyboardContext: multiLocale ? multiLocaleContext : .preview
        )
        .background(Color.gray)
    }
    
    return VStack {
        preview(for: .backspace)
        preview(for: .nextKeyboard)
        preview(for: .nextLocale)
        preview(for: .keyboardType(.emojis))
        preview(for: .space, multiLocale: false)
        preview(for: .space, multiLocale: true)
        preview(for: .character("PascalCased"))
        preview(for: .character("lowercased"))
    }
}
