//
//  HomeScreen.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-02-11.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import KeyboardKit

import Foundation

class Test: UIInputViewController {}

struct HomeScreen: View {
    
    @StateObject private var keyboardState = KeyboardEnabledState(bundleId: "com.keyboardkit.demo.keyboard")
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Type")) {
                    ListNavigationLink(destination: EditScreen(appearance: .default)) {
                        Label("Type in a regular text field", image: .type)
                    }
                    ListNavigationLink(destination: EditScreen(appearance: .dark)) {
                        Label("Type in a dark text field", image: .type)
                    }
                }
                Section(header: Text("Keyboard"), footer: footerText) {
                    EnabledListItem(
                        isEnabled: isKeyboardEnabled,
                        enabledText: "Keyboard is enabled",
                        disabledText: "Keyboard is disabled")
                    EnabledListItem(
                        isEnabled: isFullAccessEnabled,
                        enabledText: "Full Access is enabled",
                        disabledText: "Full Access is disabled")
                    ListNavigationButton(action: openSettings) {
                        Label("System settings", image: .settings)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("KeyboardKit Demo")
        }
        .environmentObject(keyboardState)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

private extension HomeScreen {
    
    var footerText: some View {
        Text("You must enable the KeyboardKit keyboard under system settings, then select it with 🌐 when typing.")
    }
}

private extension HomeScreen {
    
    var isFullAccessEnabled: Bool {
        keyboardState.isFullAccessEnabled
    }
    
    var isKeyboardEnabled: Bool {
        keyboardState.isKeyboardEnabled
    }
    
    func openSettings() {
        guard let url = URL.keyboardSettings else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
