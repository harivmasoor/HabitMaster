import SwiftUI

struct HomeView: View {
    @State private var activeSheet: CustomMenuButton.ActiveSheet?
    @State private var currentTime = Date()
    @State private var showActionSheet = false
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var habitListViewModel: HabitListViewModel
    @ObservedObject var healthKitManager = HealthKitManager.shared
    @EnvironmentObject var stepCountViewModel: StepCountViewModel

    var body: some View {
        NavigationView {
            content
                .background(Color.gray.opacity(0.1))
                .edgesIgnoringSafeArea(.bottom)
                .onAppear {
                    print("HomeView rsin")
                    habitListViewModel.resetStreaksIfNeeded()
                    habitListViewModel.saveHabits()
                    stepCountViewModel.saveStepGoal(stepGoal: stepCountViewModel.userStepGoal)
                    print("HomeView appeared")
                    stepCountViewModel.loadStepGoal()
                }

        }
        .onChange(of: scenePhase, perform: onScenePhaseChange)
    }

    private var content: some View {
        VStack {
            List {
                // Handling StepCount Habit
                // In your HomeView
                ForEach(stepCountViewModel.stepCounts.indices, id: \.self) { index in
                    if stepCountViewModel.shouldDisplayStepCountHabit {
                        let stepCount = stepCountViewModel.stepCounts[index]
                        ZStack {
                            StepHabitRowView(stepCount: stepCount, healthKitManager: healthKitManager)
                                .environmentObject(stepCountViewModel)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .onDelete(perform: stepCountViewModel.deleteStepCount)

                
                // Handling Regular Habits
                ForEach(habitListViewModel.habits.indices, id: \.self) { index in
                    let habit = habitListViewModel.habits[index]
                    ZStack {
                        HabitRowView(habit: habit, index: index)
                            .environmentObject(habitListViewModel)
                        NavigationLink(destination: HabitDetailView(habit: habit).environmentObject(habitListViewModel)) {
                            EmptyView()
                        }
                        .buttonStyle(PlainButtonStyle())
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
                            .font(.system(size: 24, weight: .bold, design: .rounded)) // Make it bold and rounded
                        Text("Time Remaining: \(formattedTimeRemainingUntilMidnight())")
                            .font(.system(size: 18, weight: .bold, design: .rounded)) // Use medium weight and rounded design
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
                case .addStepCountHabit:  // new case
                    AddStepCountHabitView()
                        .environmentObject(stepCountViewModel)  // Added stepCountViewModel
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
            .environmentObject(StepCountViewModel())
    }
}















