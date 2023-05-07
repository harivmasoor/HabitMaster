import SwiftUI

enum AddEditHabitSheet: Identifiable {
    case addHabit
    case editHabit(Habit)

    var id: Int {
        switch self {
        case .addHabit:
            return 1
        case .editHabit(let habit):
            return habit.id.hashValue
        }
    }
}


struct AddEditHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: HabitListViewModel
    @Binding var activeSheet: AddEditHabitSheet?
    @State private var habitName: String = ""
    @State private var habitSubtitle: String = ""
    var habitToEdit: Habit?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit Name")) {
                    TextField("Name", text: $habitName)
                }
                Section(header: Text("Habit Subtitle")) {
                    TextField("Subtitle", text: $habitSubtitle)
                }
            }
            .navigationTitle(habitToEdit == nil ? "Add Habit" : "Edit Habit")
            .navigationBarItems(leading:
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                    activeSheet = nil
                }, trailing:
                Button(habitToEdit == nil ? "Add" : "Save") {
                    if let habitToEdit = habitToEdit {
                        if let index = viewModel.habits.firstIndex(where: { $0.id == habitToEdit.id }) {
                            viewModel.habits[index].name = habitName
                            viewModel.habits[index].subtitle = habitSubtitle
                        }
                    } else {
                        let habit = Habit(name: habitName, subtitle: habitSubtitle)
                        viewModel.habits.append(habit)
                    }
                    presentationMode.wrappedValue.dismiss()
                    activeSheet = nil
                }
            )
        }
        .onAppear {
            if let habitToEdit = habitToEdit {
                habitName = habitToEdit.name
                habitSubtitle = habitToEdit.subtitle
            }
        }
    }
}

struct AddEditHabitView_Previews: PreviewProvider {
    @State static var activeSheet: AddEditHabitSheet? = nil
    static var previews: some View {
        AddEditHabitView(activeSheet: $activeSheet, habitToEdit: nil)
            .environmentObject(HabitListViewModel())
    }
}



