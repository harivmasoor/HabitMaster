import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HabitListViewModel
    @State private var activeSheet: AddEditHabitSheet?

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.habits, id: \.id) { habit in
                    VStack(alignment: .leading) {
                        Text(habit.name)
                            .font(.headline)
                        Text(habit.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(3)
                    }
                    .onTapGesture {
                        activeSheet = .editHabit(habit)
                    }
                }
                .onDelete(perform: viewModel.deleteHabit)
            }
            .navigationBarTitle("Habits")
            .navigationBarItems(trailing: Button(action: {
                activeSheet = .addHabit
            }) {
                Image(systemName: "plus")
            })
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .addHabit:
                    AddEditHabitView(activeSheet: $activeSheet, habitToEdit: nil)
                        .environmentObject(viewModel)
                case .editHabit(let habit):
                    AddEditHabitView(activeSheet: $activeSheet, habitToEdit: habit)
                        .environmentObject(viewModel)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HabitListViewModel())
    }
}



