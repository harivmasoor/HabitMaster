import SwiftUI

struct HabitRowView: View {
    @ObservedObject var habit: Habit
    @EnvironmentObject var habitListViewModel: HabitListViewModel
    let index: Int

    @State private var showingDetail = false  // Add this state variable

    var body: some View {
        let isOn = Binding<Bool>(
            get: { self.habit.isCompleted },
            set: { newValue in
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
        )

        ZStack {
            NavigationLink(destination: HabitDetailView(habit: habit)
                            .environmentObject(habitListViewModel), label: { EmptyView() })
            HStack {
                Button(action: {
                    self.showingDetail.toggle()
                }) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(habit.name)
                            .font(.headline)

                        Text(habit.subtitle)
                            .font(.subheadline)
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
                }
                .buttonStyle(PlainButtonStyle())

                Toggle("", isOn: isOn)
                    .labelsHidden()
            }
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 12, trailing: 16))
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












