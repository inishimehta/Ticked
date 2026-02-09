import Foundation

enum TaskStatus: String, CaseIterable, Identifiable {
    case pending = "Pending"
    case inProgress = "In Progress"
    case completed = "Completed"
    var id: String { rawValue }
}

enum TaskPriority: String, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    var id: String { rawValue }
}

struct TaskType: Identifiable, Hashable {
    let id = UUID()
    var name: String
}

struct TaskItem: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var description: String
    var dueDate: Date
    var type: TaskType
    var priority: TaskPriority
    var status: TaskStatus
}
