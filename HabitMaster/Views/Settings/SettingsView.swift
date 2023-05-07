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


///Remember that you'll need to connect this view to your data management system (e.g., User Defaults, Core Data, or a remote API) to save and retrieve user settings. Additionally, you'll need to implement actual notifications using UNUserNotificationCenter or another notification framework
