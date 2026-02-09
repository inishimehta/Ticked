import Foundation

enum MockData {
    static let taskTypes: [TaskType] = [
        .init(name: "Design"),
        .init(name: "Development"),
        .init(name: "Meeting"),
        .init(name: "Documentation"),
        .init(name: "Testing")
    ]

    static let tasks: [TaskItem] = [
        .init(title: "Design app mockups",
              description: "Create wireframes for all screens",
              dueDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 25, hour: 14, minute: 0)) ?? .now,
              type: taskTypes[0],
              priority: .medium,
              status: .inProgress),

        .init(title: "Review client feedback",
              description: "Go through all comments from last meeting",
              dueDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 23, hour: 10, minute: 0)) ?? .now,
              type: taskTypes[2],
              priority: .high,
              status: .pending),

        .init(title: "Update documentation",
              description: "Add new features to user guide",
              dueDate: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 30, hour: 16, minute: 0)) ?? .now,
              type: taskTypes[3],
              priority: .low,
              status: .pending),
    ]
}
