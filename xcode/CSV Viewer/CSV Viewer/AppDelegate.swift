//
//  AppDelegate.swift
//  CSV Viewer
//
//  Handles application lifecycle events, including unsaved changes
//  confirmation when the user attempts to quit.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var appState: AppState?

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        guard let appState = appState, appState.hasUnsavedChanges else {
            return .terminateNow
        }

        // Show unsaved changes dialog
        let alert = NSAlert()
        alert.messageText = "Do you want to save the changes you made to \"\(appState.currentFileName)\"?"
        alert.informativeText = "Your changes will be lost if you don't save them."
        alert.alertStyle = .warning

        // Add buttons in macOS HIG order: Save (default), Cancel, Don't Save (destructive)
        alert.addButton(withTitle: "Save")        // Default button (right)
        alert.addButton(withTitle: "Cancel")      // Middle button
        alert.addButton(withTitle: "Don't Save")  // Left button (destructive)

        let response = alert.runModal()

        switch response {
        case .alertFirstButtonReturn:  // Save
            appState.saveHandler?()
            // If save succeeded, dirty flag will be cleared and we can terminate
            // If save failed or was cancelled, dirty flag remains and we cancel termination
            return appState.hasUnsavedChanges ? .terminateCancel : .terminateNow

        case .alertSecondButtonReturn:  // Cancel
            return .terminateCancel

        case .alertThirdButtonReturn:  // Don't Save
            appState.markClean()
            return .terminateNow

        default:
            return .terminateCancel
        }
    }
}
