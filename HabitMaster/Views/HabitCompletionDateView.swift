import SwiftUI

struct HabitCompletionDateView: View {
    @Binding var habit: Habit
    @State private var editingCompletionDate = false
    @State private var selectedDate: Date
    
    init(habit: Binding<Habit>) {
        _habit = habit
        _selectedDate = State(initialValue: habit.wrappedValue.completionDate)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Completion Date")
                .font(.headline)
                .padding(.bottom, 5)
            
            Text(DateFormatterHelper.shared.formatDate(habit.completionDate))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.bottom)
        .onTapGesture {
            editingCompletionDate = true
        }
        .sheet(isPresented: $editingCompletionDate) {
            NavigationView {
                HabitCompletionDateEditor(completionDate: $selectedDate, habit: $habit)
            }
        }
        .onChange(of: selectedDate) { newDate in
            habit.completionDate = newDate
            habit.isCompletionDateManuallySet = true
        }
    }
}


//struct HabitCompletionDateView_Previews: PreviewProvider {
//    @State static private var previewHabit = Habit(name: "Meditate", subtitle: "Meditate for 5 minutes today", completionDate: Date(), isCompletedYesterday: false)
//
//
//    static var previews: some View {
//        HabitCompletionDateView(habit: $previewHabit)
//    }
//}



    






