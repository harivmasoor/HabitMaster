import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HabitListViewModel
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
                ForEach(Array(viewModel.habits.enumerated()), id: \.element.id) { index, habit in
                    NavigationLink(destination: HabitDetailView(habit: Binding.constant(habit)), label: {
                        HabitRowView(habit: habit, toggleIsOn: Binding(
                            get: { viewModel.habits[index].isCompleted },
                            set: { newValue in
                                viewModel.habits[index].isCompleted = newValue
                                viewModel.updateStreak(for: index)
                            }
                        ))
                    })
                    .padding(.vertical, 8) // Add vertical padding to habit rows
                }
                .onDelete(perform: viewModel.deleteHabit)
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
                        .environmentObject(viewModel)
                case .longestStreaks:
                    LongestStreaksView()
                        .environmentObject(viewModel)
                case .addHabit:
                    AddEditHabitView(habitToEdit: nil)
                        .environmentObject(viewModel)
                }
            }
        }
    }

    private func formattedTimeRemainingUntilMidnight() -> String {
        let remaining = viewModel.timeRemainingUntilMidnight()
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







