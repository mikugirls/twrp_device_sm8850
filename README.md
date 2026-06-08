# Xiaomi TWRP device trees and source changes

This contains the device trees and source-side changes used for the listed recovery images.

## Devices

- Redmi K90: `annibale`
- Redmi K90 Pro Max: `myron`
- Xiaomi 17 Ultra: `nezha`

## Layout

- `device/xiaomi/annibale`: Redmi K90 device tree
- `device/xiaomi/myron`: Redmi K90 Pro Max device tree
- `device/xiaomi/nezha`: Xiaomi 17 Ultra device tree
- `source_changes/files`: modified source files copied from the build tree
- `source_changes/patches`: git patches for upstream source trees

## Source changes summary

- `bootable/recovery/twrpinstall/twinstall.cpp`: slot detection fix. 
- `bootable/recovery/gui/action.cpp`: Auto-reflash TWRP after flashing ROM (backs up recovery before flash, restores to both slots after). 
- `bootable/recovery/twrp-functions.cpp`: Clear bootloader message before reboot to prevent bootloop. Fix `rb_fastboot` to use `reboot,bootloader` property.
- `bootable/recovery/gui/theme/common/languages/en.xml`: Added `reflash_twrp_after_zip` and `reflash_twrp_err` strings.
- `bootable/recovery/gui/theme/extra-languages/languages/zh_CN.xml`: Added Chinese translations for reflash TWRP strings.
- `bootable/recovery` (other files): UI layout, USB/MTP behavior, storage handling, haptics, Wi-Fi page assets(myron), flashing flow, and recovery behavior adjustments.
- `system/vold`: Android 16 FBE / Weaver compatibility adjustment.
