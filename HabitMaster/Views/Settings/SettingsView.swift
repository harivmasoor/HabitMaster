//
//  Settings.swift
//  HabitMaster
//
//  Created by Hari Masoor on 5/4/23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @State private var enableNotifications: Bool = true
    @State private var notificationTime: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $enableNotifications)
                    
                    if enableNotifications {
                        DatePicker("Notification Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(CompactDatePickerStyle())
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


