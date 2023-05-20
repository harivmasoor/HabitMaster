import SwiftUI

struct HomeView: View {
    @State private var activeSheet: CustomMenuButton.ActiveSheet?
    @State private var currentTime = Date()
    @State private var showActionSheet = false
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var habitListViewModel: HabitListViewModel


    var body: some View {
        NavigationView {
            content
                .background(Color.gray.opacity(0.1))
                .edgesIgnoringSafeArea(.bottom)
                .onAppear {
                    print("HomeView rsin")
                    habitListViewModel.resetStreaksIfNeeded()
                    habitListViewModel.saveHabits()
                }
        }
        .onChange(of: scenePhase, perform: onScenePhaseChange)
    }

    private var content: some View {
        VStack {
            List {
                ForEach(habitListViewModel.habits.indices, id: \.self) { index in
                    let habit = habitListViewModel.habits[index]
                    NavigationLink(destination: HabitDetailView(habit: habit).environmentObject(habitListViewModel)) {
                        HabitRowView(habit: habit, index: index)
                            .environmentObject(habitListViewModel)
                    }
                    .padding(.vertical, 8) // Add vertical padding to habit rows
                }

                .onDelete(perform: habitListViewModel.deleteHabit)

            }
            .listStyle(PlainListStyle())
            .padding(.top, 16)
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

    func timeRemainingUntilMidnight() -> TimeInterval {
        let calendar = Calendar.current
        let now = Date()
        let midnight = calendar.startOfDay(for: now).addingTimeInterval(24 * 60 * 60)
        return midnight.timeIntervalSince(now)
    }

    private func onScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .background, .inactive:
            // Handle background or inactive state if needed
            habitListViewModel.promptForReview()
            break
        default:
            break
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













