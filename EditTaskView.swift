import SwiftUI

struct EditTaskView: View {
    @Environment(\.dismiss) private var dismiss

    @State var task: TaskItem

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var dueDate: Date = .now
    @State private var selectedType: TaskType = MockData.taskTypes[2]
    @State private var priority: TaskPriority = .high
    @State private var status: TaskStatus = .inProgress

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Group {
                    Text("Task Title *").font(.footnote).foregroundStyle(.secondary)
                    TextField("Review client feedback", text: $title)
                        .textFieldStyle(.roundedBorder)
                }

                Group {
                    Text("Description").font(.footnote).foregroundStyle(.secondary)
                    TextEditor(text: $description)
                        .frame(height: 120)
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray.opacity(0.25)))
                }

                Group {
                    Text("Due Date & Time *").font(.footnote).foregroundStyle(.secondary)
                    DatePicker("", selection: $dueDate)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray.opacity(0.25)))
                }

                Group {
                    Text("Task Type *").font(.footnote).foregroundStyle(.secondary)
                    Picker("Task Type", selection: $selectedType) {
                        ForEach(MockData.taskTypes, id: \.self) { type in
                            Text(type.name).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray.opacity(0.25)))
                }

                Text("Priority").font(.footnote).foregroundStyle(.secondary)
                HStack(spacing: 10) {
                    ChoicePill(title: "Low", isSelected: priority == .low) { priority = .low }
                    ChoicePill(title: "Medium", isSelected: priority == .medium) { priority = .medium }
                    ChoicePill(title: "High", isSelected: priority == .high, selectedColor: .red) { priority = .high }
                }

                Text("Status").font(.footnote).foregroundStyle(.secondary)
                HStack(spacing: 10) {
                    ChoicePill(title: "Pending", isSelected: status == .pending) { status = .pending }
                    ChoicePill(title: "In Progress", isSelected: status == .inProgress, selectedColor: .purple) { status = .inProgress }
                    ChoicePill(title: "Completed", isSelected: status == .completed) { status = .completed }
                }

                HStack(spacing: 12) {
                    Button(role: .cancel) { dismiss() } label: {
                        Label("Cancel", systemImage: "xmark")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        // Milestone 1: no persistence; just dismiss
                        dismiss()
                    } label: {
                        Label("Save Task", systemImage: "square.and.arrow.down")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top, 6)
            }
            .padding()
        }
        .navigationTitle("Edit Task")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            title = task.title.isEmpty ? "Review client feedback" : task.title
            description = task.description.isEmpty ? "Go through all comments from last meeting" : task.description
            dueDate = task.dueDate
            selectedType = task.type
            priority = task.priority
            status = task.status
        }
    }
}

struct ChoicePill: View {
    let title: String
    let isSelected: Bool
    var selectedColor: Color = .blue
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isSelected ? selectedColor : .gray.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
