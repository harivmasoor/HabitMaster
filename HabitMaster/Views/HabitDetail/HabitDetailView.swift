import SwiftUI

struct HabitDetailView: View {
    let index: Int
    @EnvironmentObject var habitListViewModel: HabitListViewModel
    
    var body: some View {
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
                
                deleteHabitButton
            }
            .padding(.top, 20)
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color(.systemGray6)) // Set the background color to grey
        .navigationBarTitle(habitListViewModel.habits[index].name, displayMode: .inline)
    }
    
    private var deleteHabitButton: some View {
        Button(action: {
            // Add your delete habit action here
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
        viewModel.habits.append(Habit(name: "Meditate", subtitle: "Meditate for 5 minutes today", completionDate: Date()))
        return HabitDetailView(index: 0)
            .environmentObject(viewModel)
    }
}



