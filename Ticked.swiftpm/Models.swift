import Foundation

enum TaskStatus: String, CaseIterable, Identifiable, Codable {
    case pending = "Pending"
    case inProgress = "In Progress"
    case completed = "Completed"

    var id: String { rawValue }
}

enum TaskPriority: String, CaseIterable, Identifiable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var id: String { rawValue }
}

struct TaskType: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

struct TaskItem: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var description: String
    var dueDate: Date
    var type: TaskType
    var priority: TaskPriority
    var status: TaskStatus

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        dueDate: Date,
        type: TaskType,
        priority: TaskPriority,
        status: TaskStatus
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.type = type
        self.priority = priority
        self.status = status
    }
}
