import Foundation

/// RFC 4180 compliant CSV parser and formatter
struct CSVParser {
    /// Parse a single CSV line into fields
    /// Handles quoted fields, escaped quotes, and commas within fields
    static func parseLine(_ line: String) -> [String] {
        var fields: [String] = []
        var currentField = ""
        var insideQuotes = false
        var index = line.startIndex

        while index < line.endIndex {
            let char = line[index]

            if char == "\"" {
                // Check if it's an escaped quote
                let nextIndex = line.index(after: index)
                if insideQuotes && nextIndex < line.endIndex && line[nextIndex] == "\"" {
                    // Escaped quote - add one quote to field
                    currentField.append("\"")
                    index = line.index(after: nextIndex)
                    continue
                } else {
                    // Toggle quote mode
                    insideQuotes.toggle()
                }
            } else if char == "," && !insideQuotes {
                // Field separator
                fields.append(currentField)
                currentField = ""
            } else {
                currentField.append(char)
            }

            index = line.index(after: index)
        }

        // Add the last field
        fields.append(currentField)

        return fields
    }

    /// Format fields into a CSV line
    /// Escapes fields that contain commas, quotes, or newlines
    static func formatLine(_ fields: [String]) -> String {
        fields.map { escapeField($0) }.joined(separator: ",")
    }

    /// Escape a CSV field according to RFC 4180
    /// Fields containing comma, quote, or newline are quoted and quotes are doubled
    private static func escapeField(_ field: String) -> String {
        // Fields containing comma, quote, or newline must be quoted
        if field.contains(",") || field.contains("\"") || field.contains("\n") {
            // Escape quotes by doubling them
            let escaped = field.replacingOccurrences(of: "\"", with: "\"\"")
            return "\"\(escaped)\""
        }
        return field
    }
}
