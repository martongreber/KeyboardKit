//
//  DemoToolbar.swift
//  KeyboardPro
//
//  Created by Daniel Saidi on 2023-11-27.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

import KeyboardKitPro
import SwiftUI

/// This demo-specific toolbar uses a Pro `ToggleToolbar` to
/// toggle between a main autocomplete toolbar and this one.
///
/// This view has text fields that let you test routing text
/// fields, as well as buttons to trigger certain operations
/// like picking themes, open settings, etc.
struct DemoToolbar: View {
    
    unowned var controller: KeyboardInputViewController
    
    @Binding
    var theme: KeyboardTheme?
    
    var proxy: UITextDocumentProxy
    
    @State
    private var fullDocumentContext = ""
    
    @State
    private var isThemePickerPresented = false
    
    @State
    private var isFullDocumentContextActive = false
    
    @FocusState
    private var isTextFieldFocused
    
    @State
    private var text = ""
    
    var body: some View {
        HStack {
            textFieldIfFullAccess
            toolbarButton(toggleThemePicker, "paintpalette")
            toolbarButton(readFullDocumentContext, "doc.text.magnifyingglass")
            toolbarButton(startDictation, "mic")
            toolbarButton(openSettings, "gearshape")
        }
        .padding(10)
        .font(.headline)
        .buttonStyle(.bordered)
        .sheet(isPresented: $isFullDocumentContextActive, content: fullDocumentContextSheet)
        .sheet(isPresented: $isThemePickerPresented, content: themePickerSheet)
    }
}

private extension DemoToolbar {
    
    @ViewBuilder
    var textFieldIfFullAccess: some View {
        if controller.hasFullAccess {
            KeyboardTextField(text: $text, controller: controller) {
                $0.placeholder = "Type here..."
            }
            .focused($isTextFieldFocused) {
                Image(systemName: "xmark.circle.fill")
            }
            .buttonStyle(.plain)
        }
    }
    
    func fullDocumentContextSheet() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(fullDocumentContext)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .demoSheet("Full Document Reader")
    }
    
    func themePickerSheet() -> some View {
        KeyboardTheme.Shelf(
            themes: KeyboardTheme.allPredefined
        ) { theme in
            self.theme = theme
        } title: { collection in
            Text(collection.name)
                .font(.callout.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
        } item: { theme in
            KeyboardTheme.ShelfItem(theme: theme)
                .shadow(radius: 1, x: 0, y: 1)
                .padding(.vertical, 3)
        }
        .demoSheet("Theme Picker")
    }
    
    func toolbarButton(
        _ action: @escaping () -> Void,
        _ imageName: String
    ) -> some View {
        Button(action: action) {
            Image(systemName: imageName)
                .frame(maxHeight: .infinity)
        }
    }
}

private extension DemoToolbar {
    
    func openSettings() {
        controller.openUrl(.keyboardSettings)
    }
    
    func readFullDocumentContext() {
        isFullDocumentContextActive = true
        fullDocumentContext = "Reading..."
        Task {
            let result = try await proxy.fullDocumentContext()
            await MainActor.run { self.fullDocumentContext = result.fullDocumentContext }
        }
    }
    
    func selectTheme(_ theme: KeyboardTheme) {
        self.theme = theme
        isThemePickerPresented = false
    }
    
    func startDictation() {
        controller.performDictation()
    }
    
    func toggleThemePicker() {
        isThemePickerPresented.toggle()
    }
}

private extension View {
    
    func demoSheet(_ title: String) -> some View {
        NavigationView {
            ScrollView {
                self
            }
            .navigationTitle(title)
        }
    }
}

extension String: Identifiable {
    
    public var id: String { self }
}
