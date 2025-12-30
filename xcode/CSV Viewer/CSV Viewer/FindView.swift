import SwiftUI

struct FindView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Find")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Search is coming soon.")
                .foregroundColor(.secondary)

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
    }
}
