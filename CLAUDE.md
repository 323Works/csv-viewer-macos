# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**CSV Viewer** is a lightweight, native macOS CSV viewer and editor built with Swift and SwiftUI. The app provides Excel-like functionality for viewing, editing, and managing CSV files with RFC 4180 compliance.

**Requirements:**
- macOS 14.0+ (Sonoma or later)
- Xcode 15.0+
- Swift 5.9+

## Build and Development Commands

### Open Project
```bash
open "xcode/CSV Viewer/CSV Viewer.xcodeproj"
```

### Build from Command Line
```bash
cd "xcode/CSV Viewer"
xcodebuild -scheme "CSV Viewer" -configuration Debug build
```

### Run Tests
```bash
cd "xcode/CSV Viewer"
xcodebuild test -scheme "CSV Viewer" -destination 'platform=macOS'
```

Note: Test target needs to be added to the Xcode project. CSVParserTests.swift exists in `CSV ViewerTests/` directory but isn't integrated yet.

## Architecture

### Core Components

**ContentView.swift** (~1200 lines)
- The monolithic main view containing all app logic
- Manages state for: data model, selection, editing, undo/redo, UI preferences
- Contains grid rendering logic with LazyVStack and pinned headers
- Uses `@State` for local state, `@AppStorage` for persistent settings
- Known issue: Complex view hierarchy can cause Swift type-checker timeouts when adding new modifiers

**CSVParser.swift**
- RFC 4180 compliant CSV parser (standalone utility)
- Static methods: `parseLine()`, `formatLine()`
- Handles quoted fields, escaped quotes, commas within fields, newlines in quoted fields
- Used by ContentView for all CSV I/O operations

**CSV_ViewerApp.swift**
- App entry point with WindowGroup
- Defines menu commands via `CSVViewerCommands`
- Uses FocusedValue system to connect menu items to ContentView actions

**CSVViewerActions.swift**
- Protocol defining callable actions (open, save, undo, copy, etc.)
- Used by focused value system to wire menu commands to ContentView

### Data Model

Simple in-memory arrays (no document model yet):
```swift
@State private var columns: [String] = []        // Header row
@State private var rows: [[String]] = []         // Data rows
```

**Important:** Rows are padded/trimmed to match column count on load.

### Selection System

Mutually exclusive selection modes:
- Row selection: `selectedRows: Set<Int>`, tracks by row index
- Column selection: `selectedColumns: Set<Int>`, tracks by column index
- Single tap selects, Cmd toggles, Shift selects range
- Selecting rows clears column selection and vice versa

### Cell Editing (Recently Implemented)

State managed via enum:
```swift
enum EditingCell: Equatable {
    case none
    case header(column: Int)
    case dataCell(row: Int, column: Int)
}
```

**Behavior:**
- Double-click cell to edit (TextField replaces Text)
- Enter commits (data cells also move down)
- Click anywhere commits and exits edit mode
- File operations, sorts, deletes auto-commit
- Column widths recalculate after each edit

**Known limitation:** Tab/Escape navigation not implemented (`.onKeyPress` causes type-checker timeout).

### Undo/Redo System

3-level stack for delete operations only (cell edits not included):
```swift
@State private var undoStack: [UndoAction] = []
@State private var redoStack: [UndoAction] = []
```

Stores deleted columns/rows with index and data for restoration.

### Constants Pattern

All magic numbers live in `Constants` enum in ContentView:
```swift
private enum Constants {
    static let rowNumberWidth: CGFloat = 52
    static let minColumnWidth: CGFloat = 60
    static let maxUndoLevels = 3
    // ... etc
}
```

### Grid Rendering Strategy

Uses SwiftUI `LazyVStack` with `pinnedViews: [.sectionHeaders]`:
- Single ScrollView with horizontal + vertical scrolling
- Headers naturally stay pinned on vertical scroll and move on horizontal scroll
- Row numbers in separate HStack (not pinned, scroll with rows)
- Column widths calculated via `computeColumnWidths()` based on content + font size

**Performance note:** LazyVStack only renders visible rows, handles large files well with preview mode.

## Key Design Patterns

### Security-Scoped Bookmarks
Recent files use security-scoped bookmarks for persistent access:
```swift
url.startAccessingSecurityScopedResource()
defer { url.stopAccessingSecurityScopedResource() }
```

### Preview Mode for Large Files
Files >= 50MB trigger prompt:
- Load Preview (first 10,000 rows)
- Load All
- Cancel

Configurable via settings (gear icon).

### Error Handling
File operations show native alerts with error details:
```swift
@State private var showErrorAlert = false
@State private var errorTitle = ""
@State private var errorMessage = ""
```

## Common Modifications

### Adding New Toolbar Buttons
1. Add button to `toolbarView` in ContentView
2. Add action function to ContentView
3. Add to `CSVViewerActions` protocol if menu item needed
4. Wire up in `viewerActions` computed property
5. Add menu command in `CSV_ViewerApp.swift` if needed

### Adding State Variables
Group with related state, use comments to organize:
```swift
// Cell editing state
@State private var editingCell: EditingCell = .none
```

### Avoiding Type-Checker Timeouts
Extract complex view logic into separate `@ViewBuilder` functions:
```swift
@ViewBuilder
private func headerCellText(for index: Int) -> some View {
    // Complex conditional logic here
}
```

## Testing Notes

**CSV ViewerTests/** directory exists with:
- `CSVParserTests.swift` - 30+ test cases for RFC 4180 compliance

Tests need to be added to Xcode project target to run.

## Current Status (see plans.md for details)

**Recently Completed:**
- Cell editing (double-click, Enter to commit)
- 3-level undo/redo with keyboard shortcuts
- Error alerts for file operations
- CSV parser extraction and unit tests
- Constants enum for magic numbers

**Next Priorities:**
- Find/Search feature (#1)
- Tab/Escape keyboard navigation for editing (#3 remaining)
- Multi-line field handling (#5)

**Known Technical Debt:**
- ContentView is monolithic (~1200 lines) - needs MVVM refactoring
- No document model - data lives in view state
- Test target not integrated into Xcode project
- Some view functions may need extraction to prevent type-checker timeouts
