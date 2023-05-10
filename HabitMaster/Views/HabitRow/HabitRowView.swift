import SwiftUI

struct HabitRowView: View {
    var index: Int
    @EnvironmentObject var habitListViewModel: HabitListViewModel
    
    var body: some View {
        let isOn = Binding<Bool>(
            get: { habitListViewModel.habits[index].isCompleted },
            set: { newValue in
                habitListViewModel.updateHabitCompletionState(id: habitListViewModel.habits[index].id, isCompleted: newValue)
            }
        )
        
        return HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(habitListViewModel.habits[index].name)
                    .font(.headline)
            }
            Spacer()
            Circle()
                .foregroundColor(.yellow)
                .frame(width: 30, height: 30)
                .overlay(
                    Text("\(habitListViewModel.habits[index].currentStreak)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                )
            Toggle("", isOn: isOn)
                .labelsHidden()
        }
    }
}

struct HabitRowView_Previews: PreviewProvider {
    static var previews: some View {
        let habit = Habit(name: "Meditation", subtitle: "Meditate for 10 minutes")
        let viewModel = HabitListViewModel()
        viewModel.habits.append(habit)
        return HabitRowView(index: 0)
            .environmentObject(viewModel)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.white)
    }
}












