import SwiftUI

struct TaskCardView: View {
    let task: TaskItem
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(task.title.isEmpty ? "New task" : task.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "flag.fill")
                    .foregroundStyle(colorForPriority(task.priority))
            }

            Text(task.description.isEmpty ? "Add a description…" : task.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            HStack(spacing: 10) {
                Label(dateString(task.dueDate), systemImage: "calendar")
                    .font(.caption)
                    // Make text red if overdue
                    .foregroundStyle(isOverdue ? .red : .secondary)

                Label(timeString(task.dueDate), systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(isOverdue ? .red : .secondary)

                Spacer()

                Chip(text: task.type.name, tint: .blue.opacity(0.15), textColor: .blue)
                Chip(text: task.status.rawValue, tint: .green.opacity(0.15), textColor: .green)
                
                Image(systemName: "trash")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color.red.opacity(0.1), in: Circle())
                    // onTapGesture ensures it triggers deletion without activating the NavigationLink
                    .onTapGesture {
                        onDelete()
                    }
            }
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                // Red border if overdue
                .stroke(isOverdue ? Color.red.opacity(0.6) : .gray.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 4)
    }

    private var isOverdue: Bool {
        task.dueDate < Date() && task.status != .completed
    }

    private func dateString(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "MMM d"
        return df.string(from: date)
    }

    private func timeString(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "h:mm a"
        return df.string(from: date)
    }

    private func colorForPriority(_ p: TaskPriority) -> Color {
        switch p {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

struct Chip: View {
    let text: String
    let tint: Color
    let textColor: Color

    var body: some View {
        Text(text)
            .font(.caption2.weight(.bold))
            .foregroundStyle(textColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(tint, in: Capsule())
    }
}
