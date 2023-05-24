import SwiftUI

struct HabitRowView: View {
    @ObservedObject var habit: Habit
    @EnvironmentObject var habitListViewModel: HabitListViewModel
    @ObservedObject var healthKitManager = HealthKitManager.shared
    let index: Int
    
    var body: some View {
        let isOn = Binding<Bool>(
            get: { self.habit.name == "Daily Step Goal" ? healthKitManager.steps >= self.habit.goalStepCount : self.habit.isCompleted },
            set: { newValue in
                if self.habit.name == "Daily Step Goal" {
                    if healthKitManager.steps >= self.habit.goalStepCount {
                        if !self.habit.isCompleted {
                            self.habitListViewModel.completeHabit(self.habit)
                            print("Completion date after toggling ON: \(self.habit.completionDate)")
                        }
                    }
                } else {
                    if newValue {
                        if !self.habit.isCompleted {
                            self.habitListViewModel.completeHabit(self.habit)
                            print("Completion date after toggling ON: \(self.habit.completionDate)")
                        }
                    } else {
                        if self.habit.isCompleted {
                            self.habitListViewModel.incompleteHabit(self.habit)
                            print("Completion date after toggling OFF: \(self.habit.completionDate)")
                        }
                    }
                }
                print("Current steps: \(healthKitManager.steps)")
            }
        )
        
        return HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(habit.name)
                    .font(.headline)
                
                if habit.name == "Daily Step Goal" {
                    Text("\(healthKitManager.steps) / \(habit.goalStepCount) steps")
                        .font(.subheadline)
                }
            }
            
            Spacer()
            Circle()
                .foregroundColor(.yellow)
                .frame(width: 30, height: 30)
                .overlay(
                    Text("\(habit.currentStreak)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                )
            Toggle("", isOn: isOn)
                .labelsHidden()
        }
        .padding(.vertical, 8)
        .swipeActions {
            Button {
                habitListViewModel.deleteHabit(id: habit.id) // delete by id
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
    }
}



struct HabitRowView_Previews: PreviewProvider {
    static var previews: some View {
        let habit = Habit(name: "Meditation", subtitle: "Meditate for 10 minutes")
        let viewModel = HabitListViewModel()
        viewModel.habits.append(habit)
        return HabitRowView(habit: viewModel.habits[0], index: 0)
            .environmentObject(viewModel)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.white)
    }
}












