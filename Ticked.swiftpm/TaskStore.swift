import Foundation

struct TaskStore {
    private static let taskKey = "savedTasks_v1"
    private static let typesKey = "savedTaskTypes_v1"

    // MARK: - Tasks
    
    static func loadTasks() -> [TaskItem] {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: taskKey) else {
            return MockData.tasks
        }

        do {
            let decoded = try JSONDecoder().decode([TaskItem].self, from: data)
            return decoded
        } catch {
            print("Failed to decode tasks:", error)
            return []
        }
    }

    static func saveTasks(_ tasks: [TaskItem]) {
        let defaults = UserDefaults.standard
        do {
            let data = try JSONEncoder().encode(tasks)
            defaults.set(data, forKey: taskKey)
        } catch {
            print("Failed to encode tasks:", error)
        }
    }

    // MARK: - Task Types
    
    static func loadTaskTypes() -> [TaskType] {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: typesKey) else {
            return MockData.taskTypes
        }

        do {
            let decoded = try JSONDecoder().decode([TaskType].self, from: data)
            return decoded
        } catch {
            print("Failed to decode task types:", error)
            return []
        }
    }

    static func saveTaskTypes(_ types: [TaskType]) {
        let defaults = UserDefaults.standard
        do {
            let data = try JSONEncoder().encode(types)
            defaults.set(data, forKey: typesKey)
        } catch {
            print("Failed to encode task types:", error)
        }
    }
}
