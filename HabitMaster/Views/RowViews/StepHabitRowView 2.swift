import SwiftUI

struct StepHabitRowView: View {
    @ObservedObject var stepCount: StepCount
    @ObservedObject var healthKitManager: HealthKitManager
    @EnvironmentObject var stepCountViewModel: StepCountViewModel

    var body: some View {
        print("StepCount actualSteps: \(stepCount.actualSteps)")
        let isOn = Binding<Bool>(
            get: {
                self.stepCount.isCompleted
            },
            set: { newValue in
                if newValue != self.stepCount.isCompleted {
                    self.stepCount.isCompleted = newValue
                    if newValue {
                        self.stepCountViewModel.checkAndCompleteStepCount(self.stepCount)
                    } else {
                        self.stepCount.currentStreak = 0
                    }
                    healthKitManager.fetchLatestStepCount()
                    self.stepCountViewModel.saveStepCounts()
                }
            }
        )

        return HStack {
            VStack(alignment: .leading, spacing: 10) { // Increase spacing
                Text("Daily Step Goal")
                    .font(.headline)
                    .foregroundColor(.black)
                Text("\(stepCount.actualSteps) / \(stepCount.goalSteps) steps")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            Spacer()
            Circle()
                .foregroundColor(isOn.wrappedValue ? .green : .red)
                .frame(width: 30, height: 30)
                .overlay(
                    Text("\(stepCount.currentStreak)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                )
            Toggle("", isOn: isOn)
                .labelsHidden()
                .disabled(true)
        }
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 12, trailing: 16)) // Adjust padding
        .background(Color.white)
        .swipeActions {
            Button {
                stepCountViewModel.deleteStepCount(id: stepCount.id)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
    }
}


