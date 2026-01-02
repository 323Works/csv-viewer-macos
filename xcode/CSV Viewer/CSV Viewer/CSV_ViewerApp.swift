import SwiftUI

@main
struct CSV_ViewerApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var searchState = SearchState()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(searchState)
                .onAppear {
                    // Wire up AppDelegate to AppState after initialization
                    appDelegate.appState = appState
                }
        }
        Window("Find", id: "find") {
            FindView()
                .environmentObject(searchState)
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

            Button("Redo Delete") { actions?.redoDelete() }
                .keyboardShortcut("z", modifiers: [.command, .shift])
        }

        CommandGroup(after: .pasteboard) {
            Button("Copy Selection") { actions?.copy() }
                .keyboardShortcut("c", modifiers: [.command])
        }

        CommandMenu("Find") {
            Button("Find...") { actions?.find() }
                .keyboardShortcut("f", modifiers: [.command])

            Button("Find Next") { actions?.findNext() }
                .keyboardShortcut("g", modifiers: [.command])

            Button("Find Previous") { actions?.findPrevious() }
                .keyboardShortcut("g", modifiers: [.command, .shift])
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
