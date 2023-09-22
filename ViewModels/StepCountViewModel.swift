import Foundation
import Combine
import SwiftUI

extension Date {
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
}

class StepCountViewModel: ObservableObject {
    @Published var stepCounts: [StepCount] = [] {
        didSet {
            saveStepCounts()
        }
    }
    var shouldDisplayStepCountHabit: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "ShouldDisplayStepCountHabit")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ShouldDisplayStepCountHabit")
        }
    }

    var todayStepCount: StepCount? {
        stepCounts.first(where: { $0.date.isToday })
    }

    @Published var healthKitManager = HealthKitManager()
    @Published var userStepGoal: Int = UserDefaults.standard.integer(forKey: "userStepGoal") != 0 ? UserDefaults.standard.integer(forKey: "userStepGoal") : 10000

    init() {
        loadStepCounts()
        loadLastSessionSteps()
        resetStreaksIfNeeded()

        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: nil) { [weak self] _ in
            self?.saveStepCounts()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.resetStreaksIfNeeded()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: nil) { [weak self] _ in
            self?.saveLastSessionSteps()
            self?.saveStepCounts()
        }

        let timer = Timer(fire: Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))!,
                          interval: 24 * 60 * 60,
                          repeats: true,
                          block: { [weak self] _ in
                            self?.resetStreaksIfNeeded()
                          })

        RunLoop.main.add(timer, forMode: .common)

        _ = healthKitManager.$steps.sink { [weak self] steps in
            print("HealthKit steps updated: \(steps)") // Debug print statement
            guard let self = self else { return }

            // Get today's step count or create a new one
            let stepCount = self.todayStepCount ?? {
                let newStepCount = StepCount(goalSteps: self.userStepGoal, actualSteps: steps, date: Date())
                self.stepCounts.append(newStepCount)
                return newStepCount
            }()

            // Update the step count with the latest steps from HealthKit
            stepCount.updateSteps(steps: steps)

            self.saveStepCounts()
        }
    }

    func saveLastSessionSteps() {
        if let todayStepCount = self.todayStepCount {
            UserDefaults.standard.set(todayStepCount.actualSteps, forKey: "lastSessionSteps")
            print("Last session steps saved to UserDefaults.")
        } else {
            print("No steps data available to save.")
        }
    }


    func loadStepCounts() {
        if let data = UserDefaults.standard.data(forKey: "stepCounts") {
            let decoder = JSONDecoder()
            if let decodedStepCounts = try? decoder.decode([StepCount].self, from: data) {
                self.stepCounts = decodedStepCounts
                print("Step counts loaded from UserDefaults: \(self.stepCounts)")
            } else {
                print("Failed to decode step counts")
            }
        } else {
            print("No step counts data found in UserDefaults")
        }
    }


    func saveStepCounts() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(stepCounts) {
            UserDefaults.standard.set(encodedData, forKey: "stepCounts")
            print("Step counts saved to UserDefaults.")
        } else {
            print("Failed to encode step counts")
        }
    }

    func deleteStepCount(id: UUID) {
        if let index = stepCounts.firstIndex(where: { $0.id == id }) {
            stepCounts.remove(at: index)
            saveStepCounts()
            shouldDisplayStepCountHabit = false
        }
    }

    func deleteStepCount(atOffsets offsets: IndexSet) {
        stepCounts.remove(atOffsets: offsets)
        saveStepCounts()
        shouldDisplayStepCountHabit = false
    }
    func loadLastSessionSteps() {
        let lastSessionSteps = UserDefaults.standard.integer(forKey: "lastSessionSteps")
        print("Loaded last session steps from UserDefaults: \(lastSessionSteps)")
        if let todayStepCount = self.todayStepCount {
            todayStepCount.actualSteps = lastSessionSteps
        } else if self.shouldDisplayStepCountHabit {
            let newStepCount = StepCount(goalSteps: self.userStepGoal, actualSteps: lastSessionSteps, date: Date())
            self.stepCounts.append(newStepCount)
        }
    }
    func saveStepGoal(stepGoal: Int) {
        UserDefaults.standard.set(stepGoal, forKey: "userStepGoal")
        self.userStepGoal = stepGoal
    }

    func loadStepGoal() {
        let loadedStepGoal = UserDefaults.standard.integer(forKey: "userStepGoal")
        self.userStepGoal = loadedStepGoal
    }

    func resetStreaksIfNeeded() {
        let calendar = Calendar.current
        for stepCount in stepCounts {
            let isSameDay = stepCount.date.isToday
            let isPreviousDay = stepCount.lastCompletionDate.map { calendar.isDateInYesterday($0) } ?? false


            // If the last completion date was the previous day and the stepCount is completed, increment the streak
            if isPreviousDay && stepCount.isCompleted {
                stepCount.currentStreak += 1
            }

            // If the date of the step count is not today, mark it as not completed
            if !isSameDay {
                stepCount.isCompleted = false
            }
        }

        // Create a new StepCount for the new day if it doesn't exist
        if !calendar.isDateInToday(stepCounts.last?.date ?? Date()) && shouldDisplayStepCountHabit {
            let newStepCount = StepCount(goalSteps: self.userStepGoal, actualSteps: healthKitManager.steps, date: Date())
            stepCounts.append(newStepCount)
        }

        saveStepCounts()
    }


    
    func addStepCountHabit(goalSteps: Int) {
        // If a StepCount already exists for today, update it
        if let todayStepCount = self.todayStepCount {
            todayStepCount.goalSteps = goalSteps
            todayStepCount.updateSteps(steps: healthKitManager.steps)
            todayStepCount.isCompleted = todayStepCount.actualSteps >= todayStepCount.goalSteps
        } else {
            // Otherwise, create a new one
            let newStepCountHabit = StepCount(goalSteps: goalSteps, actualSteps: healthKitManager.steps, date: Date())
            newStepCountHabit.isCompleted = newStepCountHabit.actualSteps >= newStepCountHabit.goalSteps
            stepCounts.append(newStepCountHabit)
            incrementStreakIfNeeded(for: newStepCountHabit)
        }

        saveStepGoal(stepGoal: goalSteps)
        shouldDisplayStepCountHabit = true
    }


    func checkAndCompleteStepCount(_ stepCount: StepCount) {
        stepCount.isCompleted = stepCount.actualSteps >= stepCount.goalSteps
        if stepCount.isCompleted {
            if stepCount.lastCompletionDate == nil || Calendar.current.isDateInYesterday(stepCount.lastCompletionDate!) {
                stepCount.currentStreak += 1
            }
            stepCount.lastCompletionDate = Date()
        } else if Calendar.current.isDateInYesterday(stepCount.lastCompletionDate!) {
            stepCount.currentStreak = max(0, stepCount.currentStreak - 1)
        }
        saveStepCounts()
    }

    func incrementStreakIfNeeded(for stepCount: StepCount) {
        if stepCount.actualSteps >= stepCount.goalSteps {
            stepCount.currentStreak += 1
        }
    }

}





