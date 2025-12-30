import SwiftUI

struct SettingsView: View {
    @Binding var previewRowLimit: Int
    @Binding var largeFileMB: Int
    @Binding var previewLargeFiles: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.title2)
                .fontWeight(.semibold)

            Toggle("Preview large files", isOn: $previewLargeFiles)

            HStack {
                Text("Preview rows")
                Spacer()
                Stepper(value: $previewRowLimit, in: 1000...100000, step: 1000) {
                    Text("\(previewRowLimit)")
                        .frame(minWidth: 70, alignment: .trailing)
                }
            }

            HStack {
                Text("Large file threshold (MB)")
                Spacer()
                Stepper(value: $largeFileMB, in: 10...500, step: 10) {
                    Text("\(largeFileMB)")
                        .frame(minWidth: 70, alignment: .trailing)
                }
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
        .frame(minWidth: 420, minHeight: 260)
    }
}
