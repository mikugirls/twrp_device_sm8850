# device.mk - realme Neo8 / RMX8899 / RE6402L1

DEVICE_PATH := device/realme/RE6402L1

PRODUCT_CHECK_PREBUILT_MAX_PAGE_SIZE := false
PRODUCT_PLATFORM := canoe
PRODUCT_TARGET_VNDK_VERSION := 36

PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_VIRTUAL_AB_OTA := true
PRODUCT_VIRTUAL_AB_COMPRESSION := true
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := gz

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.fuse.passthrough.enable=true

PRODUCT_PACKAGES_DEBUG :=

PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

PRODUCT_PACKAGES += \
    fastbootd \
    lpdump \
    lpflash \
    mke2fs \
    e2fsck \
    tune2fs \
    resize2fs \
    fsck.f2fs \
    mkfs.f2fs \
    sload_f2fs \
    fsck.erofs \
    ip \
    bash \
    strace

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery.fstab:recovery/root/system/etc/recovery.fstab \
    $(DEVICE_PATH)/prebuilt/sbin/vendor/etc/vintf/manifest/android.hardware.wifi.supplicant.xml:recovery/root/vendor/etc/vintf/manifest/android.hardware.wifi.supplicant.xml

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/recovery/root,recovery/root)

# The touchable reference recovery only exposes the OPlus touch stack from
# vendor/odm. Keep the system-side duplicates out of recovery so the ODM
# touch service links against the same libraries and manifest as the reference.
RE6402L1_RECOVERY_SYSTEM_COPY_FILES := $(call find-copy-subdir-files,*,$(DEVICE_PATH)/prebuilt/system,recovery/root/system)
RE6402L1_RECOVERY_SYSTEM_TOUCH_CONFLICTS := \
    $(DEVICE_PATH)/prebuilt/system/etc/vintf/manifest/manifest_touch_aidl.xml:recovery/root/system/etc/vintf/manifest/manifest_touch_aidl.xml \
    $(DEVICE_PATH)/prebuilt/system/lib64/libtensorflowlite_oplus.so:recovery/root/system/lib64/libtensorflowlite_oplus.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/vendor.oplus.hardware.touch-V1-ndk.so:recovery/root/system/lib64/vendor.oplus.hardware.touch-V1-ndk.so \
    $(DEVICE_PATH)/prebuilt/system/lib64/vendor.oplus.hardware.touch-V2-ndk.so:recovery/root/system/lib64/vendor.oplus.hardware.touch-V2-ndk.so
RE6402L1_RECOVERY_SYSTEM_COPY_FILES := $(filter-out $(RE6402L1_RECOVERY_SYSTEM_TOUCH_CONFLICTS),$(RE6402L1_RECOVERY_SYSTEM_COPY_FILES))

PRODUCT_COPY_FILES += \
    $(RE6402L1_RECOVERY_SYSTEM_COPY_FILES) \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/prebuilt/system_ext,recovery/root/system_ext) \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/prebuilt/sbin,recovery/root/sbin) \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/prebuilt/vendor/bin,recovery/root/vendor/bin) \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/prebuilt/vendor/etc,recovery/root/vendor/etc) \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/prebuilt/vendor/firmware_mnt,recovery/root/vendor/firmware_mnt) \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/prebuilt/vendor/lib64,recovery/root/vendor/lib64) \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/prebuilt/vendor/odm,recovery/root/vendor/odm)

PRODUCT_APEX_SYSTEM_SERVER_JARS += com.android.crashrecovery:service-crashrecovery
