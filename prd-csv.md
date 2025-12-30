spec-csv.prd

Overview
- Purpose: Lightweight macOS CSV viewer/editor for quick inspection and simple edits.
- Platform: macOS native app, Swift + SwiftUI.
- Primary use: Open a CSV, view as a grid, add/delete rows/columns, sort, copy selections, save.

Goals
- Open CSV files quickly with minimal friction.
- Provide a readable, scrollable grid with stable headers and row numbers.
- Allow basic structural edits (add/remove rows/columns).
- Allow saving back to disk (UTF-8).
- Keep UI compact and toolbar-driven.

Non-Goals
- Full CSV compliance (quoted fields, escaped commas).
- Rich cell editing or spreadsheet formulas.
- Very large file performance beyond preview mode.

Core Features
1) File Open
- Open via file dialog.
- Open Recent list (up to 5).
- Show current filename under toolbar.
- Detect encoding on open (display in status bar).
- Large file warning if file size >= threshold (default 50 MB).
  - Prompt: Load Preview / Load All / Cancel.
  - Preview loads first N rows (default 10,000).

2) Grid View
- Columns from header row.
- Rows from subsequent lines.
- Scrollable vertically and horizontally.
- Sticky column header row.
- Frozen left column with row numbers.
- Column widths:
  - Calculated per column based on widest header/cell.
  - Minimum width ~60.
  - Maximum width ~520.
  - Account for sort button space in header.

3) Selection
- Row selection:
  - Click cell or row number selects row.
  - Cmd toggles row selection.
  - Shift selects range.
- Column selection:
  - Click header selects column.
  - Cmd toggles column selection.
  - Shift selects range.
- Never allow simultaneous row + column selection.
- Selected rows/columns show reverse highlight.

4) Sorting
- Header has up/down sort icons.
- Clicking sorts by column.
- Numeric sort if possible; otherwise case-insensitive string.
- Active sort icon highlighted.

5) Editing
- Add column left/right of selection.
- Add row above/below selection.
- Delete selected columns (multi-select supported).
- Delete selected rows (multi-select supported).
- Delete requires confirmation dialog:
  - Delete Column {Name}
  - Delete Row {n}
- Undo last delete (row or column), single-level stack is acceptable.

6) Save
- Save icon:
  - If file opened: show Save alert with Overwrite / Save As / Cancel.
  - If no file opened: Save As dialog.
- Save As always available.
- All saves write UTF-8.

7) Copy
- Copy selection to clipboard as CSV.
- Behavior:
  - If row selection: copy selected rows across all columns.
  - If column selection: copy all rows for selected columns.
  - If nothing selected: copy entire table.
  - Include header row in copy.

8) Settings
- Simple modal sheet.
- Settings:
  - Preview large files (toggle).
  - Preview row limit (default 10,000).
  - Large file size threshold (MB, default 50).

9) Help
- Modal with short sections and shortcuts list.

10) Status Bar
- Row count, column count, encoding label.
- Preview indicator if in preview mode.
- Info icon with tooltip:
  - Powered by 323 Works, LLC
  - https://www.323works.com
- Info icon opens URL.

UI Layout Spec
Window
- Minimum size: 700x420.
- Title: CSV Viewer.

Toolbar Row (Top)
- Left-to-right icon buttons:
  1. Open (folder)
  2. Open Recent (clock menu)
  3. Save (download icon)
  4. Undo (arrow.uturn.left)
  5. Copy (doc.on.doc)
  6. Find (magnifyingglass, disabled placeholder)
  7. Font size smaller (textformat.size.smaller)
  8. Font size larger (textformat.size.larger)
  9. Wrap toggle (text.justify / text.justify.left)
  10. Add column left (arrow.left.to.line)
  11. Add column right (arrow.right.to.line)
  12. Add row above (arrow.up.to.line)
  13. Add row below (arrow.down.to.line)
  14. Delete column (trash)
  15. Delete row (trash.slash)
  16. Dark/Light toggle (moon/sun)
  17. Settings (gear)
  18. Help (questionmark.circle)
- Use dividers between groups.
- Tooltips on all icons.

Filename Row
- Appears directly below toolbar.
- Left aligned.
- Slightly larger, semi-bold, secondary color.

Grid
- Header row sticky.
- Row numbers sticky on left.
- Horizontal and vertical scroll.
- Grid cell borders visible.
- Selected rows/columns reverse highlight.
- Line wrapping toggled by toolbar.

Status Bar
- Always visible bottom row.
- Left: rows, columns, encoding, preview.
- Right: info icon.

Behavior Details
- Encoding detection: String(contentsOf:usedEncoding:).
- CSV parsing: naive split by comma.
- Column widths measured from header and cells; recompute on load and font size change.
- Preview mode: trigger by file size; display preview indicator.

Keyboard Shortcuts
- Cmd+O: Open
- Cmd+S: Save
- Cmd+Shift+S: Save As
- Cmd+Z: Undo delete
- Cmd+C: Copy
- Cmd+F: Find (placeholder)
- Cmd+L: Toggle wrap
- Cmd+- / Cmd+=: Font size down/up

Menu Bar Commands
- File: Open, Save, Save As
- Edit: Undo Delete, Copy Selection
- Find: Find (placeholder)
- View: Increase/Decrease Font, Toggle Wrap

Visual Style
- Default system font.
- Light/Dark toggle forces color scheme.
- Selected text color: light mode black, dark mode white.

Acceptance Criteria
- Toolbar and status bar remain visible before and after file open.
- Grid shows row numbers and column headers, sticky on scroll.
- Horizontal scroll reaches all columns.
- Multi-select works with Cmd/Shift.
- Delete confirmation includes column name or row number.
- Save writes UTF-8.
- Open Recent persists across launches.
- Large file prompt shows Load Preview / Load All options.
