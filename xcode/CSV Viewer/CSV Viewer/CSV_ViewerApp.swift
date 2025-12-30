import SwiftUI

@main
struct CSV_ViewerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        Window("Find", id: "find") {
            FindView()
        }
        .defaultSize(width: 420, height: 260)
        .windowResizability(.contentSize)
        .commands {
            CSVViewerCommands()
        }
    }
}

struct CSVViewerCommands: Commands {
    @FocusedValue(\.csvViewerActions) private var actions

    var body: some Commands {
        CommandGroup(after: .newItem) {
            Button("Open...") { actions?.open() }
                .keyboardShortcut("o", modifiers: [.command])
        }

        CommandGroup(after: .saveItem) {
            Button("Save") { actions?.save() }
                .keyboardShortcut("s", modifiers: [.command])

            Button("Save As...") { actions?.saveAs() }
                .keyboardShortcut("s", modifiers: [.command, .shift])
        }

        CommandGroup(after: .undoRedo) {
            Button("Undo Delete") { actions?.undoDelete() }
                .keyboardShortcut("z", modifiers: [.command])
        }

        CommandGroup(after: .pasteboard) {
            Button("Copy Selection") { actions?.copy() }
                .keyboardShortcut("c", modifiers: [.command])
        }

        CommandMenu("Find") {
            Button("Find...") { actions?.find() }
                .keyboardShortcut("f", modifiers: [.command])
        }

        CommandMenu("View") {
            Button("Decrease Font Size") { actions?.decreaseFont() }
                .keyboardShortcut("-", modifiers: [.command])

            Button("Increase Font Size") { actions?.increaseFont() }
                .keyboardShortcut("=", modifiers: [.command])

            Divider()

            Button("Toggle Line Wrapping") { actions?.toggleWrap() }
                .keyboardShortcut("l", modifiers: [.command])
        }
    }
}
