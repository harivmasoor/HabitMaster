import SwiftUI
import Combine

class HabitListViewModel: ObservableObject {
    @Published var habits: [Habit] {
        didSet {
            saveHabits()
        }
    }
    @Published var activeSheet: ActiveSheet?
    private var cancellables = Set<AnyCancellable>()

    func setInitialHabitsIfNeeded() -> [Habit] {
        if UserDefaults.standard.data(forKey: "habits") == nil {
            let meditation = Habit(name: "Meditation", subtitle: "Meditate for 10 minutes")
            let prayer = Habit(name: "Prayer", subtitle: "Pray in the morning and evening")
            let brushingTeeth = Habit(name: "Brushing Teeth", subtitle: "Brush teeth after waking up and before bedtime")
            
            return [meditation, prayer, brushingTeeth]
        }
        return []
    }

    init() {
        var initialHabits: [Habit] = []
        
        if UserDefaults.standard.data(forKey: "habits") == nil {
            let meditation = Habit(name: "Meditation", subtitle: "Meditate for 10 minutes")
            let prayer = Habit(name: "Prayer", subtitle: "Pray in the morning and evening")
            let brushingTeeth = Habit(name: "Brushing Teeth", subtitle: "Brush teeth after waking up and before bedtime")
            
            initialHabits = [meditation, prayer, brushingTeeth]
        }
        
        if let data = UserDefaults.standard.data(forKey: "habits") {
            let decoder = JSONDecoder()
            if let decodedHabits = try? decoder.decode([Habit].self, from: data) {
                self.habits = decodedHabits
            } else {
                self.habits = initialHabits.isEmpty ? [] : initialHabits
            }
        } else {
            self.habits = initialHabits
            saveHabits()
        }
        
        $habits
            .sink { newValue in
                print("habits: \(newValue)")
            }
            .store(in: &cancellables)
    }




    private func saveHabits() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(habits) {
            UserDefaults.standard.set(data, forKey: "habits")
        }
    }

    func deleteHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }

    func editHabit(_ habit: Habit) {
        activeSheet = .editHabit(habit: habit)
    }

    func createNewHabit() {
        activeSheet = .addHabit
    }
    
    func bindingForHabit(at index: Int) -> Binding<Habit> {
        return Binding<Habit>(
            get: { self.habits[index] },
            set: { self.habits[index] = $0 }
        )
    }

    func toggleHabitCompletion(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].isCompleted.toggle()
            handleHabitCompletionUpdates(habit: &habits[index])
        }
    }

    private func handleHabitCompletionUpdates(habit: inout Habit) {
        let now = Date()
        let calendar = Calendar.current

        if habit.isCompleted {
            habit.completionDates.append(now)
            if let lastCompletionDate = habit.completionDates.dropLast().last, calendar.isDateInYesterday(lastCompletionDate) {
                habit.streak += 1
            } else {
                habit.streak = 1
            }
            habit.longestStreak = max(habit.streak, habit.longestStreak)
        } else {
            let todayMidnight = calendar.startOfDay(for: now)
            habit.completionDates = habit.completionDates.filter { !calendar.isDate($0, equalTo: now, toGranularity: .day) }
            if let lastCompletionDate = habit.completionDates.last, calendar.isDate(lastCompletionDate, equalTo: todayMidnight, toGranularity: .day) {
                habit.streak -= 1
            }
        }

        saveHabits()
    }
    
    func resetStreaksIfNeeded() {
        let calendar = Calendar.current
        for index in habits.indices {
            if let lastCompletionDate = habits[index].completionDates.last, !calendar.isDateInToday(lastCompletionDate), !calendar.isDateInYesterday(lastCompletionDate) {
                habits[index].streak = 0
            }
        }
    }
    func timeRemainingUntilMidnight() -> TimeInterval {
        let now = Date()
        let calendar = Calendar.current
        let tomorrowMidnight = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: now)!)
        return tomorrowMidnight.timeIntervalSince(now)
    }
    func updateStreak(for index: Int) {
        let currentDate = Date()
        let lastCompletedDate = habits[index].completionDates.last
        let calendar = Calendar.current
        
        if let lastCompletedDate = lastCompletedDate {
            let components = calendar.dateComponents([.day], from: lastCompletedDate, to: currentDate)
            if let days = components.day, days == 1 {
                habits[index].streak += 1
            } else if let days = components.day, days != 0 {
                habits[index].streak = 0
            }
        } else {
            habits[index].streak = habits[index].isCompleted ? 1 : 0
        }
        
        if habits[index].streak > habits[index].longestStreak {
            habits[index].longestStreak = habits[index].streak
        }
        
        if habits[index].isCompleted {
            if let lastCompletedDate = lastCompletedDate, !calendar.isDateInToday(lastCompletedDate) {
                habits[index].completionDates.append(currentDate)
            } else if lastCompletedDate == nil {
                habits[index].completionDates.append(currentDate)
            }
        } else {
            habits[index].completionDates = habits[index].completionDates.filter { !calendar.isDate($0, equalTo: currentDate, toGranularity: .day) }
        }
    }






}






