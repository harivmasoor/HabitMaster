import SwiftUI

struct LongestStreaksView: View {
    @EnvironmentObject var viewModel: HabitListViewModel
    @State private var activeSheet: ActiveSheet?
    @Binding var showLongestStreaksView: Bool
    @State private var shouldReturnToHome = false
    @State private var showAddHabitView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.habits.filter { $0.longestStreak >= 1 }, id: \.id) { habit in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(habit.name)
                                .font(.headline)
                            Text(habit.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(3)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "rosette")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(.yellow)
                            .overlay(
                                Text("\(habit.longestStreak)")
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            )
                    }
                }
                .onDelete(perform: deleteHabit)
            }
            .navigationBarTitle("Longest Streaks")
            .navigationBarItems(trailing:
                                    CustomMenuButton(
                                        activeSheet: $activeSheet,
                                        showLongestStreaksView: $showLongestStreaksView,
                                        currentView: .longestStreaks
                                    )
            )
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .addHabit:
                    AddEditHabitView(activeSheet: .constant(nil), habitToEdit: nil)
                        .environmentObject(viewModel)
                case .editHabit(let habit):
                    AddEditHabitView(activeSheet: .constant(nil), habitToEdit: habit)
                        .environmentObject(viewModel)
                }
            }
        }
    }
    
    private func deleteHabit(at offsets: IndexSet) {
        viewModel.habits.remove(atOffsets: offsets)
    }
}

struct LongestStreaksView_Previews: PreviewProvider {
    static var previews: some View {
        LongestStreaksView(showLongestStreaksView: .constant(false))
            .environmentObject(HabitListViewModel())
    }
}
