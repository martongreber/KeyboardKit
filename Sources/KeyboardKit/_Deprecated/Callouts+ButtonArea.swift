//
//  Callouts+ButtonArea.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-09-30.
//  Copyright © 2021-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension Callouts {
    
    @available(*, deprecated, message: "This view has been replaced by callout-specific button areas.")
    struct ButtonArea: View {
        
        /// Create a callout button area.
        ///
        /// - Parameters:
        ///   - frame: The button area frame.
        public init(
            frame: CGRect
        ) {
            self.frame = frame
            self.initStyle = nil
        }
        
        private let frame: CGRect
        
        @Environment(\.calloutStyle)
        private var envStyle
        
        public var body: some View {
            HStack(alignment: .top, spacing: 0) {
                calloutCurve.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                buttonBody
                calloutCurve
            }
        }
        
        // MARK: - Deprecated
        
        @available(*, deprecated, message: "Use .calloutStyle to apply the style instead.")
        public init(
            frame: CGRect,
            style: Callouts.CalloutStyle = .standard
        ) {
            self.frame = frame
            self.initStyle = style
        }
        
        private typealias Style = Callouts.CalloutStyle
        private let initStyle: Style?
        private var style: Style { initStyle ?? envStyle }
    }
}


@available(*, deprecated, message: "This view has been replaced by callout-specific button areas.")
private extension Callouts.ButtonArea {
    
    var backgroundColor: Color { style.backgroundColor }
    var cornerRadius: CGFloat { style.buttonCornerRadius }
    var curveSize: CGSize { style.curveSize }
    
    var buttonBody: some View {
        CustomRoundedRectangle(bottomLeft: cornerRadius, bottomRight: cornerRadius)
            .foregroundColor(backgroundColor)
            .frame(width: frame.size.width, height: frame.size.height)
    }
    
    var calloutCurve: some View {
        Callouts.Curve()
            .frame(width: curveSize.width, height: curveSize.height)
            .foregroundColor(backgroundColor)
    }
}
