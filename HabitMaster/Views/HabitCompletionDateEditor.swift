import SwiftUI

struct HabitCompletionDateEditor: View {
    @Binding var completionDate: Date
    @Binding var habit: Habit
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            DatePicker("Completion Date", selection: $completionDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            Button("Save") {
                habit.completionDate = completionDate
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .navigationTitle("Edit Completion Date")
    }
}



//struct HabitCompletionDateEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitCompletionDateEditor(completionDate: .constant(Date()))
//    }
//}
