import HealthKit

class HealthKitManager: ObservableObject {
    @Published var steps: Int {
        didSet {
            UserDefaults.standard.set(steps, forKey: "HealthKitManagerSteps")
        }
    }

    private let healthStore = HKHealthStore()
    static let shared = HealthKitManager()

    init() {
        self.steps = UserDefaults.standard.integer(forKey: "HealthKitManagerSteps")
        requestPermissions()
        fetchLatestStepCount()
    }

    func requestPermissions() {
        let typesToRead: Set<HKObjectType> = [.quantityType(forIdentifier: .stepCount)!]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            if success {
                print("Permission granted")
                self.startObservingStepCount()
            } else if let error = error {
                print("Error requesting health data permissions: \(error.localizedDescription)")
            }
        }
    }

    func startObservingStepCount() {
        let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount)!

        let query = HKObserverQuery(sampleType: sampleType, predicate: nil) { (query, completionHandler, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.fetchLatestStepCount()
                    print("Observing step count")
                }
            }
        }

        healthStore.execute(query)
        healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: { (success, error) in
            if success {
                print("Background delivery enabled")
            } else if let error = error {
                print("Error enabling background delivery: \(error.localizedDescription)")
            }
        })

    }

    func fetchLatestStepCount() {
        let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount)!

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            if let error = error {
                print("Error fetching step count: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                guard let result = result, let sum = result.sumQuantity() else {
                    print("Error fetching step count: result is nil")
                    return
                }
                
                let stepCount = sum.doubleValue(for: .count())
                self.steps = Int(stepCount)
                print("Updated steps: \(self.steps)")
            }
        }

        healthStore.execute(query)
    }


}
