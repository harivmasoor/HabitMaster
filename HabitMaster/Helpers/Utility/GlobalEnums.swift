import Foundation

enum ActiveSheet: Identifiable {
    case addHabit
    case editHabit(habit: Habit)
    
    var id: String {
        switch self {
        case .addHabit:
            return "addHabit"
        case .editHabit(let habit):
            return "editHabit-\(habit.id)"
        }
    }
}
