import Foundation
import Combine
import UIKit
import SwiftUI

class CustomAppDelegate: UIResponder, UIApplicationDelegate {
    let habitListViewModel = HabitListViewModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(saveHabits), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveHabits), name: UIApplication.willTerminateNotification, object: nil)
        return true
    }

    @objc func saveHabits() {
        habitListViewModel.saveHabits()
    }
}

class HabitListViewModel: ObservableObject {
    @Published var habits: [Habit] = [] {
        didSet {
            // When a habit is added, subscribe to its changes
            if habits.count > oldValue.count {
                let newHabit = habits.last!
                habitSubscriptions[newHabit.id] = newHabit.objectWillChange.sink { [weak self] _ in
                    self?.objectWillChange.send()
                    self?.saveHabits()
                }
            }
            // When a habit is removed, unsubscribe from its changes
            else if habits.count < oldValue.count {
                for habit in oldValue where !habits.contains(habit) {
                    habitSubscriptions[habit.id]?.cancel()
                    habitSubscriptions[habit.id] = nil
                }
            }
        }
    }
    private var habitSubscriptions: [UUID: AnyCancellable] = [:]
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "habits") {
            let decoder = JSONDecoder()
            if let decodedHabits = try? decoder.decode([Habit].self, from: data) {
                self.habits = decodedHabits
            } else {
                self.habits = []
            }
        } else {
            self.habits = []
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.saveHabits()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: nil) { [weak self] _ in
            self?.saveHabits()
        }
    }
    
    func saveHabits() {
        let encoder = JSONEncoder()
        if let encodedHabits = try? encoder.encode(habits) {
            UserDefaults.standard.set(encodedHabits, forKey: "habits")
        }
    }
    func deleteHabit(id: UUID) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            habits.remove(at: index)
            saveHabits()
        }
    }
    func deleteHabit(atOffsets offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
        saveHabits()
    }
    
    func timeRemainingUntilMidnight() -> TimeInterval {
        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: Date().addingTimeInterval(24*60*60))
        let timeUntilMidnight = midnight.timeIntervalSinceNow
        return timeUntilMidnight
    }
    
    func updateHabitCompletionState(id: UUID, isCompleted: Bool) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            let habit = habits[index]
            
            // Only update the streak if the state is actually changing
            if habit.isCompleted != isCompleted {
                if isCompleted {
                    habit.currentStreak += 1
                } else if habit.currentStreak > 0 {
                    habit.currentStreak -= 1
                }
            }

            habit.isCompleted = isCompleted
        }
    }


    
    func resetStreaksIfNeeded() {
        for index in habits.indices {
            if !Calendar.current.isDateInToday(habits[index].completionDate) && habits[index].isCompleted {
                habits[index].isCompleted = false
                habits[index].currentStreak = 0
            } else if Calendar.current.isDateInToday(habits[index].completionDate) && !habits[index].isCompleted {
                habits[index].isCompleted = true
                habits[index].currentStreak += 1
                if habits[index].currentStreak > habits[index].longestStreak {
                    habits[index].longestStreak = habits[index].currentStreak
                }
            }
        }
    }
    func getIndex(byId id: UUID) -> Int? {
        return habits.firstIndex(where: { $0.id == id })
    }

    
}














