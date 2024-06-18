//
//  String+Chars.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2023-11-01.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

import Foundation

public extension String {
    
    /// Split the string into a list of characters.
    var chars: [String] { map(String.init) }
    
    /// Split the string into a list of character actions.
    var charActions: [KeyboardAction] {
        chars.map(KeyboardAction.character)
    }
}
