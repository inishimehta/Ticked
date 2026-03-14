import SwiftUI
import Foundation

struct TasksHomeView: View {
    @State private var tasks: [TaskItem] = TaskStore.loadTasks()
    @State private var selectedStatus: TaskStatus? = nil
    @State private var showFilter = false
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

                Button {
                    showFilter = true
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
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
                LazyVStack(spacing: 12) {
                    ForEach(tasks.indices, id: \.self) { index in
                        if shouldShow(task: tasks[index]) {
                            NavigationLink {
                                EditTaskView(task: $tasks[index])
                            } label: {
                                TaskCardView(task: tasks[index])
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showFilter) {
            FilterSheetView(selectedStatus: $selectedStatus)
                .presentationDetents([.medium])
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

    private func shouldShow(task: TaskItem) -> Bool {
        guard let selectedStatus else { return true }
        return task.status == selectedStatus
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
