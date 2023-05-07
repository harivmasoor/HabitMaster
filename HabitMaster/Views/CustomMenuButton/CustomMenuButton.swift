import SwiftUI

enum CurrentView {
    case home
    case longestStreaks
    case addHabit
}

struct CustomMenuButton: View {
    @Binding var activeSheet: ActiveSheet?
    @Binding var showLongestStreaksView: Bool
    let currentView: CurrentView

    var body: some View {
        Menu {
            if currentView == .home {
                Button(action: { showLongestStreaksView = true }) {
                    Label("Longest Streaks", systemImage: "rosette")
                }
            } else {
                Button(action: { showLongestStreaksView = false }) {
                    Label("Home", systemImage: "house.fill")
                }
            }
            Button(action: { activeSheet = .addHabit }) {
                Label("Add Habit", systemImage: "plus")
            }
        } label: {
            Image(systemName: "ellipsis")
        }
    }
}

struct CustomMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomMenuButton(
            activeSheet: .constant(nil),
            showLongestStreaksView: .constant(false),
            currentView: .home
        )
    }
}


