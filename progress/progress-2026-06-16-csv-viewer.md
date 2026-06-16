# Progress Note

Date: 2026-06-16 America/New_York
Project: `csv-viewer`

## Task

Stabilize the local build loop, add visible build/version numbering to the app, publish a consistent runnable app bundle inside the repo, tighten the empty-state and toolbar tooltip UX, and add quick filtering/navigation polish for personal CSV editing.

## Outcome

- Repaired the local Xcode environment with `xcodebuild -runFirstLaunch`; `xcodebuild build` and `xcodebuild test` now succeed again.
- Added build-aware window-title formatting so the app shows `CSV Viewer v2026.06.16-003`.
- Added `scripts/build-app.sh` to build and republish the latest debug app bundle to `artifacts/CSV Viewer.app`.
- Reworked the empty state into a large centered drag/drop target that also opens the file picker on click.
- Fixed the empty-state visibility condition so it disappears once a file is loaded.
- Moved custom toolbar tooltips below the icons and removed duplicate native/custom tooltip stacking.
- Added a quick row filter that stays top-anchored and highlights matching phrases in visible cells.
- Added keyboard navigation for moving through visible cells and starting edits from the active cell.

## Overall Progress

The repo now has a reliable local build path, a stable app artifact for manual testing, and a cleaner first-run/open-file interaction. Confidence that the current build/test loop is usable again: `0.96`.

## Risks / Blockers

- Core app behavior is still concentrated in `ContentView.swift`, which keeps UI changes fast but increases regression risk.
- Tooltip behavior is improved, but it remains custom UI code and may still need minor spacing adjustments after more live use.
- Test coverage is still light outside CSV parsing, so most recent UX changes were validated through build/manual iteration rather than targeted UI tests.

## Recommended Next Steps

1. Add light regression coverage around document-load state so the empty-state/drop-zone logic does not reappear after future refactors.
2. Consider extracting toolbar/empty-state UI into smaller SwiftUI components before adding more interaction polish.
3. If feature work resumes next, export formats remains the highest-value product slice after this stabilization batch.
