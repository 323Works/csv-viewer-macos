# Changelog

## Unreleased

- Highlighted matching filter phrases inside visible grid cells.
- Fixed filtered grid layout so sparse results stay anchored at the top.
- Added quick row filtering across visible CSV rows.
- Added default-app/double-click file opening via SwiftUI URL handling.
- Added active-cell keyboard navigation with arrows, Tab, Enter, Home/End, and Page Up/Page Down.
- Bumped the app build to `CSV Viewer v2026.06.16-003`.
- Added a personal default-viewer plan for using CSV Viewer as Paul's everyday CSV app.
- Added checked-in app bundle metadata declaring `.csv` files as editable documents.
- Changed user-selected file sandbox access from read-only to read/write so Save and Save As match the app's intended workflow.
- Lowered the deployment target to macOS 14.0 to match the README and cross-machine compatibility goal.
- Added bundle-driven window versioning so the app title now renders as `CSV Viewer vYYYY.MM.DD-build`.
- Added `scripts/build-app.sh` to publish a stable runnable build at `artifacts/CSV Viewer.app`.
- Repaired the local Xcode environment and documented `xcodebuild -runFirstLaunch` as the first fix for plugin-load failures.
- Reworked the empty state into a centered click-or-drop target and fixed it so it disappears once a file is loaded.
- Moved custom toolbar tooltips below icons and removed duplicate tooltip stacking.
- Initialized changelog during project orientation so future work batches have a durable delta log.
