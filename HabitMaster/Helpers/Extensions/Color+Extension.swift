//
//  Color+Extension.swift
//  HabitMaster
//
//  Created by Hari Masoor on 5/4/23.
//

import Foundation
import SwiftUI

extension Color {
    init(codableColor: CodableColor) {
        self.init(red: Double(codableColor.red) / 255.0,
                  green: Double(codableColor.green) / 255.0,
                  blue: Double(codableColor.blue) / 255.0)
    }
}
