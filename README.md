# CSV Viewer for macOS

A lightweight, native macOS CSV viewer/editor built with Swift and SwiftUI.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)

## Features

### File Management
- Open CSV files with the native file picker
- Drag and drop a CSV from Finder onto the empty-state canvas to open it
- Click the centered empty-state drop zone to trigger the native file picker
- Open Recent list (last 5 files) with security-scoped bookmarks
- Save and Save As with UTF-8 output
- Large file prompt with `Load Preview` or `Load All` options
- File encoding detection and status display
- Unsaved changes warning on app quit (Save / Don't Save / Cancel)

### CSV Processing
- RFC 4180-compliant parsing and formatting via `CSVParser`
- Correct handling of quoted fields, commas, escaped quotes, and embedded newlines
- Auto-extends headers when row width exceeds header width

### Grid and Selection
- Sticky header row with horizontal/vertical scrolling
- Row number column and multi-selection support
- Row selection and column selection modes (mutually exclusive)
- Cmd-click toggle and Shift-click range selection
- Dynamic column widths based on content (clamped to 60-520 px)
- Optional line wrapping

### Editing
- Double-click to edit header cells and data cells
- Enter to commit edits, Tab/Shift-Tab navigation, Escape to cancel
- Add row/column around current selection
- Delete selected rows/columns with confirmation dialogs
- 3-level undo/redo stack for delete operations

### Find/Search
- Dedicated Find window (`⌘F`)
- Case-insensitive, diacritic-insensitive substring matching
- `⌘G` / `⌘⇧G` navigation between matches
- Search can scope to selected columns
- In-grid match highlighting and auto-scroll to current match

### Filtering and Navigation
- Quick row filter above the grid narrows visible rows across all columns
- Matching filter phrases are highlighted in visible cells
- Filtered copy uses visible rows when no explicit row selection is active
- Arrow-key navigation across visible cells
- Enter edits the active cell
- Tab / Shift-Tab move horizontally outside edit mode
- Home / End jump to first or last column in the active row
- Page Up / Page Down move by larger row increments

### Sorting and Clipboard
- Click header sort controls to sort ascending/descending
- Numeric-aware sort (falls back to case-insensitive string compare)
- Copy behavior:
  - Selected rows across all columns
  - Selected columns across all rows
  - Entire table when nothing is selected
- Clipboard output is valid CSV

### User Interface
- Compact toolbar with file/edit/view/help controls
- Window title includes the app build version (example: `CSV Viewer v2026.06.16-003`)
- Manual light/dark toggle
- Font size controls (10-22 pt)
- Status bar with rows, columns, encoding, and preview indicator
- Settings and Help sheets

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Open | `⌘O` |
| Save | `⌘S` |
| Save As | `⌘⇧S` |
| Undo Delete | `⌘Z` |
| Redo Delete | `⌘⇧Z` |
| Copy Selection | `⌘C` |
| Find | `⌘F` |
| Find Next | `⌘G` |
| Find Previous | `⌘⇧G` |
| Navigate Cells | Arrow keys |
| Edit Active Cell | `Enter` |
| Move Active Cell | `Tab` / `Shift-Tab` |
| Row Start/End | `Home` / `End` |
| Page Rows | `Page Up` / `Page Down` |
| Toggle Wrap | `⌘L` |
| Decrease Font | `⌘-` |
| Increase Font | `⌘=` |

## Requirements
- macOS 14.0+ (Sonoma or later)
- Xcode 15.0+
- Swift 5.9+

## Build and Test

```bash
# Build
xcodebuild -project "xcode/CSV Viewer/CSV Viewer.xcodeproj" -scheme "CSV Viewer" -configuration Debug build

# Test
xcodebuild test -project "xcode/CSV Viewer/CSV Viewer.xcodeproj" -scheme "CSV Viewer" -destination 'platform=macOS'
```

For a consistent double-clickable app bundle in the repo, run:

```bash
./scripts/build-app.sh
```

That publishes the latest debug build to `artifacts/CSV Viewer.app`.

## Personal Default App Workflow

CSV Viewer is intended to be a fast personal CSV viewer/editor for ordinary CSV inspection and small edits without opening Excel.

To refresh the runnable app:

```bash
./scripts/build-app.sh
```

Then use:

```text
artifacts/CSV Viewer.app
```

To make it the default app for `.csv` files on macOS:

1. In Finder, select any `.csv` file.
2. Press `⌘I` for Get Info.
3. In `Open with`, choose `CSV Viewer.app`.
4. Click `Change All...`.

The app bundle declares CSV documents and is signed for local use with user-selected file read/write access.

If `xcodebuild` fails before compiling with Xcode plugin or `IDESimulatorFoundation` load errors, repair the local Xcode install state first:

```bash
xcodebuild -runFirstLaunch
```

## Project Structure

```text
csv-viewer/
├── README.md
├── prd-csv.md
├── plans.md
├── example.csv
└── xcode/
    └── CSV Viewer/
        ├── CSV Viewer.xcodeproj
        ├── Info.plist                   # Bundle metadata + CSV document declaration
        ├── CSV Viewer/
        │   ├── CSV_ViewerApp.swift      # App entry + command wiring
        │   ├── ContentView.swift         # Main UI + app behavior
        │   ├── CSVParser.swift           # RFC 4180 parse/format utility
        │   ├── SearchState.swift         # Find state and navigation
        │   ├── AppState.swift            # Unsaved-changes shared state
        │   ├── AppDelegate.swift         # Quit flow / save confirmation
        │   ├── EditingTextField.swift    # NSTextField bridge for editing UX
        │   ├── FindView.swift
        │   ├── SettingsView.swift
        │   └── HelpView.swift
        └── CSV ViewerTests/
            └── CSVParserTests.swift
```

## Settings

Configured in the Settings sheet:
- Preview large files (`on` by default)
- Preview row limit (`10,000` by default)
- Large file threshold in MB (`50` by default)

## Known Limitations

- Undo/redo currently applies to row/column delete actions only
- CSV is the only export/save format (no TSV/JSON/XML export yet)
- No multi-column sorting yet
- Core behavior is still concentrated in `ContentView.swift` (not yet split into a fuller model/view-model architecture)

## Roadmap

- Export formats (TSV, JSON, XML)
- Column filtering
- Advanced sorting (multi-column and options)
- Custom delimiters (tabs, pipe, semicolon)
- Performance upgrades for very large files (streamed preview, virtualization)
- Architecture split of `ContentView` into smaller components/model layers

## Contributing

Contributions are welcome. Open an issue or submit a pull request.

## License

MIT License (see `LICENSE`).

## Credits

Built by [323 Works, LLC](https://www.323works.com)
