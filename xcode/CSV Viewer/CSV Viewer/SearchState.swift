import Combine
import Foundation

struct SearchMatch: Hashable, Identifiable {
    let row: Int
    let column: Int

    var id: String {
        "\(row)-\(column)"
    }
}

final class SearchState: ObservableObject {
    @Published var query: String = ""
    @Published var matches: [SearchMatch] = []
    @Published var matchSet: Set<SearchMatch> = []
    @Published var currentIndex: Int = 0
    @Published var isColumnScoped: Bool = false

    var currentMatch: SearchMatch? {
        guard matches.indices.contains(currentIndex) else { return nil }
        return matches[currentIndex]
    }

    func advance(forward: Bool) {
        guard !matches.isEmpty else { return }
        if forward {
            currentIndex = (currentIndex + 1) % matches.count
        } else {
            currentIndex = (currentIndex - 1 + matches.count) % matches.count
        }
    }
}
