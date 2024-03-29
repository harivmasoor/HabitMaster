import Foundation
import Combine
import SwiftUI
import StoreKit

class HabitListViewModel: ObservableObject {
    @Published var habits: [Habit] = [] {
        didSet {
            if habits.count > oldValue.count {
                let newHabit = habits.last!
                habitSubscriptions[newHabit.id] = newHabit.objectWillChange.sink { [weak self] _ in
                    self?.objectWillChange.send()
                    self?.saveHabits()
                }
            } else if habits.count < oldValue.count {
                for habit in oldValue where !habits.contains(habit) {
                    habitSubscriptions[habit.id]?.cancel()
                    habitSubscriptions[habit.id] = nil
                }
            }
            saveHabits()
        }
    }

    private var habitSubscriptions: [UUID: AnyCancellable] = [:]
    
    init() {
        loadHabits()
        resetStreaksIfNeeded()

        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: nil) { [weak self] _ in
            self?.saveHabits()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.resetStreaksIfNeeded()
        }

        let timer = Timer(fire: Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))!,
                          interval: 24 * 60 * 60,
                          repeats: true,
                          block: { [weak self] _ in
                            self?.resetStreaksIfNeeded()
                          })

        RunLoop.main.add(timer, forMode: .common)
    }

    func loadHabits() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "habits"),
           let decodedHabits = try? decoder.decode([Habit].self, from: data) {
            self.habits = decodedHabits
            for habit in habits {
                habitSubscriptions[habit.id] = habit.objectWillChange.sink { [weak self] _ in
                    self?.objectWillChange.send()
                    self?.saveHabits()
                }
            }
        }
    }

    func saveHabits() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(habits) {
            UserDefaults.standard.set(encodedData, forKey: "habits")
        } else {
            print("Failed to encode habits")
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
    
    func updateHabitCompletionState(id: UUID, isCompleted: Bool) {
        if let index = habits.firstIndex(where: { $0.id == id }) {
            let habit = habits[index]

            if isCompleted {
                completeHabit(habit)
            } else {
                incompleteHabit(habit)
            }
        }
    }

    func getIndex(byId id: UUID) -> Int? {
        return habits.firstIndex(where: { $0.id == id })
    }
    
    func resetStreaksIfNeeded() {
        let calendar = Calendar.current
        for habit in habits where habit.isCompleted {
            if let lastCompletionDate = habit.lastCompletionDate, !calendar.isDateInToday(lastCompletionDate) {
                if calendar.isDateInYesterday(lastCompletionDate) {
                    habit.currentStreak += 1
                } else {
                    habit.currentStreak = 0
                }
                habit.isCompleted = false
                saveHabits()
            }
        }
    }


    func timeRemainingUntilMidnight() -> TimeInterval {
        let calendar = Calendar.current
        let now = Date()
        let nextMidnight = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!
        return nextMidnight.timeIntervalSince(now)
    }

    func completeHabit(_ habit: Habit) {
        habit.isCompleted = true
        habit.completedToday = true
        habit.currentStreak += 1
        habit.lastCompletionDate = Date()

        if habit.currentStreak > habit.longestStreak {
            habit.longestStreak = habit.currentStreak
        }

        saveHabits()
    }

    func incompleteHabit(_ habit: Habit) {
        habit.isCompleted = false
        habit.completedToday = false
        habit.currentStreak = max(0, habit.currentStreak - 1)
        habit.lastCompletionDate = nil

        saveHabits()
    }

    func shouldPromptForReview() -> Bool {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date()
        let lastPromptDate = UserDefaults.standard.object(forKey: "LastReviewPromptDate") as? Date ?? oneWeekAgo
        return lastPromptDate < oneWeekAgo
    }

    func promptForReview() {
        if shouldPromptForReview() {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
            UserDefaults.standard.set(Date(), forKey: "LastReviewPromptDate")
        }
    }
}











