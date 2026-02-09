import SwiftUI

struct FilterSheetView: View {
    @Binding var selectedStatus: TaskStatus?

    var body: some View {
        NavigationStack {
            List {
                Button("All") { selectedStatus = nil }
                ForEach(TaskStatus.allCases) { status in
                    Button(status.rawValue) { selectedStatus = status }
                }
            }
            .navigationTitle("Filter")
        }
    }
}
