# Source Changes (Patches) Reference

This document describes the purpose of each source modification in `source_changes/`.

## Patch Files (`source_changes/patches/`)

### `bootable_recovery/0001-bootable_recovery.patch`

A consolidated git patch covering the following recovery framework changes:

| File | Change Description |
|------|-------------------|
| `twinstall.cpp` | Virtual A/B slot detection fix. Ensures correct active slot is detected when flashing ZIPs. |
| `action.cpp` | Auto-reflash TWRP after ROM flash. Backs up the current recovery image before flashing, then restores it to both slots afterward. |
| `twrp-functions.cpp` | Clear bootloader message before reboot to prevent bootloop. Also fixes `rb_fastboot` to use the correct `reboot,bootloader` property. |
| `gui/theme/common/languages/en.xml` | Added `reflash_twrp_after_zip` and `reflash_twrp_err` language strings. |
| `gui/theme/extra-languages/languages/zh_CN.xml` | Added Chinese translations for reflash TWRP strings. |
| `gui/theme/extra-languages/languages/zh_TW.xml` | Added Traditional Chinese translations for reflash TWRP strings. |
| `gui/theme/portrait_hdpi/ui.xml` | UI layout adjustments. |
| `partition.cpp` / `partitionmanager.cpp` | Dynamic partition / Virtual A/B alias handling. |
| `twrp-functions.cpp` / `twrp.cpp` | Recovery behavior, storage handling, USB/MTP fixes. |

### `system_vold/0001-system_vold.patch`

| File | Change Description |
|------|-------------------|
| `Weaver1.cpp` | Android 16 FBE / Weaver compatibility adjustment. Fixes interaction with Qualcomm Keymaster/Weaver HAL for file-based encryption decryption in recovery. |

## Full File Copies (`source_changes/files/`)

The `files/` directory contains complete modified source files intended to be copied directly over the upstream TWRP source tree. These are the same changes expressed as full file replacements rather than diffs.

### Directory: `source_changes/files/bootable/recovery/`

Contains the full modified recovery framework used for SM8850 devices, including:
- Core recovery logic (`partition.cpp`, `partitionmanager.cpp`, `twrp.cpp`, `twrp-functions.cpp`)
- GUI framework (`action.cpp`, `gui.cpp`, `theme/`)
- Build system (`Android.mk`, `Android.bp`, `libguitwrp_defaults.go`)
- Device-specific additions (e.g., `minuitwrp/graphics_drm.cpp` for Neo8)

**Note:** For Neo8, some files in this directory may differ from the Xiaomi device variants due to device-specific adjustments (e.g., DRM graphics init, OPlus touch stack integration, custom init scripts).

## How to Apply

Use the provided script:
```bash
./scripts/apply-patches.sh /path/to/twrp-source
```

This will first attempt to apply git patches, then copy any files from `source_changes/files/` as fallback/exact replacement.
