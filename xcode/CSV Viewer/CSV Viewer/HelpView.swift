import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("CSV Viewer Help")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Selection")
                        .font(.headline)
                        .fontWeight(.bold)
                    bulletPoint("Click a column header to select columns")
                    bulletPoint("Click any cell or row number to select rows")
                    bulletPoint("⌘ toggles selection, ⇧ selects a range")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Editing")
                        .font(.headline)
                        .fontWeight(.bold)
                    bulletPoint("Use arrow buttons to add rows or columns")
                    bulletPoint("Use trash buttons to delete (with undo)")
                    bulletPoint("Save writes UTF-8 by default")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Viewing")
                        .font(.headline)
                        .fontWeight(.bold)
                    bulletPoint("Sort using up/down arrows in column headers")
                    bulletPoint("Adjust font size and line wrapping from toolbar")
                    bulletPoint("Large files prompt for preview or full load")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Keyboard Shortcuts")
                        .font(.headline)
                        .fontWeight(.bold)
                    shortcutRow("Open", "⌘O")
                    shortcutRow("Save", "⌘S")
                    shortcutRow("Save As", "⌘⇧S")
                    shortcutRow("Undo Delete", "⌘Z")
                    shortcutRow("Copy Selection", "⌘C")
                    shortcutRow("Find", "⌘F")
                    shortcutRow("Find Next", "⌘G")
                    shortcutRow("Find Previous", "⌘⇧G")
                    shortcutRow("Toggle Wrap", "⌘L")
                    shortcutRow("Font Size", "⌘+  /  ⌘−")
                }

                Spacer()

                HStack {
                    Spacer()
                    Button("Done") {
                        dismiss()
                    }
                    .keyboardShortcut(.defaultAction)
                }
                .padding(.top, 8)
            }
            .padding(24)
        }
        .frame(minWidth: 480, minHeight: 400)
    }

    private func bulletPoint(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .fontWeight(.bold)
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }

    private func shortcutRow(_ action: String, _ keys: String) -> some View {
        HStack {
            Text(action)
            Spacer()
            Text(keys)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }
}
