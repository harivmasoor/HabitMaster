import SwiftUI

struct CustomMenuButton: View {
    enum ActiveSheet: Identifiable {
        case editHabit(habit: Habit)
        case longestStreaks
        case addHabit
        case addStepCountHabit  // new case

        var id: Int {
            switch self {
            case .editHabit(let habit):
                return habit.id.hashValue
            case .longestStreaks:
                return 1
            case .addHabit:
                return 2
            case .addStepCountHabit:  // return a unique id for this case
                return 3
            }
        }
    }

    @Binding var activeSheet: ActiveSheet?
    let currentView: CurrentView
    let onHomeButtonTapped: (() -> Void)?
    enum CurrentView {
        case home
        case longestStreaks
    }

    init(activeSheet: Binding<ActiveSheet?>, currentView: CurrentView, onHomeButtonTapped: (() -> Void)? = nil) {
        self._activeSheet = activeSheet
        self.currentView = currentView
        self.onHomeButtonTapped = onHomeButtonTapped
    }
    var body: some View {
        Menu {
            Button(action: {
                activeSheet = .addHabit
            }) {
                Label("Add Habit", systemImage: "plus")
            }

            Button(action: {   // new button for adding a step count habit
                activeSheet = .addStepCountHabit
            }) {
                Label("Add Step Count Habit", systemImage: "plus.square")
            }

            if currentView == .longestStreaks {
                Button(action: {
                    onHomeButtonTapped?()
                }) {
                    Label("Home", systemImage: "house")
                }
            } else {
                Button(action: {
                    activeSheet = .longestStreaks
                }) {
                    Label("Longest Streaks", systemImage: "chart.bar")
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.system(size: 25))
        }
    }

}

struct CustomMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomMenuButton(activeSheet: .constant(nil), currentView: .home)
    }
}



