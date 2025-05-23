//
//  extension.swift
//  PokeBuilder
//
//  Created by Dương Anh Trần on 7/5/2025.
//

import Foundation
import SwiftUICore

extension Color {
    static let primary: Color = .init(hex: 0x3b3b3b)
    
    init(hex: Int) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double((hex >> 0) & 0xff) / 255,
            opacity: 1
        )
    }
}
