import SwiftUI

struct CSVViewerActions {
    var open: () -> Void
    var save: () -> Void
    var saveAs: () -> Void
    var undoDelete: () -> Void
    var redoDelete: () -> Void
    var copy: () -> Void
    var find: () -> Void
    var findNext: () -> Void
    var findPrevious: () -> Void
    var decreaseFont: () -> Void
    var increaseFont: () -> Void
    var toggleWrap: () -> Void
}

struct CSVViewerActionsKey: FocusedValueKey {
    typealias Value = CSVViewerActions
}

extension FocusedValues {
    var csvViewerActions: CSVViewerActions? {
        get { self[CSVViewerActionsKey.self] }
        set { self[CSVViewerActionsKey.self] = newValue }
    }
}
