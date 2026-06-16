# Personal Default CSV Viewer Plan

Date: 2026-06-16

## Goal

Make CSV Viewer a dependable personal macOS app for opening CSVs by default, inspecting them quickly, making small edits, and saving without opening Excel.

This is not a public product plan. Optimize for Paul's everyday workflow, a reliable local executable, and easy future tweaks.

## Done Looks Like

- The app builds and tests from the command line.
- A current runnable app bundle exists at `artifacts/CSV Viewer.app`.
- The app can open CSV files through Finder / double-click default-app flow.
- The app can Save and Save As user-selected CSV files reliably.
- The app handles ordinary CSVs well: open, view, edit cells/headers, add/delete rows/columns, sort, find, copy, and save.
- Project docs explain the build/run/default-app loop clearly enough to resume later.

## Work Plan

### 1. Reliability Settings

- Review Xcode file-access settings so Save and Save As match the app's actual behavior.
- Set the macOS deployment target to the intended practical compatibility floor instead of the current machine-only target.
- Keep the bundle identifier and version display stable.

### 2. Runnable App Artifact

- Run the command-line build.
- Publish the latest debug app to `artifacts/CSV Viewer.app`.
- Verify the artifact's version/build metadata.

### 3. Default CSV Viewer Readiness

- Confirm the app declares/accepts CSV files well enough for Finder workflows.
- Document how to set CSV Viewer as the default app for `.csv` files on macOS.
- Avoid app-store/notarization complexity unless macOS blocks personal use.

### 4. Personal Workflow Polish

- Prioritize quick manipulations over spreadsheet breadth:
  - edit visible cells and headers
  - add/delete rows and columns
  - sort a column
  - find values
  - copy selection as CSV
  - save back to disk
- Prefer small, low-risk improvements over large architecture rewrites.

### 5. Later Enhancements

- Export TSV/JSON only if it becomes a recurring need.
- Add filtering if real CSV review sessions show sorting/find are not enough.
- Extract a small document/model layer only when feature work starts feeling brittle.
- Improve large-file behavior only if actual files are slow.

## Current Priorities

1. Fix file-access/deployment settings.
2. Build and republish the app bundle.
3. Verify tests still pass.
4. Update README with the personal build/default-app workflow.

