import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var dueDate: Date = .now
    @State private var selectedType: TaskType = MockData.taskTypes.first ?? .init(name: "General")
    @State private var priority: TaskPriority = .low
    @State private var status: TaskStatus = .pending

    let onSave: (TaskItem) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Task Title *").font(.footnote).foregroundStyle(.secondary)
                    TextField("e.g., Review client feedback", text: $title)
                        .textFieldStyle(.roundedBorder)

                    Text("Description").font(.footnote).foregroundStyle(.secondary)
                    TextEditor(text: $description)
                        .frame(height: 120)
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray.opacity(0.25)))

                    Text("Due Date & Time *").font(.footnote).foregroundStyle(.secondary)
                    DatePicker("", selection: $dueDate)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray.opacity(0.25)))

                    Text("Task Type *").font(.footnote).foregroundStyle(.secondary)
                    Picker("Task Type", selection: $selectedType) {
                        ForEach(MockData.taskTypes, id: \.self) { type in
                            Text(type.name).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray.opacity(0.25)))

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
                }
                .padding()
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let defaultType = MockData.taskTypes.first ?? .init(name: "General")
                        let newTask = TaskItem(
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            description: description,
                            dueDate: dueDate,
                            type: selectedType,
                            priority: priority,
                            status: status
                        )
                        // Basic validation for milestone
                        guard !newTask.title.isEmpty else { return }
                        onSave(newTask)
                        dismiss()
                    }
                }
            }
        }
    }
}
