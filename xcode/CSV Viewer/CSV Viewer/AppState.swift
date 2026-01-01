//
//  AppState.swift
//  CSV Viewer
//
//  Shared application state for tracking document changes and coordinating
//  between the UI and AppDelegate.
//

import SwiftUI
import Combine

/// Shared application state accessible to both the UI and AppDelegate
class AppState: ObservableObject {
    /// Tracks whether the current CSV has unsaved changes
    @Published var hasUnsavedChanges: Bool = false

    /// Reference to the ContentView's save function (set by ContentView)
    var saveHandler: (() -> Void)?

    /// Current file name for display in unsaved changes dialog
    var currentFileName: String = "Untitled"

    /// Marks the document as having unsaved changes
    func markDirty() {
        hasUnsavedChanges = true
    }

    /// Marks the document as clean (no unsaved changes)
    func markClean() {
        hasUnsavedChanges = false
    }
}
