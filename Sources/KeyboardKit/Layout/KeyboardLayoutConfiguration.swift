//
//  KeyboardLayoutConfiguration.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-10-01.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import Foundation
import SwiftUI

/**
 This struct can be used to specify a keyboard configuration
 for e.g. a certain device.
 
 This struct makes it easy to specify how standard keyboards
 are structured in various devices.
 */
public struct KeyboardLayoutConfiguration: Equatable {
    
    /**
     Create a new layout configuration.
     
     - Parameters:
       - buttonCornerRadius: The corner radius of a keyboard button in the keyboard.
       - buttonInsets: The edge insets of a keyboard button in the keyboard.
       - rowHeight: The total height incl. insets, of a row in the keyboard.
    */
    public init(
        buttonCornerRadius: CGFloat,
        buttonInsets: EdgeInsets,
        rowHeight: CGFloat) {
        self.buttonCornerRadius = buttonCornerRadius
        self.buttonInsets = buttonInsets
        self.rowHeight = rowHeight
    }
    
    /**
     The corner radius of a keyboard button in the keyboard.
     */
    public let buttonCornerRadius: CGFloat
    
    /**
     The edge insets of a keyboard button in the keyboard.
     */
    public let buttonInsets: EdgeInsets
    
    /**
     The total height incl. insets, of a row in the keyboard.
     */
    public let rowHeight: CGFloat
}

public extension KeyboardLayoutConfiguration {
    
    /**
     The standard config for the provided `context`.
     */
    static func standard(
        for context: KeyboardContext) -> KeyboardLayoutConfiguration {
        standard(
            forIdiom: context.device.userInterfaceIdiom,
            screenSize: context.screen.bounds.size,
            orientation: context.screenOrientation)
    }
    
    /**
     The standard config for the provided device and screen.
     */
    static func standard(
        forIdiom idiom: UIUserInterfaceIdiom,
        screenSize size: CGSize,
        orientation: UIInterfaceOrientation) -> KeyboardLayoutConfiguration {
        switch idiom {
        case .pad: return standardPad(forScreenSize: size, orientation: orientation)
        default: return standardPhone(forScreenSize: size, orientation: orientation)
        }
    }
    
    /**
     The standard pad config for the provided `screen`.
     */
    static func standardPad(
        forScreenSize size: CGSize,
        orientation: UIInterfaceOrientation) -> KeyboardLayoutConfiguration {
        let isPortrait = orientation.isPortrait
        if size.isScreenSize(.iPadProLargeScreenPortrait) {
            return isPortrait ? .standardPadPortrait : .standardPadLandscape
        } else if size.isScreenSize(.iPadProSmallScreenPortrait) {
            return isPortrait ? .standardPadPortrait : .standardPadLandscape
        }
        return isPortrait ? .standardPadPortrait : .standardPadLandscape
    }
    
    /**
     The standard phone config for the provided `screen`.
     */
    static func standardPhone(
        forScreenSize size: CGSize,
        orientation: UIInterfaceOrientation) -> KeyboardLayoutConfiguration {
        let isPortrait = orientation.isPortrait
        if size.isScreenSize(.iPhoneProMaxScreenPortrait) {
            return isPortrait ? .standardPhoneProMaxPortrait : .standardPhoneProMaxLandscape
        }
        return isPortrait ? .standardPhonePortrait : .standardPhoneLandscape
    }
    
    /**
     The standard config for an iPad in landscape.
     */
    static let standardPadLandscape = KeyboardLayoutConfiguration(
        buttonCornerRadius: 6,
        buttonInsets: .horizontal(7, vertical: 6),
        rowHeight: 86)
    
    /**
     The standard config for an iPad in portait.
     */
    static let standardPadPortrait = KeyboardLayoutConfiguration(
        buttonCornerRadius: 6,
        buttonInsets: .horizontal(6, vertical: 4),
        rowHeight: 64)
    
    /**
     The standard config for an iPhone in landscape.
     */
    static let standardPhoneLandscape = KeyboardLayoutConfiguration(
        buttonCornerRadius: 4,
        buttonInsets: .horizontal(3, vertical: 4),
        rowHeight: 40)
    
    /**
     The standard config for an iPhone in portrait.
     */
    static let standardPhonePortrait = KeyboardLayoutConfiguration(
        buttonCornerRadius: 4,
        buttonInsets: .horizontal(3, vertical: 6),
        rowHeight: 54)
    
    /**
     The standard config for an iPhone Pro Max in landscape.
     */
    static let standardPhoneProMaxLandscape = KeyboardLayoutConfiguration
        .standardPhoneLandscape
    
    /**
     The standard config for an iPhone Pro Max in portrait.
     */
    static let standardPhoneProMaxPortrait = KeyboardLayoutConfiguration(
        buttonCornerRadius: 4,
        buttonInsets: .horizontal(3, vertical: 6),
        rowHeight: 56)
}
