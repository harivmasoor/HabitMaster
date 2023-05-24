import HealthKit

class HealthKitManager: ObservableObject {
    @Published var steps: Int = 0

    private let healthStore = HKHealthStore()
    static let shared = HealthKitManager()
    init() {
        requestPermissions()
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

        healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: { (success, error) in
            if success {
                print("Background delivery enabled")
            } else if let error = error {
                print("Error enabling background delivery: \(error.localizedDescription)")
            }
        })
    }

    private func fetchLatestStepCount() {
        let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { (query, samples, error) in
            guard let samples = samples as? [HKQuantitySample] else {
                // handle error
                return
            }

            DispatchQueue.main.async {
                let stepCount = samples.reduce(0) { $0 + $1.quantity.doubleValue(for: .count()) }
                self.steps = Int(stepCount)
            }
        }

        healthStore.execute(query)
    }

}
