import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.openWindow) private var openWindow

    @State private var columns: [String] = []
    @State private var rows: [[String]] = []
    @State private var fileName: String = ""
    @State private var fileURL: URL?
    @State private var fileEncoding: String.Encoding = .utf8

    @State private var selectedRows: Set<Int> = []
    @State private var selectedColumns: Set<Int> = []
    @State private var lastSelectedRow: Int?
    @State private var lastSelectedColumn: Int?

    @State private var showOverwriteAlert = false
    @State private var pendingOpenURL: URL?
    @State private var showLargeFileAlert = false
    @State private var columnWidths: [CGFloat] = []
    @State private var recentFiles: [URL] = []
    @State private var fontSize: CGFloat = 13
    @State private var wrapLines = false
    @State private var preferDarkMode = false
    @State private var sortColumn: Int?
    @State private var sortAscending = true
    @State private var undoStack: [UndoAction] = []
    @State private var pendingDeleteColumnIndices: [Int] = []
    @State private var showDeleteColumnAlert = false
    @State private var pendingDeleteRowIndices: [Int] = []
    @State private var showDeleteRowAlert = false
    @State private var showHelp = false
    @State private var showSettings = false
    @State private var isPreview = false
    @State private var horizontalScrollOffset: CGFloat = 0

    @AppStorage("csvviewer.previewRowLimit") private var previewRowLimit = 10000
    @AppStorage("csvviewer.largeFileMB") private var largeFileMB = 50
    @AppStorage("csvviewer.previewLargeFiles") private var previewLargeFiles = true

    private enum UndoAction {
        case deleteColumns(columns: [DeletedColumn])
        case deleteRows(rows: [DeletedRow])
    }

    private struct DeletedColumn {
        let index: Int
        let name: String
        let values: [String]
    }

    private struct DeletedRow {
        let index: Int
        let row: [String]
    }

    private let rowNumberWidth: CGFloat = 52
    private let rowNumberPadding: CGFloat = 4
    private let cellPadding: CGFloat = 6
    private let headerControlWidth: CGFloat = 34
    private let minColumnWidth: CGFloat = 60
    private let maxColumnWidth: CGFloat = 520

    private var viewerActions: CSVViewerActions {
        CSVViewerActions(
            open: { openCSV() },
            save: {
                if fileURL == nil {
                    saveCSVAs()
                } else {
                    showOverwriteAlert = true
                }
            },
            saveAs: { saveCSVAs() },
            undoDelete: { undoDelete() },
            copy: { copySelectionToClipboard() },
            find: { openFindWindow() },
            decreaseFont: { adjustFontSize(-1) },
            increaseFont: { adjustFontSize(1) },
            toggleWrap: { wrapLines.toggle() }
        )
    }

    private var rowHeight: CGFloat {
        max(26, fontSize + 14)
    }

    private var contentWidth: CGFloat {
        columnWidths.reduce(0, +)
    }

    private var toolbarView: some View {
        HStack {
            Button {
                openCSV()
            } label: {
                Image(systemName: "folder")
            }
            .help(Text("Open CSV..."))
            .keyboardShortcut("o", modifiers: [.command])

            Menu {
                if recentFiles.isEmpty {
                    Text("No recent files")
                } else {
                    ForEach(recentFiles, id: \.self) { url in
                        Button(url.lastPathComponent) {
                            openCSVURL(url)
                        }
                    }
                    Divider()
                    Button("Clear Recents") {
                        clearRecentFiles()
                    }
                }
            } label: {
                Image(systemName: "clock.arrow.circlepath")
            }
            .help(Text("Open Recent"))
            .disabled(recentFiles.isEmpty)

            Button {
                if fileURL == nil {
                    saveCSVAs()
                } else {
                    showOverwriteAlert = true
                }
            } label: {
                Image(systemName: "square.and.arrow.down")
            }
            .help(Text("Save CSV"))
            .disabled(columns.isEmpty)
            .keyboardShortcut("s", modifiers: [.command])

            Divider()
                .frame(height: 18)
                .padding(.horizontal, 4)

            Button {
                undoDelete()
            } label: {
                Image(systemName: "arrow.uturn.left")
            }
            .help(Text("Undo delete"))
            .keyboardShortcut("z", modifiers: [.command])
            .disabled(undoStack.isEmpty)

            Button {
                copySelectionToClipboard()
            } label: {
                Image(systemName: "doc.on.doc")
            }
            .help(Text("Copy selection"))
            .keyboardShortcut("c", modifiers: [.command])
            .disabled(columns.isEmpty || rows.isEmpty)

            Button {
                // Placeholder for future search UI.
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .help(Text("Find (coming soon)"))
            .keyboardShortcut("f", modifiers: [.command])
            .disabled(true)

            Button {
                adjustFontSize(-1)
            } label: {
                Image(systemName: "textformat.size.smaller")
            }
            .help(Text("Decrease font size"))
            .keyboardShortcut("-", modifiers: [.command])

            Button {
                adjustFontSize(1)
            } label: {
                Image(systemName: "textformat.size.larger")
            }
            .help(Text("Increase font size"))
            .keyboardShortcut("=", modifiers: [.command])

            Button {
                wrapLines.toggle()
            } label: {
                Image(systemName: wrapLines ? "text.justify" : "text.justify.left")
            }
            .help(Text(wrapLines ? "Disable line wrapping" : "Enable line wrapping"))
            .keyboardShortcut("l", modifiers: [.command])

            Button {
                saveCSVAs()
            } label: {
                EmptyView()
            }
            .keyboardShortcut("s", modifiers: [.command, .shift])
            .opacity(0)
            .frame(width: 0, height: 0)

            Divider()
                .frame(height: 18)
                .padding(.horizontal, 4)

            Button {
                addColumn(at: lastSelectedColumn, offset: 0)
            } label: {
                Image(systemName: "arrow.left.to.line")
            }
            .help(Text("Add column to the left of selection"))
            .disabled(lastSelectedColumn == nil)

            Button {
                addColumn(at: lastSelectedColumn, offset: 1)
            } label: {
                Image(systemName: "arrow.right.to.line")
            }
            .help(Text("Add column to the right of selection"))
            .disabled(lastSelectedColumn == nil)

            Button {
                addRow(at: lastSelectedRow, offset: 0)
            } label: {
                Image(systemName: "arrow.up.to.line")
            }
            .help(Text("Add row above selection"))
            .disabled(lastSelectedRow == nil)

            Button {
                addRow(at: lastSelectedRow, offset: 1)
            } label: {
                Image(systemName: "arrow.down.to.line")
            }
            .help(Text("Add row below selection"))
            .disabled(lastSelectedRow == nil)

            Button {
                pendingDeleteColumnIndices = selectedColumns.sorted()
                showDeleteColumnAlert = !selectedColumns.isEmpty
            } label: {
                Image(systemName: "trash")
            }
            .help(Text("Delete selected column"))
            .disabled(selectedColumns.isEmpty)

            Button {
                pendingDeleteRowIndices = selectedRows.sorted()
                showDeleteRowAlert = !selectedRows.isEmpty
            } label: {
                Image(systemName: "trash.slash")
            }
            .help(Text("Delete selected row"))
            .disabled(selectedRows.isEmpty)

            Spacer()

            Button {
                preferDarkMode.toggle()
            } label: {
                Image(systemName: preferDarkMode ? "sun.max.fill" : "moon.fill")
            }
            .help(Text(preferDarkMode ? "Switch to light mode" : "Switch to dark mode"))

            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape")
            }
            .help(Text("Settings"))

            Button {
                showHelp = true
            } label: {
                Image(systemName: "questionmark.circle")
            }
            .help(Text("Help"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var topBarView: some View {
        VStack(alignment: .leading, spacing: 0) {
            toolbarView
                .focusedSceneValue(\.csvViewerActions, viewerActions)
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 6)

            if !fileName.isEmpty {
                Text(fileName)
                    .font(.system(size: fontSize + 2, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom, 6)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var statusBarView: some View {
        HStack(spacing: 12) {
            Text("Rows: \(rows.count)")
            Text("Columns: \(columns.count)")
            Text("Encoding: \(encodingLabel(fileEncoding))")
            if isPreview {
                Text("Preview: first \(previewRowLimit) rows")
            }
            Spacer()
            Button {
                NSWorkspace.shared.open(URL(string: "https://www.323works.com")!)
            } label: {
                Image(systemName: "info.circle")
            }
            .buttonStyle(.plain)
            .help(Text("Powered by 323 Works, LLC\nhttps://www.323works.com"))
        }
        .foregroundColor(.secondary)
        .padding([.leading, .trailing, .bottom], 8)
        .background(Color(NSColor.windowBackgroundColor))
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var emptyView: some View {
        Text("Open a CSV file to view it.")
            .foregroundColor(.secondary)
            .padding()
    }

    private var rowNumbersColumn: some View {
        VStack(spacing: 0) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                Text("\(rowIndex + 1)")
                    .font(.system(size: fontSize, weight: .semibold))
                    .foregroundColor(rowIndexTextColor(row: rowIndex))
                    .padding(.horizontal, rowNumberPadding)
                    .frame(width: rowNumberWidth, height: rowHeight, alignment: .trailing)
                    .background(rowIndexBackground(row: rowIndex))
                    .border(Color.secondary)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        handleRowSelection(at: rowIndex)
                    }
            }
        }
    }

    private var gridRows: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(spacing: 0) {
                    ForEach(rows[rowIndex].indices, id: \.self) { colIndex in
                        Text(rows[rowIndex][colIndex])
                            .font(.system(size: fontSize))
                            .foregroundColor(cellSelectionTextColor(row: rowIndex, column: colIndex))
                            .lineLimit(wrapLines ? nil : 1)
                            .multilineTextAlignment(.leading)
                            .truncationMode(.tail)
                            .padding(.horizontal, cellPadding)
                            .frame(width: columnWidth(for: colIndex), height: rowHeight, alignment: .leading)
                            .background(cellSelectionColor(row: rowIndex, column: colIndex))
                            .border(Color.secondary)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                handleRowSelection(at: rowIndex)
                            }
                    }
                }
            }
        }
        .frame(width: contentWidth, alignment: .leading)
    }

    private var headerCells: some View {
        HStack(spacing: 0) {
            ForEach(columns.indices, id: \.self) { index in
                HStack(spacing: 6) {
                    Text(columns[index])
                        .font(.system(size: fontSize, weight: .semibold))
                        .foregroundColor(headerSelectionTextColor(for: index))
                        .lineLimit(nil)
                        .fixedSize(horizontal: true, vertical: false)
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 4)
                    Button {
                        // Toggle sort: if already sorted by this column, reverse direction
                        if sortColumn == index {
                            sortByColumn(index, ascending: !sortAscending)
                        } else {
                            sortByColumn(index, ascending: true)
                        }
                    } label: {
                        VStack(spacing: 1) {
                            Image(systemName: "arrowtriangle.up.fill")
                                .font(.system(size: 8))
                                .foregroundColor(sortArrowColor(column: index, ascending: true))
                            Image(systemName: "arrowtriangle.down.fill")
                                .font(.system(size: 8))
                                .foregroundColor(sortArrowColor(column: index, ascending: false))
                        }
                    }
                    .buttonStyle(.plain)
                    .help(Text("Sort column"))
                }
                .padding(.horizontal, cellPadding)
                .frame(minWidth: columnWidth(for: index), maxWidth: .infinity, alignment: .leading)
                .frame(height: rowHeight)
                .background(headerSelectionColor(for: index))
                .border(Color.secondary)
                .contentShape(Rectangle())
                .onTapGesture {
                    handleColumnSelection(at: index)
                }
            }
        }
        .frame(width: contentWidth, alignment: .leading)
    }

    private var gridView: some View {
        ScrollViewReader { scrollProxy in
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(rows.indices, id: \.self) { rowIndex in
                            HStack(spacing: 0) {
                                Text("\(rowIndex + 1)")
                                    .font(.system(size: fontSize, weight: .semibold))
                                    .foregroundColor(rowIndexTextColor(row: rowIndex))
                                    .padding(.horizontal, rowNumberPadding)
                                    .frame(width: rowNumberWidth, height: rowHeight, alignment: .trailing)
                                    .background(rowIndexBackground(row: rowIndex))
                                    .border(Color.secondary)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        handleRowSelection(at: rowIndex)
                                    }

                                HStack(spacing: 0) {
                                    ForEach(rows[rowIndex].indices, id: \.self) { colIndex in
                                        Text(rows[rowIndex][colIndex])
                                            .font(.system(size: fontSize))
                                            .foregroundColor(cellSelectionTextColor(row: rowIndex, column: colIndex))
                                            .lineLimit(wrapLines ? nil : 1)
                                            .multilineTextAlignment(.leading)
                                            .truncationMode(.tail)
                                            .padding(.horizontal, cellPadding)
                                            .frame(width: columnWidth(for: colIndex), height: rowHeight, alignment: .leading)
                                            .background(cellSelectionColor(row: rowIndex, column: colIndex))
                                            .border(Color.secondary)
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                handleRowSelection(at: rowIndex)
                                            }
                                    }
                                }
                            }
                        }
                    } header: {
                        HStack(spacing: 0) {
                            Text("#")
                                .font(.system(size: fontSize, weight: .semibold))
                                .padding(.horizontal, rowNumberPadding)
                                .frame(width: rowNumberWidth, height: rowHeight, alignment: .trailing)
                                .background(Color.secondary.opacity(0.1))
                                .border(Color.secondary)

                            headerCells
                        }
                        .background(Color(NSColor.windowBackgroundColor))
                    }
                }
            }
            .padding([.leading, .trailing])
        }
    }

    private var mainContent: some View {
        Group {
            if !rows.isEmpty {
                gridView
            } else {
                emptyView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            topBarView

            mainContent

            Divider()

            statusBarView
        }
        .frame(minWidth: 700, minHeight: 420)
        .preferredColorScheme(preferDarkMode ? .dark : .light)
        .alert("Save", isPresented: $showOverwriteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Overwrite", role: .destructive) {
                saveCSV(to: fileURL)
            }
            Button("Save As...") {
                saveCSVAs()
            }
        } message: {
            let name = fileURL?.lastPathComponent ?? "this file"
            Text("Overwrite \(name)?")
        }
        .alert("Delete Column?", isPresented: $showDeleteColumnAlert) {
            Button("Cancel", role: .cancel) {
                pendingDeleteColumnIndices = []
            }
            Button("Delete", role: .destructive) {
                deleteSelectedColumns(pendingDeleteColumnIndices)
                pendingDeleteColumnIndices = []
            }
        } message: {
            Text(deleteColumnsMessage(pendingDeleteColumnIndices))
        }
        .alert("Delete Row?", isPresented: $showDeleteRowAlert) {
            Button("Cancel", role: .cancel) {
                pendingDeleteRowIndices = []
            }
            Button("Delete", role: .destructive) {
                deleteSelectedRows(pendingDeleteRowIndices)
                pendingDeleteRowIndices = []
            }
        } message: {
            Text(deleteRowsMessage(pendingDeleteRowIndices))
        }
        .alert("Large File", isPresented: $showLargeFileAlert) {
            Button("Cancel", role: .cancel) {
                pendingOpenURL = nil
            }
            Button("Load Preview") {
                if let url = pendingOpenURL {
                    loadCSV(from: url, limitRows: previewRowLimit)
                }
                pendingOpenURL = nil
            }
            Button("Load All", role: .destructive) {
                if let url = pendingOpenURL {
                    loadCSV(from: url, limitRows: nil)
                }
                pendingOpenURL = nil
            }
        } message: {
            Text("This file is large. Load a \(previewRowLimit)-row preview or open the full file?")
        }
        .sheet(isPresented: $showHelp) {
            HelpView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(
                previewRowLimit: $previewRowLimit,
                largeFileMB: $largeFileMB,
                previewLargeFiles: $previewLargeFiles
            )
        }
        .onAppear {
            recentFiles = loadRecentFiles()
        }
        .onChange(of: fontSize) {
            columnWidths = computeColumnWidths(columns: columns, rows: rows)
        }
    }

    private func openFindWindow() {
        openWindow(id: "find")
    }

    private func openCSV() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.commaSeparatedText]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        if panel.runModal() == .OK, let url = panel.url {
            openCSVURL(url)
        }
    }

    private func openCSVURL(_ url: URL) {
        if shouldPreview(url: url) {
            pendingOpenURL = url
            showLargeFileAlert = true
        } else {
            loadCSV(from: url, limitRows: nil)
        }
    }

    private func loadCSV(from url: URL, limitRows: Int?) {
        do {
            var encoding: String.Encoding = .utf8
            let text = try String(contentsOf: url, usedEncoding: &encoding)
            let lines = text
                .split(whereSeparator: \.isNewline)
                .map(String.init)
                .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }

            guard let headerLine = lines.first else {
                clearData()
                return
            }

            columns = headerLine.components(separatedBy: ",")
            let bodyLines = Array(lines.dropFirst())
            let limitedLines: [String]
            if let limit = limitRows {
                limitedLines = Array(bodyLines.prefix(limit))
                isPreview = bodyLines.count > limit
            } else {
                limitedLines = bodyLines
                isPreview = false
            }

            rows = limitedLines.map { line in
                let parts = line.components(separatedBy: ",")
                if parts.count < columns.count {
                    return parts + Array(repeating: "", count: columns.count - parts.count)
                }
                return Array(parts.prefix(columns.count))
            }

            fileName = url.lastPathComponent
            fileURL = url
            fileEncoding = encoding
            selectedRows = []
            selectedColumns = []
            lastSelectedRow = nil
            lastSelectedColumn = nil
            columnWidths = computeColumnWidths(columns: columns, rows: rows)
            sortColumn = nil
            sortAscending = true
            undoStack = []
            recordRecentFile(url)
        } catch {
            clearData()
            print("Failed to load CSV: \(error)")
        }
    }

    private func clearData() {
        columns = []
        rows = []
        fileName = ""
        fileURL = nil
        fileEncoding = .utf8
        selectedRows = []
        selectedColumns = []
        lastSelectedRow = nil
        lastSelectedColumn = nil
        columnWidths = []
        sortColumn = nil
        sortAscending = true
        undoStack = []
        isPreview = false
    }

    private func addColumn(at index: Int?, offset: Int) {
        guard let index else { return }
        let insertIndex = max(0, min(columns.count, index + offset))
        columns.insert("New Column", at: insertIndex)
        rows = rows.map { row in
            var updated = row
            updated.insert("", at: insertIndex)
            return updated
        }
        selectedColumns = [insertIndex]
        lastSelectedColumn = insertIndex
        columnWidths = computeColumnWidths(columns: columns, rows: rows)
    }

    private func addRow(at index: Int?, offset: Int) {
        guard let index else { return }
        let insertIndex = max(0, min(rows.count, index + offset))
        let newRow = Array(repeating: "", count: columns.count)
        rows.insert(newRow, at: insertIndex)
        selectedRows = [insertIndex]
        lastSelectedRow = insertIndex
        columnWidths = computeColumnWidths(columns: columns, rows: rows)
    }

    private func deleteSelectedColumns(_ indices: [Int]) {
        let valid = indices.filter { columns.indices.contains($0) }
        guard !valid.isEmpty else { return }

        let deleted = valid.sorted().map { index in
            DeletedColumn(
                index: index,
                name: columns[index],
                values: rows.map { row in
                    guard row.indices.contains(index) else { return "" }
                    return row[index]
                }
            )
        }

        for index in valid.sorted(by: >) {
            columns.remove(at: index)
            rows = rows.map { row in
                guard row.indices.contains(index) else { return row }
                var updated = row
                updated.remove(at: index)
                return updated
            }
        }

        selectedColumns = []
        lastSelectedColumn = nil
        columnWidths = computeColumnWidths(columns: columns, rows: rows)
        sortColumn = nil
        undoStack.append(.deleteColumns(columns: deleted))
    }

    private func deleteSelectedRows(_ indices: [Int]) {
        let valid = indices.filter { rows.indices.contains($0) }
        guard !valid.isEmpty else { return }

        let deleted = valid.sorted().map { index in
            DeletedRow(index: index, row: rows[index])
        }

        for index in valid.sorted(by: >) {
            rows.remove(at: index)
        }

        selectedRows = []
        lastSelectedRow = nil
        columnWidths = computeColumnWidths(columns: columns, rows: rows)
        undoStack.append(.deleteRows(rows: deleted))
    }

    private func undoDelete() {
        guard let action = undoStack.popLast() else { return }
        switch action {
        case let .deleteColumns(columnsToRestore):
            let sorted = columnsToRestore.sorted { $0.index < $1.index }
            for column in sorted {
                let insertIndex = max(0, min(columns.count, column.index))
                columns.insert(column.name, at: insertIndex)
                rows = rows.enumerated().map { rowIndex, row in
                    var updated = row
                    let value = rowIndex < column.values.count ? column.values[rowIndex] : ""
                    updated.insert(value, at: insertIndex)
                    return updated
                }
            }
            selectedColumns = Set(sorted.map { $0.index })
            lastSelectedColumn = sorted.last?.index
        case let .deleteRows(rowsToRestore):
            let sorted = rowsToRestore.sorted { $0.index < $1.index }
            for row in sorted {
                let insertIndex = max(0, min(rows.count, row.index))
                rows.insert(row.row, at: insertIndex)
            }
            selectedRows = Set(sorted.map { $0.index })
            lastSelectedRow = sorted.last?.index
        }
        columnWidths = computeColumnWidths(columns: columns, rows: rows)
    }

    private func saveCSVAs() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.commaSeparatedText]
        panel.nameFieldStringValue = fileName.isEmpty ? "Untitled.csv" : fileName

        if panel.runModal() == .OK, let url = panel.url {
            saveCSV(to: url)
        }
    }

    private func saveCSV(to url: URL?) {
        guard let url else { return }
        var output = ""
        output += columns.joined(separator: ",") + "\n"
        for row in rows {
            output += row.joined(separator: ",") + "\n"
        }
        do {
            try output.write(to: url, atomically: true, encoding: .utf8)
            fileName = url.lastPathComponent
            fileURL = url
            fileEncoding = .utf8
            recordRecentFile(url)
        } catch {
            print("Failed to save CSV: \(error)")
        }
    }

    private func sortByColumn(_ index: Int, ascending: Bool) {
        guard columns.indices.contains(index) else { return }
        rows.sort { lhs, rhs in
            let left = index < lhs.count ? lhs[index] : ""
            let right = index < rhs.count ? rhs[index] : ""
            let leftNumber = Double(left)
            let rightNumber = Double(right)
            if let leftNumber, let rightNumber {
                return ascending ? (leftNumber < rightNumber) : (leftNumber > rightNumber)
            }
            if ascending {
                return left.localizedCaseInsensitiveCompare(right) == .orderedAscending
            }
            return left.localizedCaseInsensitiveCompare(right) == .orderedDescending
        }
        sortColumn = index
        sortAscending = ascending
    }

    private func sortArrowColor(column: Int, ascending: Bool) -> Color {
        if sortColumn == column && sortAscending == ascending {
            return .accentColor
        }
        return .secondary
    }

    private func columnWidth(for index: Int) -> CGFloat {
        guard index >= 0 && index < columnWidths.count else { return minColumnWidth }
        return columnWidths[index]
    }

    private func computeColumnWidths(columns: [String], rows: [[String]]) -> [CGFloat] {
        let bodyFont = NSFont.systemFont(ofSize: fontSize)
        let headerFont = NSFont.systemFont(ofSize: fontSize, weight: .semibold)
        let headerPadding = cellPadding * 2 + headerControlWidth
        let cellPaddingWidth = cellPadding * 2

        var widths: [CGFloat] = []
        widths.reserveCapacity(columns.count)

        for colIndex in columns.indices {
            let headerWidth = (columns[colIndex] as NSString)
                .size(withAttributes: [.font: headerFont]).width + headerPadding
            var widest = headerWidth

            for row in rows {
                if colIndex < row.count {
                    let cellWidth = (row[colIndex] as NSString)
                        .size(withAttributes: [.font: bodyFont]).width + cellPaddingWidth
                    if cellWidth > widest {
                        widest = cellWidth
                    }
                }
            }
            let clamped = max(minColumnWidth, min(maxColumnWidth, widest))
            widths.append(clamped)
        }
        return widths
    }

    private func cellSelectionColor(row: Int, column: Int) -> Color {
        let rowSelected = selectedRows.contains(row)
        let columnSelected = selectedColumns.contains(column)
        if rowSelected || columnSelected {
            return Color.accentColor.opacity(0.6)
        }
        return .clear
    }

    private func headerSelectionColor(for column: Int) -> Color {
        if selectedColumns.contains(column) {
            return Color.accentColor.opacity(0.6)
        }
        return Color.clear
    }

    private func cellSelectionTextColor(row: Int, column: Int) -> Color {
        if selectedRows.contains(row) || selectedColumns.contains(column) {
            return colorScheme == .light ? .black : .white
        }
        return .primary
    }

    private func headerSelectionTextColor(for column: Int) -> Color {
        if selectedColumns.contains(column) {
            return colorScheme == .light ? .black : .white
        }
        return .primary
    }

    private func rowIndexBackground(row: Int) -> Color {
        if selectedRows.contains(row) {
            return Color.accentColor.opacity(0.6)
        }
        return Color.secondary.opacity(0.1)
    }

    private func rowIndexTextColor(row: Int) -> Color {
        if selectedRows.contains(row) {
            return colorScheme == .light ? .black : .white
        }
        return .secondary
    }

    private func handleColumnSelection(at index: Int) {
        let modifiers = currentModifierFlags()
        let hasCommand = modifiers.contains(.command)
        let hasShift = modifiers.contains(.shift)

        selectedRows = []
        lastSelectedRow = nil

        if hasShift, let anchor = lastSelectedColumn {
            let range = Set(min(anchor, index)...max(anchor, index))
            if hasCommand {
                selectedColumns.formUnion(range)
            } else {
                selectedColumns = range
            }
        } else if hasCommand {
            if selectedColumns.contains(index) {
                selectedColumns.remove(index)
            } else {
                selectedColumns.insert(index)
            }
        } else {
            selectedColumns = [index]
        }
        lastSelectedColumn = index
    }

    private func handleRowSelection(at index: Int) {
        let modifiers = currentModifierFlags()
        let hasCommand = modifiers.contains(.command)
        let hasShift = modifiers.contains(.shift)

        selectedColumns = []
        lastSelectedColumn = nil

        if hasShift, let anchor = lastSelectedRow {
            let range = Set(min(anchor, index)...max(anchor, index))
            if hasCommand {
                selectedRows.formUnion(range)
            } else {
                selectedRows = range
            }
        } else if hasCommand {
            if selectedRows.contains(index) {
                selectedRows.remove(index)
            } else {
                selectedRows.insert(index)
            }
        } else {
            selectedRows = [index]
        }
        lastSelectedRow = index
    }

    private func deleteColumnsMessage(_ indices: [Int]) -> String {
        let names = indices.compactMap { columns.indices.contains($0) ? columns[$0] : nil }
        if names.count == 1 {
            return "Delete Column \(names[0])"
        }
        if names.count <= 3 {
            return "Delete Columns " + names.joined(separator: ", ")
        }
        return "Delete \(names.count) Columns"
    }

    private func deleteRowsMessage(_ indices: [Int]) -> String {
        if indices.count == 1, let index = indices.first {
            return "Delete Row \(index + 1)"
        }
        if indices.count <= 3 {
            let labels = indices.map { String($0 + 1) }
            return "Delete Rows " + labels.joined(separator: ", ")
        }
        return "Delete \(indices.count) Rows"
    }

    private func currentModifierFlags() -> NSEvent.ModifierFlags {
        NSApp.currentEvent?.modifierFlags ?? []
    }

    private func adjustFontSize(_ delta: CGFloat) {
        let updated = fontSize + delta
        fontSize = max(10, min(22, updated))
    }

    private func copySelectionToClipboard() {
        guard !columns.isEmpty, !rows.isEmpty else { return }
        let rowIndices: [Int]
        let columnIndices: [Int]

        if selectedRows.isEmpty && selectedColumns.isEmpty {
            rowIndices = Array(rows.indices)
            columnIndices = Array(columns.indices)
        } else {
            rowIndices = selectedRows.isEmpty ? Array(rows.indices) : selectedRows.sorted()
            columnIndices = selectedColumns.isEmpty ? Array(columns.indices) : selectedColumns.sorted()
        }

        var lines: [String] = []
        if !columnIndices.isEmpty {
            let header = columnIndices.map { columns[$0] }.joined(separator: ",")
            lines.append(header)
        }
        for rowIndex in rowIndices {
            let row = rows[rowIndex]
            let values = columnIndices.map { index in
                index < row.count ? row[index] : ""
            }
            lines.append(values.joined(separator: ","))
        }

        let output = lines.joined(separator: "\n")
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(output, forType: .string)
    }

    private func encodingLabel(_ encoding: String.Encoding) -> String {
        switch encoding {
        case .utf8:
            return "UTF-8"
        case .utf16:
            return "UTF-16"
        case .utf16LittleEndian:
            return "UTF-16 LE"
        case .utf16BigEndian:
            return "UTF-16 BE"
        case .utf32:
            return "UTF-32"
        case .ascii:
            return "ASCII"
        default:
            return "Encoding \(encoding.rawValue)"
        }
    }

    private func recordRecentFile(_ url: URL) {
        var updated = recentFiles.filter { $0 != url }
        updated.insert(url, at: 0)
        recentFiles = Array(updated.prefix(5))
        saveRecentFiles(recentFiles)
    }

    private func loadRecentFiles() -> [URL] {
        let defaults = UserDefaults.standard
        guard let paths = defaults.array(forKey: "csvviewer.recentFiles") as? [String] else {
            return []
        }
        return paths.map { URL(fileURLWithPath: $0) }
    }

    private func saveRecentFiles(_ urls: [URL]) {
        let defaults = UserDefaults.standard
        let paths = urls.map { $0.path }
        defaults.set(paths, forKey: "csvviewer.recentFiles")
    }

    private func clearRecentFiles() {
        recentFiles = []
        saveRecentFiles([])
    }

    private func shouldPreview(url: URL) -> Bool {
        guard previewLargeFiles else { return false }
        let sizeBytes = (try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
        let threshold = largeFileMB * 1024 * 1024
        return sizeBytes >= threshold
    }
}

private struct HorizontalOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
