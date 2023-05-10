import SwiftUI
import Combine

class StreakViewModel: ObservableObject {
    func updateStreak(for habit: inout Habit) {
        let currentDate = Date()
        let calendar = Calendar.current

        if habit.isCompleted {
            if let lastCompletedDate = habit.completionDates.last, calendar.isDateInToday(lastCompletedDate) {
                return
            } else {
                habit.completionDates.append(currentDate)
                if let lastCompletedDate = habit.completionDates.dropLast().last, calendar.isDateInYesterday(lastCompletedDate) {
                    habit.streak += 1
                } else {
                    habit.streak = 1
                }
                habit.longestStreak = max(habit.streak, habit.longestStreak)
            }
        } else {
            habit.completionDates = habit.completionDates.filter { !calendar.isDate($0, equalTo: currentDate, toGranularity: .day) }
            if let lastCompletedDate = habit.completionDates.last, !calendar.isDateInToday(lastCompletedDate) {
                habit.streak = 0
            }
        }
    }

    func resetStreaksIfNeeded(for habit: inout Habit) {
        let currentDate = Date()
        let calendar = Calendar.current

        if let lastCompletedDate = habit.completionDates.last, !calendar.isDate(lastCompletedDate, inSameDayAs: currentDate) {
            habit.streak = 0
        }
    }
}

