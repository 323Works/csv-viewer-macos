import Foundation

enum AppBuild {
    static let appName = "CSV Viewer"

    static var marketingVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
    }

    static var buildNumber: String {
        let rawBuildNumber = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "0"
        if let numericBuildNumber = Int(rawBuildNumber) {
            return String(format: "%03d", numericBuildNumber)
        }
        return rawBuildNumber
    }

    static var displayVersion: String {
        "\(marketingVersion)-\(buildNumber)"
    }

    static var windowTitle: String {
        "\(appName) v\(displayVersion)"
    }
}
