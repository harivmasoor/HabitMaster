import SwiftUI

struct HabitDetailView: View {
    var habit: Habit
    @EnvironmentObject var habitListViewModel: HabitListViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        if let index = habitListViewModel.habits.firstIndex(where: { $0.id == habit.id }) {
            return AnyView(
                ScrollView {
                    VStack {
                        Spacer()
                            .frame(height: UIScreen.main.bounds.height * 0.20)
                        
                        HabitDescriptionView(habitDescription: $habitListViewModel.habits[index].subtitle)
                            .padding(.horizontal)
                        
                        HabitCompletionDateView(habit: $habitListViewModel.habits[index])
                            .padding(.horizontal)
                        
                        VStack(alignment: .center, spacing: 10) {
                            Text("Current Streak: \(habitListViewModel.habits[index].currentStreak)")
                                .font(.headline)
                            Text("Longest Streak: \(habitListViewModel.habits[index].longestStreak)")
                                .font(.headline)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.bottom)
                        
                        Spacer()
                        
                        deleteHabitButton(index: index)
                    }
                    .padding(.top, 20)
                }
                .edgesIgnoringSafeArea(.all)
                .background(Color(.systemGray6)) // Set the background color to grey
                .navigationBarTitle(habitListViewModel.habits[index].name, displayMode: .inline)
            )
        } else {
            // Handle the case where the habit is not found
            return AnyView(Text("Habit not found"))
        }
    }
    
    private func deleteHabitButton(index: Int) -> some View {
        Button(action: {
            habitListViewModel.deleteHabit(id: habit.id)
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Delete Habit")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HabitListViewModel()
        let habit = Habit(name: "Meditate", subtitle: "Meditate for 5 minutes today", completionDate: Date(), isCompletedYesterday: false)
        viewModel.habits.append(habit)
        return HabitDetailView(habit: habit)
            .environmentObject(viewModel)
    }
}




