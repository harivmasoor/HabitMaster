import SwiftUI

struct HabitDetailView: View {
    @Binding var habit: Habit
    @State private var habitLocal: Habit
    
    init(habit: Binding<Habit>) {
        self._habit = habit
        self._habitLocal = State(initialValue: habit.wrappedValue)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.20)
                
                HabitDescriptionView(habitDescription: $habitLocal.subtitle)
                    .padding(.horizontal)
                
                HabitCompletionDateView(habit: $habitLocal)
                    .padding(.horizontal)
                
                VStack(alignment: .center, spacing: 10) {
                    Text("Current Streak: \(habitLocal.currentStreak)")
                        .font(.headline)
                    Text("Longest Streak: \(habitLocal.longestStreak)")
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
        .navigationBarTitle(habitLocal.name, displayMode: .inline)
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
        HabitDetailView(habit: .constant(Habit(name: "Meditate", subtitle: "Meditate for 5 minutes today", completionDate: Date())))
    }
}



