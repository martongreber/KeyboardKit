//
//  Keyboard+NextKeyboardButton.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-03-11.
//  Copyright © 2020-2024 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(visionOS)
import SwiftUI
import UIKit

public extension Keyboard {
    
    /// This view can be used to make any view behave as the
    /// native next keyboard button.
    ///
    /// The native next keyboard button switches to the next
    /// keyboard on tap and opens a menu on press.
    ///
    /// You must provide a `UIInputViewController`, or setup
    /// ``NextKeyboardController/shared`` in advance, before
    /// using the view. This is automatically handled by the
    /// ``KeyboardInputViewController``.
    struct NextKeyboardButton<Content: View>: View {
        
        public init(
            controller: UIInputViewController? = nil,
            throwAssertionForMissingController: Bool = false,
            @ViewBuilder content: @escaping () -> Content
        ) {
            self.overlay = NextKeyboardButtonOverlay(
                controller: controller ?? Keyboard.NextKeyboardController.shared,
                throwAssertionForMissingController: throwAssertionForMissingController
            )
            self.content = content
            self.throwAssertionForMissingController = throwAssertionForMissingController
        }
        
        private let content: () -> Content
        private let overlay: NextKeyboardButtonOverlay
        private let throwAssertionForMissingController: Bool
        
        public var body: some View {
            content().overlay(overlay)
        }
    }
}

#Preview {

    Keyboard.NextKeyboardButton {
        Image.keyboardGlobe.font(.title)
    }
}

/// This overlay sets up a `next keyboard` controller action
/// on a blank `UIKit` button. This can hopefully be removed
/// later, without public changes.
private struct NextKeyboardButtonOverlay: UIViewRepresentable {

    init(
        controller: UIInputViewController?,
        throwAssertionForMissingController: Bool
    ) {
        button = UIButton()
        if controller == nil && throwAssertionForMissingController && !ProcessInfo.isSwiftUIPreview { assertionFailure("Input view controller is nil") }
        controller?.setupNextKeyboardButton(button)
    }

    let button: UIButton

    func makeUIView(context: Context) -> UIButton { button }

    func updateUIView(_ uiView: UIButton, context: Context) {}
}

private extension UIInputViewController {

    func setupNextKeyboardButton(_ button: UIButton) {
        let action = #selector(handleInputModeList(from:with:))
        button.addTarget(self, action: action, for: .allTouchEvents)
    }
}

private extension ProcessInfo {

    var isSwiftUIPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    static var isSwiftUIPreview: Bool {
        processInfo.isSwiftUIPreview
    }
}
#endif
