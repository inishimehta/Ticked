import SwiftUI
import Foundation

struct TasksHomeView: View {
    @State private var tasks: [TaskItem] = TaskStore.loadTasks()
    @State private var selectedStatus: TaskStatus? = nil
    @State private var showAddTask = false
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                header

                HStack(spacing: 12) {
                    Button {
                        showAddTask = true
                    } label: {
                        Label("Add Task", systemImage: "plus")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .foregroundColor(.white)
                            .background(Color.cyan, in: Capsule())
                    }

                    Menu {
                        Button("All") { selectedStatus = nil }
                        ForEach(TaskStatus.allCases) { status in
                            Button(status.rawValue) { selectedStatus = status }
                        }
                    } label: {
                        Label(selectedStatus?.rawValue ?? "Filter", systemImage: "line.3.horizontal.decrease.circle")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .foregroundColor(.cyan)
                            .background(Color.gray.opacity(0.15), in: Capsule())
                    }

                    NavigationLink {
                        ManageTaskTypesView()
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20, weight: .medium))
                            .frame(width: 44, height: 44)
                            .foregroundColor(.cyan)
                            .background(Color.gray.opacity(0.15), in: Circle())
                    }
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

                        let upcomingIndices = tasks.indices.filter { !isOverdue(task: tasks[$0]) && tasks[$0].status != .completed && shouldShow(task: tasks[$0]) }
                        if !upcomingIndices.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                if !overdueIndices.isEmpty {
                                    Text("Upcoming")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 4)
                                        .padding(.top, 8)
                                }

                                ForEach(upcomingIndices, id: \.self) { index in
                                    taskRow(for: index)
                                }
                            }
                        }
                        
                        let completedIndices = tasks.indices.filter { tasks[$0].status == .completed && shouldShow(task: tasks[$0]) }
                        if !completedIndices.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                if !overdueIndices.isEmpty || !upcomingIndices.isEmpty {
                                    Text("Completed")
                                        .font(.headline)
                                        .foregroundColor(.green)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 4)
                                        .padding(.top, 8)
                                }

                                ForEach(completedIndices, id: \.self) { index in
                                    taskRow(for: index)
                                }
                            }
                        }

                        if overdueIndices.isEmpty && upcomingIndices.isEmpty && completedIndices.isEmpty {
                            Text(searchText.isEmpty ? "No tasks found." : "No search results.")
                                .foregroundColor(.secondary)
                                .padding(.top, 40)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .searchable(text: $searchText, prompt: "Search tasks...")
        }
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

    private func isOverdue(task: TaskItem) -> Bool {
        return task.dueDate < Date() && task.status != .completed
    }

    private func shouldShow(task: TaskItem) -> Bool {
        let matchesStatus = (selectedStatus == nil) || (task.status == selectedStatus)
        
        let matchesSearch: Bool
        if searchText.isEmpty {
            matchesSearch = true
        } else {
            let lowercasedSearch = searchText.lowercased()
            matchesSearch = task.title.lowercased().contains(lowercasedSearch) ||
                            task.description.lowercased().contains(lowercasedSearch)
        }
        
        return matchesStatus && matchesSearch
    }

    @ViewBuilder
    private func taskRow(for index: Int) -> some View {
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
