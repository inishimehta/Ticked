import SwiftUI

struct TasksHomeView: View {
    @State private var tasks: [TaskItem] = MockData.tasks
    @State private var selectedStatus: TaskStatus? = nil
    @State private var showFilter = false
    @State private var showAddTask = false   // ✅ added

    var filteredTasks: [TaskItem] {
        guard let selectedStatus else { return tasks }
        return tasks.filter { $0.status == selectedStatus }
    }

    var body: some View {
        VStack(spacing: 12) {
            header

            HStack(spacing: 10) {
                Button {
                    showAddTask = true   // ✅ changed
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
                    ForEach(filteredTasks) { task in
                        NavigationLink {
                            EditTaskView(task: task)
                        } label: {
                            TaskCardView(task: task)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)

        // existing filter sheet
        .sheet(isPresented: $showFilter) {
            FilterSheetView(selectedStatus: $selectedStatus)
                .presentationDetents([.medium])
        }

        // ✅ added add-task sheet
        .sheet(isPresented: $showAddTask) {
            AddTaskView { newTask in
                tasks.insert(newTask, at: 0)
            }
            .presentationDetents([.large])
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
