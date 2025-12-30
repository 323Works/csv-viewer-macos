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

## 🚧 In Progress

- None currently

## 📋 Backlog

### High Priority

- [ ] **#1: Find/Search feature**
  - Search within cells
  - Highlight matches
  - Navigate between results (⌘G / ⌘⇧G)

- [ ] **#3: Cell editing**
  - Double-click to edit cell values
  - Tab to move between cells
  - Enter to commit changes
  - Escape to cancel

### Medium Priority

- [ ] **#5: Multi-line CSV field handling**
  - Parser already supports newlines in quoted fields
  - Need to test and fix display issues
  - Ensure proper rendering in grid

- [ ] **#6: Export formats**
  - TSV (tab-separated values)
  - JSON export
  - XML export
  - Excel-compatible format

### Nice to Have

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
- [ ] CSV parser unit tests
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
Working on foundational improvements (#9, #4, #2, #7, #8) to establish a solid codebase before adding new features.

### Next Sprint
After current work is complete, prioritize Find feature (#1) and Cell editing (#3) as they provide the most user value.

### Long-term Vision
Transform into a full-featured lightweight CSV editor that can replace Excel for basic CSV tasks while maintaining speed and simplicity.
