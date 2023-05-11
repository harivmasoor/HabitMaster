import SwiftUI

struct AddEditHabitView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var viewModel: HabitListViewModel

    let habitToEdit: Habit?
    @State private var habit: Habit

    // Add a state variable for the selected completion date
    @State private var selectedCompletionDate = Date()

    init(habitToEdit: Habit? = nil) {
        self.habitToEdit = habitToEdit
        _habit = State(initialValue: habitToEdit ?? Habit(name: "", subtitle: ""))
        if let habitToEdit = habitToEdit {
            _selectedCompletionDate = State(initialValue: habitToEdit.completionDate)
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Habit Name", text: $habit.name)
                    // Replace "Habit Subtitle" with "Description"
                    TextField("Description", text: $habit.subtitle)

                    // Add a DatePicker for selecting the completion date
                    DatePicker("Completion Date", selection: $selectedCompletionDate, displayedComponents: .date)
                }
            }
            .navigationBarTitle(habitToEdit == nil ? "Add Habit" : "Edit Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        if let habitToEdit = habitToEdit, let index = viewModel.habits.firstIndex(where: { $0.id == habitToEdit.id }) {
                            // Update the habit with the selected completion date and edited description
                            var updatedHabit = habit
                            updatedHabit.subtitle = habit.subtitle
                            updatedHabit.completionDates.append(selectedCompletionDate)
                            updatedHabit.completionDate = selectedCompletionDate // Add this line
                            viewModel.habits[index] = updatedHabit
                        } else {
                            // Create a new habit with the selected completion date and edited description
                            var newHabit = habit
                            newHabit.subtitle = habit.subtitle
                            newHabit.completionDates.append(selectedCompletionDate)
                            newHabit.completionDate = selectedCompletionDate // Add this line
                            viewModel.habits.append(newHabit)
                        }

                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

 


