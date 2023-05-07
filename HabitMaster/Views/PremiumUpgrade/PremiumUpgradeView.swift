//
//  PremiumUpgrade.swift
//  HabitMaster
//
//  Created by Hari Masoor on 5/4/23.
//

import Foundation
import SwiftUI

struct PremiumUpgradeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Upgrade to Premium")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Enjoy exclusive features and benefits with a premium subscription.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: {
                    // Implement upgrading to premium here
                }) {
                    Text("Upgrade Now")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationBarTitle("Premium Upgrade", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct PremiumUpgradeView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumUpgradeView()
    }
}

///This PremiumUpgradeView struct displays a view encouraging users to upgrade to a premium subscription. It includes a navigation bar with a close button that dismisses the view. The "Upgrade Now" button is intended to handle the actual upgrading process, which you'll need to implement using in-app purchases or another payment system.
