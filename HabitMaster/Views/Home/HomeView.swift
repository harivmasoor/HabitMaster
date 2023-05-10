import SwiftUI

struct HomeView: View {
    @EnvironmentObject var habitListViewModel: HabitListViewModel
    @State private var activeSheet: CustomMenuButton.ActiveSheet?
    @State private var currentTime = Date()
    @State private var showActionSheet = false

    var body: some View {
        NavigationView {
            content
                .background(Color.gray.opacity(0.1))
                .edgesIgnoringSafeArea(.bottom)
        }
    }

    private var content: some View {
        VStack {
            List {
                ForEach(Array(habitListViewModel.habits.indices), id: \.self) { index in
                    let habitBinding = $habitListViewModel.habits[index]
                    NavigationLink(destination: HabitDetailView(habit: habitBinding)) {
                        HabitRowView(habit: habitBinding.wrappedValue, toggleIsOn: Binding(
                            get: { habitListViewModel.habits[index].isCompleted },
                            set: { newValue in
                                habitListViewModel.habits[index].isCompleted = newValue
                                habitListViewModel.updateStreaksIfNeeded()
                            }
                        ))
                    }
                    .padding(.vertical, 8) // Add vertical padding to habit rows
                }

                .onDelete(perform: habitListViewModel.deleteHabit)
            }
            .listStyle(PlainListStyle())
            .padding(.top, 16) // Add top padding to the list
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("My Habits")
                            .font(.headline)
                        Text("Time Remaining: \(formattedTimeRemainingUntilMidnight())")
                            .font(.subheadline)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    CustomMenuButton(
                        activeSheet: $activeSheet,
                        currentView: .home
                    )
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .editHabit(let habit):
                    AddEditHabitView(habitToEdit: habit)
                        .environmentObject(habitListViewModel)
                case .longestStreaks:
                    LongestStreaksView()
                        .environmentObject(habitListViewModel)
                case .addHabit:
                    AddEditHabitView(habitToEdit: nil)
                        .environmentObject(habitListViewModel)
                }
            }
        }
    }

    private func formattedTimeRemainingUntilMidnight() -> String {
        let remaining = habitListViewModel.timeRemainingUntilMidnight()
        let hours = Int(remaining / 3600)
        let minutes = Int((remaining.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(hours)h \(minutes)m"
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HabitListViewModel())
    }
}









