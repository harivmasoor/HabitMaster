import SwiftUI
import BackgroundTasks

@main
struct HabitMasterApp: App {
    @ObservedObject private var habitListViewModel = HabitListViewModel()
    private var streakViewModel = StreakViewModel()

    init() {
        setupBackgroundTask()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(habitListViewModel)
        }
    }
}

extension HabitMasterApp {
    private func setupBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.HabitMaster.resetStreaks", using: nil) { task in
            self.handleResetStreaks(task: task as! BGAppRefreshTask)
        }
        habitListViewModel.habits.forEach { habit in
            var mutableHabit = habit
            streakViewModel.resetStreaksIfNeeded(for: &mutableHabit)
        }
    }
    
    private func scheduleBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "com.example.HabitMaster.resetStreaks")
        request.earliestBeginDate = Date().nextMidnight()
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background task: \(error)")
        }
    }
    
    private func handleResetStreaks(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        DispatchQueue.main.async {
            self.habitListViewModel.habits.forEach { habit in
                var mutableHabit = habit
                self.streakViewModel.resetStreaksIfNeeded(for: &mutableHabit)
            }
        }
        task.setTaskCompleted(success: true)
        
        scheduleBackgroundTask()
    }
    
}

extension Date {
    func nextMidnight() -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: self)!
        var components = calendar.dateComponents([.year, .month, .day], from: tomorrow)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components)!
    }
}


