# Napkin

## Corrections
| Date | Source | What Went Wrong | What To Do Instead |
|------|--------|----------------|-------------------|
| 2026-02-17 | self | Ran `xcodebuild build` and `xcodebuild test` in parallel; DerivedData build.db locked | Run build/test sequentially for this repo to avoid XCBuild database lock contention |
| 2026-02-17 | self | Command-bar tooltips rendered above icons and were obscured by top window/menu chrome | Render command-bar tooltip overlays below icons and keep `.help` as secondary fallback |
| 2026-04-01 | self | `xcodebuild test` failed before running tests because Xcode could not load `IDESimulatorFoundation` | Repair the local Xcode install state first, starting with `xcodebuild -runFirstLaunch`, before trusting build/test results in this repo |
| 2026-04-01 | user | Toolbar tooltips overlapped icons and duplicated with native help bubbles | Place custom toolbar tooltips farther below the icons and avoid pairing them with `.help` on the same control |

## User Preferences
- Use clear, cogent, concise writing with practical actionable advice.
- Include probabilistic weights when comparing options.
- Keep project docs/notes in `docs/`.
- In selection UX, clicking an already-selected header/row should be able to deselect it when appropriate.
- Toolbar/command-bar icons should have hover tooltips that clearly describe the action.
- Prefer command-line edit/build/test loops where possible; user can run the built local app directly without opening Xcode.

## Patterns That Work
- Start sessions by orienting through Markdown docs and core code paths.
- For this repo, scan `xcode/CSV Viewer/CSV Viewer/ContentView.swift` first: it holds most product behavior and state transitions.
- Use `CSVParser` for all CSV round-trip logic and keep parser behavior covered by `CSVParserTests`.
- Refresh `README.md` when feature scope changes (search/editing/undo had drifted and created mismatch).
- For command-bar hover hints, use explicit `onHover` tooltip overlays (`commandTooltip`) positioned below the icons; avoid stacking them with native `.help` when it causes duplicate bubbles.
- If `xcodebuild` fails with `IDESimulatorFoundation` or `DVTDownloads` plugin-load errors after an Xcode update, run `xcodebuild -runFirstLaunch` before debugging the project itself.

## Patterns That Don't Work
- Skipping a repo-level session memory file causes repeated context re-learning.
- Assuming Xcode test failures are app regressions before checking for local toolchain/plugin issues.

## Domain Notes
- Project is `csv-viewer`.
- Stack: native macOS SwiftUI app (`CSV_ViewerApp`) with `AppDelegate` for quit/unsaved dialog handling.
- Core data model in-memory: `columns: [String]`, `rows: [[String]]`; no separate document model yet.
- Search is global shared state via `SearchState`, rendered through a separate Find window and in-grid highlight/scroll.
