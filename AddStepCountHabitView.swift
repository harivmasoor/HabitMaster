import SwiftUI

struct AddStepCountHabitView: View {
    @ObservedObject var viewModel: HabitListViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var goalStepCount: Int = 10000
    @State private var currentStepCount: Int = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit Info")) {
                    Stepper(value: $goalStepCount, in: 1000...50000, step: 1000) {
                        Text("Goal: \(goalStepCount) steps per day")
                    }
                }
                Section {
                    Button(action: {
                        let newHabit = Habit(name: "Daily Step Goal",
                                             subtitle: "",
                                             lastCompletionDate: nil,
                                             currentStepCount: currentStepCount,
                                             goalStepCount: goalStepCount)
                        viewModel.habits.append(newHabit)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Add Habit")
                    }
                }
            }
            .navigationTitle("New Step Count Habit")
        }
    }
}

