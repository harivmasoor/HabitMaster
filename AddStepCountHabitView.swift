import SwiftUI

struct AddStepCountHabitView: View {
    @EnvironmentObject var stepCountViewModel: StepCountViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var goalStepCount: Int = 10000
    @State private var currentStepCount: Int = 0
    @ObservedObject var healthKitManager = HealthKitManager.shared
    

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
                        stepCountViewModel.addStepCountHabit(goalSteps: goalStepCount)
                        stepCountViewModel.saveStepGoal(stepGoal: goalStepCount)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Add Step Count Habit")
                    }

                }
            }
            .navigationTitle("New Step Count Habit")
            .onAppear {
                print("Retrieved step goal: \(stepCountViewModel.userStepGoal)") // Add this line
                goalStepCount = stepCountViewModel.userStepGoal
            }

        }
    }
}




