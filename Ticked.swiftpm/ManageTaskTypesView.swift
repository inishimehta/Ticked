import SwiftUI

struct ManageTaskTypesView: View {
    @State private var newTypeName: String = ""
    @State private var taskTypes: [TaskType] = MockData.taskTypes

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add New Task Type")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            HStack(spacing: 10) {
                TextField("e.g., Marketing, Research", text: $newTypeName)
                    .textFieldStyle(.roundedBorder)

                Button {
                    let trimmed = newTypeName.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    taskTypes.insert(.init(name: trimmed), at: 0)
                    newTypeName = ""
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)

            Text("Existing Task Types (\(taskTypes.count))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            List {
                ForEach(taskTypes) { type in
                    HStack(spacing: 12) {
                        Image(systemName: "tag")
                            .foregroundStyle(.blue)
                            .frame(width: 32, height: 32)
                            .background(.blue.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
                        Text(type.name)
                        Spacer()
                        Button(role: .destructive) {
                            taskTypes.removeAll { $0.id == type.id }
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .listStyle(.insetGrouped)

            Text("Task types help you organize and categorize your tasks")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 10)
        }
        .navigationTitle("Manage Task Types")
        .navigationBarTitleDisplayMode(.inline)
    }
}
