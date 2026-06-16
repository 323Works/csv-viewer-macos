#!/bin/zsh

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
project_dir="$repo_root/xcode/CSV Viewer"
derived_data_dir="${HOME}/Library/Developer/Xcode/DerivedData/CSV_Viewer-btyntxfandbzqihelcussqwapchr"
built_app_path="$derived_data_dir/Build/Products/Debug/CSV Viewer.app"
artifact_app_path="$repo_root/artifacts/CSV Viewer.app"

echo "Building CSV Viewer..."
xcodebuild -scheme "CSV Viewer" -configuration Debug build -project "$project_dir/CSV Viewer.xcodeproj"

if [[ ! -d "$built_app_path" ]]; then
  echo "Built app not found at: $built_app_path" >&2
  exit 1
fi

echo "Publishing app to artifacts..."
rm -rf "$artifact_app_path"
ditto "$built_app_path" "$artifact_app_path"

echo "Ready: $artifact_app_path"
