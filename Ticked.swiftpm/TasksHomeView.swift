import SwiftUI
import Foundation

struct TasksHomeView: View {
    @State private var tasks: [TaskItem] = TaskStore.loadTasks()
    @State private var selectedStatus: TaskStatus? = nil
    @State private var showAddTask = false

    var body: some View {
        VStack(spacing: 12) {
            header

            HStack(spacing: 10) {
                Button {
                    showAddTask = true
                } label: {
                    Label("Add Task", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Menu {
                    Button("All") { selectedStatus = nil }
                    ForEach(TaskStatus.allCases) { status in
                        Button(status.rawValue) { selectedStatus = status }
                    }
                } label: {
                    Label(selectedStatus?.rawValue ?? "Filter", systemImage: "line.3.horizontal.decrease.circle")
                }
                .buttonStyle(.bordered)

                NavigationLink {
                    ManageTaskTypesView()
                } label: {
                    Image(systemName: "gearshape")
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)

            ScrollView {
                LazyVStack(spacing: 16, pinnedViews: []) {
                    
                    let overdueIndices = tasks.indices.filter { isOverdue(task: tasks[$0]) && shouldShow(task: tasks[$0]) }
                    if !overdueIndices.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Overdue")
                                .font(.headline)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 4)

                            ForEach(overdueIndices, id: \.self) { index in
                                taskRow(for: index)
                            }
                        }
                    }

                    let regularIndices = tasks.indices.filter { !isOverdue(task: tasks[$0]) && shouldShow(task: tasks[$0]) }
                    if !regularIndices.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            if !overdueIndices.isEmpty {
                                Text("Upcoming / Other")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 4)
                                    .padding(.top, 8)
                            }

                            ForEach(regularIndices, id: \.self) { index in
                                taskRow(for: index)
                            }
                        }
                    }

                    if overdueIndices.isEmpty && regularIndices.isEmpty {
                        Text("No tasks found.")
                            .foregroundColor(.secondary)
                            .padding(.top, 40)
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showAddTask) {
            AddTaskView { newTask in
                tasks.insert(newTask, at: 0)
            }
            .presentationDetents([.large])
        }
        .onChange(of: tasks) { newValue in
            TaskStore.saveTasks(newValue)
        }
    }

    // Helper: Checks if due date is passed AND task is not completed
    private func isOverdue(task: TaskItem) -> Bool {
        return task.dueDate < Date() && task.status != .completed
    }

    // Helper: Checks filter status
    private func shouldShow(task: TaskItem) -> Bool {
        guard let selectedStatus else { return true }
        return task.status == selectedStatus
    }

    // Helper: Builds a single task row with navigation and deletion
    @ViewBuilder
    private func taskRow(for index: Int) -> some View {
        // Safety check to prevent index crashes when deleting
        if index < tasks.count {
            NavigationLink {
                EditTaskView(task: $tasks[index])
            } label: {
                TaskCardView(task: tasks[index]) {
                    let idToDelete = tasks[index].id
                    tasks.removeAll { $0.id == idToDelete }
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Tasks").font(.largeTitle).bold()
                Text(formattedToday()).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(timeString()).font(.headline)
                Text("\(tasks.count) task\(tasks.count == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.top, 6)
    }

    private func formattedToday() -> String {
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMMM d"
        return df.string(from: .now)
    }

    private func timeString() -> String {
        let df = DateFormatter()
        df.dateFormat = "h:mm a"
        return df.string(from: .now)
    }
}
