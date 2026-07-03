#!/bin/bash
# scripts/apply-patches.sh
# Apply TWRP source changes for SM8850 devices
# Usage: ./scripts/apply-patches.sh [TWRP_SOURCE_ROOT]

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."
TWRP_SOURCE="${1:-$(pwd)}"

echo "========================================"
echo "TWRP SM8850 Source Patch Apply Script"
echo "========================================"
echo "TWRP source root: $TWRP_SOURCE"
echo ""

# Option 1: Apply git patches (recommended for upstream tracking)
apply_patches() {
    echo "[1/2] Applying git patches..."
    for patch_file in "$REPO_ROOT"/source_changes/patches/*/*.patch; do
        if [ -f "$patch_file" ]; then
            dir=$(basename "$(dirname "$patch_file")")
            # Convert underscore notation to path
            target="${dir/_//}"
            echo "  -> Applying: $(basename "$patch_file") to $target"
            if [ -d "$TWRP_SOURCE/$target" ]; then
                (cd "$TWRP_SOURCE/$target" && git apply "$patch_file") || {
                    echo "     WARNING: patch may have already been applied or source differs."
                }
            else
                echo "     WARNING: target directory $TWRP_SOURCE/$target not found, skipping."
            fi
        fi
    done
    echo ""
}

# Option 2: Copy modified files directly (fallback / exact replacement)
apply_files() {
    echo "[2/2] Copying modified source files..."
    if [ -d "$REPO_ROOT/source_changes/files" ]; then
        cd "$REPO_ROOT/source_changes/files"
        find . -type f | while read -r file; do
            src="$REPO_ROOT/source_changes/files/$file"
            dst="$TWRP_SOURCE/$file"
            mkdir -p "$(dirname "$dst")"
            echo "  -> Copying: $file"
            cp -f "$src" "$dst"
        done
    fi
    echo ""
}

apply_patches
apply_files

echo "========================================"
echo "Done. Source changes applied."
echo "========================================"
