//
//  CodableColor.swift
//  HabitMaster
//
//  Created by Hari Masoor on 5/4/23.
//

import SwiftUI
import UIKit

struct CodableColor: Codable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double

    init(color: Color) {
        let components = color.components()
        self.red = components.red
        self.green = components.green
        self.blue = components.blue
        self.opacity = components.opacity
    }

    func color() -> Color {
        return Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

extension Color {
    func components() -> (red: Double, green: Double, blue: Double, opacity: Double) {
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)

        return (red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
    }
}

