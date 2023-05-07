//
//  DateFormatter.swift
//  HabitMaster
//
//  Created by Hari Masoor on 5/4/23.
//

import Foundation
import Foundation

struct DateFormatterHelper {
    static let shared = DateFormatterHelper()
    
    private let dateFormatter = DateFormatter()
    
    private init() {
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
    }
    
    func formatDate(_ date: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func formatTime(_ date: Date) -> String {
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: date)
    }
    
    func formatDate(_ date: Date) -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
