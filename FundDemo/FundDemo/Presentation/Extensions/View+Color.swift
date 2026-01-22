//
//  View+Color.swift
//  FundDemo
//
//  Created by Sharon Chao on 2026/1/22.
//

import UIKit
import SwiftUI

extension Color {
    
    static let darkGreen = Color(hex: "#019858")
    static let darkPurple = Color(hex: "#4B0091")
    static let titleBlueBG = Color(hex: "#2828FF")
    static let redOrange = Color(hex: "#FF5809")
    
    init(hex: String) {
        self.init(UIColor(hex: hex))
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }

        var rgb: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(
            GeometryReader { geometry in
                Path { path in
                    for edge in edges {
                        switch edge {
                        case .bottom:
                            path.move(to: CGPoint(x: 0, y: geometry.size.height))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                        case .leading:
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                        default: break
                        }
                    }
                }
                .stroke(color, lineWidth: width)
            }
        )
    }
}
