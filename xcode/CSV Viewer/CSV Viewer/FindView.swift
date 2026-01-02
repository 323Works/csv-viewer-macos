import SwiftUI

struct FindView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var searchState: SearchState
    @FocusState private var searchFieldFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Find")
                .font(.title2)
                .fontWeight(.semibold)

            TextField("Search", text: $searchState.query)
                .textFieldStyle(.roundedBorder)
                .focused($searchFieldFocused)

            HStack {
                Text(matchStatus)
                    .foregroundColor(.secondary)
                Spacer()
                Button("Previous") {
                    searchState.advance(forward: false)
                }
                .disabled(searchState.matches.isEmpty)
                Button("Next") {
                    searchState.advance(forward: true)
                }
                .disabled(searchState.matches.isEmpty)
            }

            if searchState.isColumnScoped {
                Text("Searching selected columns")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }

            Spacer()

            HStack {
                Spacer()
                Button("Done") {
                    dismiss()
                }
            }
        }
        .padding(20)
        .frame(minWidth: 360, minHeight: 200)
        .onAppear {
            searchFieldFocused = true
        }
    }

    private var matchStatus: String {
        let total = searchState.matches.count
        guard total > 0 else { return "0 of 0" }
        return "\(searchState.currentIndex + 1) of \(total)"
    }
}
