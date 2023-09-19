//
//  SystemKeyboardButtonRowItem.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-12-02.
//  Copyright © 2020-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view is used within a ``SystemKeyboard`` and renders a
 button that bases its content on a ``KeyboardLayoutItem``.

 This view applies a tappable padding around its content, to
 mitigate any dead tap areas.
 */
public struct SystemKeyboardButtonRowItem<Content: View>: View {

    /**
     Create a system keyboard button row item.

     - Parameters:
       - content: The content view to use within the item.
       - item: The layout item to use within the item.
       - actionHandler: The button style to apply.
       - styleProvider: The style provider to use.
       - keyboardContext: The keyboard context to which the item should apply.,
       - calloutContext: The callout context to affect, if any.
       - keyboardWidth: The total width of the keyboard.
       - inputWidth: The input width within the keyboard.
     */
    public init(
        content: Content,
        item: KeyboardLayoutItem,
        actionHandler: KeyboardActionHandler,
        styleProvider: KeyboardStyleProvider,
        keyboardContext: KeyboardContext,
        calloutContext: CalloutContext?,
        keyboardWidth: CGFloat,
        inputWidth: CGFloat
    ) {
        self.content = content
        self.item = item
        self.actionHandler = actionHandler
        self.styleProvider = styleProvider
        self._keyboardContext = ObservedObject(wrappedValue: keyboardContext)
        self.calloutContext = calloutContext
        self.keyboardWidth = keyboardWidth
        self.inputWidth = inputWidth
    }

    private let content: Content
    private let item: KeyboardLayoutItem
    private let actionHandler: KeyboardActionHandler
    private let styleProvider: KeyboardStyleProvider
    private let calloutContext: CalloutContext?
    private let keyboardWidth: CGFloat
    private let inputWidth: CGFloat

    @ObservedObject
    private var keyboardContext: KeyboardContext

    @State
    private var isPressed = false

    public var body: some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: item.size.height - item.edgeInsets.top - item.edgeInsets.bottom)
            .rowItemWidth(
                for: item,
                rowWidth: keyboardWidth,
                inputWidth: inputWidth)
            .keyboardButton(
                for: item.action,
                style: buttonStyle,
                actionHandler: actionHandler,
                calloutContext: calloutContext,
                edgeInsets: item.edgeInsets,
                isPressed: $isPressed)
            .localeContextMenu(
                for: item.action,
                context: keyboardContext,
                actionHandler: actionHandler
            )
    }
}

private extension SystemKeyboardButtonRowItem {

    var buttonStyle: KeyboardStyle.Button {
        item.action.isSpacer ? .spacer : styleProvider.buttonStyle(for: item.action, isPressed: isPressed)
    }
}

private extension View {

    /**
     Apply a locale context menu to the view if the provided
     action is `nextLocale`.
     */
    @ViewBuilder
    func localeContextMenu(
        for action: KeyboardAction,
        context: KeyboardContext,
        actionHandler: KeyboardActionHandler
    ) -> some View {
        if shouldApplyLocaleContextMenu(for: action, context: context) {
            self.localeContextMenu(for: context) {
                actionHandler.handle(.release, on: action)
            }.id(context.locale.identifier)
        } else {
            self
        }
    }

    /**
     Apply a certain layout width to the view, in a way that
     works with the rot item composition above.
     */
    @ViewBuilder
    func rowItemWidth(
        for item: KeyboardLayoutItem,
        rowWidth: CGFloat,
        inputWidth: CGFloat
    ) -> some View {
        let width = item.width(forRowWidth: rowWidth, inputWidth: inputWidth)
        if let width, width > 0 {
            self.frame(width: width)
        } else {
            self.frame(maxWidth: .infinity)
        }
    }

    func shouldApplyLocaleContextMenu(
        for action: KeyboardAction,
        context: KeyboardContext
    ) -> Bool {
        switch action {
        case .nextLocale: return true
        case .space: return context.spaceLongPressBehavior == .openLocaleContextMenu
        default: return false
        }
    }
}

struct SystemKeyboardButtonRowItem_Previews: PreviewProvider {

    static let context: KeyboardContext = {
        let context = KeyboardContext()
        context.locales = KeyboardLocale.allCases.map { $0.locale }
        context.localePresentationLocale = KeyboardLocale.swedish.locale
        context.spaceLongPressBehavior = .openLocaleContextMenu
        return context
    }()

    static func previewItem(
        _ action: KeyboardAction,
        width: KeyboardLayoutItem.Width
    ) -> some View {
        SystemKeyboardButtonRowItem(
            content: KeyboardButtonContent(
                action: action,
                styleProvider: .preview,
                keyboardContext: context),
            item: KeyboardLayoutItem(
                action: action,
                size: KeyboardLayoutItem.Size(
                    width: width,
                    height: 100),
                edgeInsets: .init()),
            actionHandler: .preview,
            styleProvider: .preview,
            keyboardContext: context,
            calloutContext: .preview,
            keyboardWidth: 320,
            inputWidth: 30
        )
    }

    static var previews: some View {
        HStack {
            previewItem(.character("1"), width: .inputPercentage(0.5))
            previewItem(.nextKeyboard, width: .input)
            previewItem(.nextLocale, width: .available)
            previewItem(.space, width: .percentage(0.1))
            previewItem(.character("5"), width: .points(20))
        }
    }
}
