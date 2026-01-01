import AppKit
import SwiftUI

struct EditingTextField: NSViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    let font: NSFont
    let onCommit: () -> Void
    let onTab: (Bool) -> Void
    let onCancel: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField(string: text)
        textField.delegate = context.coordinator
        textField.isBordered = false
        textField.backgroundColor = .clear
        textField.focusRingType = .none
        textField.font = font
        textField.usesSingleLineMode = true
        textField.lineBreakMode = .byTruncatingTail
        return textField
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        if nsView.stringValue != text {
            nsView.stringValue = text
        }
        if nsView.font != font {
            nsView.font = font
        }
        if isFocused, nsView.window?.firstResponder != nsView.currentEditor() {
            nsView.window?.makeFirstResponder(nsView)
        }
    }

    final class Coordinator: NSObject, NSTextFieldDelegate {
        private let parent: EditingTextField

        init(_ parent: EditingTextField) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else { return }
            parent.text = textField.stringValue
        }

        func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            switch commandSelector {
            case #selector(NSResponder.insertNewline(_:)):
                parent.onCommit()
                return true
            case #selector(NSResponder.insertTab(_:)):
                parent.onTab(false)
                return true
            case #selector(NSResponder.insertBacktab(_:)):
                parent.onTab(true)
                return true
            case #selector(NSResponder.cancelOperation(_:)):
                parent.onCancel()
                return true
            default:
                return false
            }
        }
    }
}
