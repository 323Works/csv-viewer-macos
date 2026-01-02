# CSV Viewer - Improvement Plans

## ✅ Completed

- [x] Grid layout (row numbers, horizontal scrolling)
- [x] Header synchronization with data scrolling
- [x] Column header truncation fixes
- [x] Help dialog formatting improvements
- [x] RFC 4180 compliant CSV parsing
- [x] Open Recent with security-scoped bookmarks
- [x] Sort arrows stacked vertically
- [x] UI polish (filename accent color, info icon position)
- [x] **#9: Replace magic numbers with named constants**
- [x] **#4: Implement 3-level undo/redo stack** (with redo support)
- [x] **#2: Add error alerts for file operations**
- [x] **#7: Refactor ContentView** (extracted CSV parsing logic)
- [x] **#8: Add unit tests for core logic** (CSVParser tests created)
- [x] **#3: Cell editing** (double-click, Enter to commit, click-outside to commit)
- [x] **#3: Cell editing keyboard navigation** (Tab/Escape + shift-tab)
- [x] **Unsaved changes warning** (macOS-style dialog on quit with Save/Don't Save/Cancel)
- [x] **Auto-extend headers on load** (prevent truncation when rows have extra columns)
- [x] **Integrate CSVParserTests into Xcode test target**
- [x] **#1: Find/Search feature** (substring, case-insensitive, column-scoped if selected)

## 🚧 In Progress

- None currently

## 📋 Backlog

### High Priority

### Medium Priority

- [ ] **#6: Export formats**
  - TSV (tab-separated values)
  - JSON export
  - XML export
  - Excel-compatible format

### Nice to Have

- [ ] **#5: Multi-line CSV field handling** (low frequency, defer unless needed)
  - Parser already supports newlines in quoted fields
  - Need to test and fix display issues
  - Ensure proper rendering in grid

- [ ] **#10: Column filtering**
  - Filter rows by column criteria
  - Multiple filter conditions
  - Clear filters button

- [ ] **#11: Advanced sorting**
  - Multi-column sort (primary, secondary)
  - Custom sort order
  - Case-sensitive option

- [ ] **#12: Custom delimiters**
  - Support TSV (tabs)
  - Pipe-delimited (|)
  - Semicolon-delimited (;)
  - Auto-detect delimiter

- [ ] **#13: Keyboard navigation**
  - Arrow keys to move between cells
  - Home/End for row start/end
  - Page Up/Down for scrolling
  - ⌘↑/↓ for column start/end

- [ ] **#14: Column reordering**
  - Drag column headers to reorder
  - Visual feedback during drag
  - Preserve data alignment

### Performance

- [ ] Optimize large file handling
  - Virtual scrolling for 100k+ rows
  - Lazy column width calculation
  - Memory profiling
- [ ] Streamed CSV loading for preview (avoid full-file read)

### Code Quality

- [ ] Add comprehensive error handling
- [ ] Improve code documentation
- [ ] Add logging framework
- [ ] Performance benchmarking

## 🔍 Technical Debt

### Architecture
- [ ] Separate data model from view
- [ ] Create CSVDocument model class
- [ ] Extract grid view components
- [ ] Implement proper MVVM pattern

### Testing
- [ ] Sorting logic tests
- [ ] Selection behavior tests
- [ ] File I/O integration tests
- [ ] UI automation tests

### Documentation
- [ ] Inline code documentation
- [ ] Architecture decision records
- [ ] Contributing guidelines
- [ ] User documentation/guide

## 📝 Notes

### Current Focus
Foundational improvements complete (#9, #4, #2, #7, #8, #3, unsaved changes). Ready for new features.

### Next Sprint
Prioritize Find feature (#1) as it provides the most user value. Consider Tab/Escape navigation (#3 remaining) for improved editing UX.

### Long-term Vision
Transform into a full-featured lightweight CSV editor that can replace Excel for basic CSV tasks while maintaining speed and simplicity.
