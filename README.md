# CSV Viewer for macOS

A lightweight, native macOS CSV viewer and editor built with Swift and SwiftUI.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)

## Features

### File Management
- **Open CSV files** with native file picker
- **Open Recent** - Quick access to last 5 opened files with security-scoped bookmarks
- **Save/Save As** - UTF-8 encoding with proper CSV formatting
- **Large file handling** - Preview mode for files over 50MB (configurable)
- **Encoding detection** - Automatically detects file encoding

### CSV Processing
- **RFC 4180 compliant** parser
  - Handles quoted fields with commas
  - Properly escapes quotes (`""` inside fields)
  - Preserves data integrity on save
- **Robust data handling** - No data loss from complex CSV formats

### Grid View
- **Synchronized scrolling** - Headers move with columns horizontally
- **Sticky headers** - Column headers stay visible when scrolling vertically
- **Row numbers** - Fixed left column with row indices
- **Dynamic column sizing** - Auto-calculated widths (60-520px range)
- **Line wrapping toggle** - View long content with word wrap

### Editing
- **Add rows/columns** - Insert above/below or left/right of selection
- **Delete rows/columns** - Multi-select with confirmation dialogs
- **Single-level undo** - Restore deleted rows or columns
- **Selection modes**
  - Row selection (click cell or row number)
  - Column selection (click header)
  - Multi-select with Cmd (toggle) and Shift (range)

### Sorting
- **Column sorting** - Click header arrows to sort
- **Smart sorting** - Numeric vs. alphabetic detection
- **Toggle direction** - Ascending/descending with single click

### User Interface
- **Compact toolbar** - 18 buttons with tooltips
- **Dark/Light mode** - Manual theme toggle
- **Font size control** - Adjustable from 10-22pt
- **Status bar** - Row/column count, encoding, preview indicator
- **Help dialog** - Formatted guide with keyboard shortcuts

### Clipboard
- **Smart copy** - Copies selection, row, column, or entire table
- **CSV formatted** - Properly escaped output ready to paste

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Open | ⌘O |
| Save | ⌘S |
| Save As | ⌘⇧S |
| Undo Delete | ⌘Z |
| Copy Selection | ⌘C |
| Find | ⌘F |
| Toggle Wrap | ⌘L |
| Font Size | ⌘+  /  ⌘− |

## Installation

### From Source

1. Clone the repository:
```bash
git clone https://github.com/323Works/csv-viewer-macos.git
cd csv-viewer-macos
```

2. Open in Xcode:
```bash
open "xcode/CSV Viewer/CSV Viewer.xcodeproj"
```

3. Build and run (⌘R)

### Requirements
- macOS 14.0+ (Sonoma or later)
- Xcode 15.0+
- Swift 5.9+

## Project Structure

```
csv-viewer2/
├── README.md
├── prd-csv.md                    # Product requirements document
├── example.csv                    # Sample data file
└── xcode/
    └── CSV Viewer/
        ├── CSV Viewer.xcodeproj
        └── CSV Viewer/
            ├── CSV_ViewerApp.swift      # App entry point
            ├── ContentView.swift         # Main grid view
            ├── CSVViewerActions.swift    # Action protocol
            ├── HelpView.swift            # Help dialog
            ├── SettingsView.swift        # Settings panel
            └── FindView.swift            # Find placeholder
```

## Configuration

Settings are accessible via the gear icon or ⌘, (when implemented):

- **Preview large files** - Toggle preview mode (default: on)
- **Preview row limit** - Number of rows to load in preview (default: 10,000)
- **Large file threshold** - Size in MB to trigger preview (default: 50MB)

## Known Limitations

- **Find feature** - Currently a placeholder (⌘F)
- **No cell editing** - View and structural edits only
- **No formulas** - Not a spreadsheet replacement
- **Preview mode** - Large files limited to first N rows

## Roadmap

- [ ] Implement Find/Search functionality
- [ ] Add cell-level editing
- [ ] Support for TSV and other delimiters
- [ ] Export to other formats (JSON, XML)
- [ ] Column filtering
- [ ] Advanced sorting options

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see LICENSE file for details

## Credits

Built by [323 Works, LLC](https://www.323works.com)

Powered by Swift, SwiftUI, and Claude Code
