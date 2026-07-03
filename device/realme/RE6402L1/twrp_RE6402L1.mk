#
# TWRP device product for realme Neo8 / RMX8899 / RE6402L1.
#

DEVICE_PATH := device/realme/RE6402L1

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression_with_xor.mk)
$(call inherit-product, vendor/twrp/config/common.mk)
$(call inherit-product, $(DEVICE_PATH)/device.mk)

PRODUCT_DEVICE := RE6402L1
PRODUCT_NAME := twrp_RE6402L1
PRODUCT_BRAND := realme
PRODUCT_MODEL := RMX8899
PRODUCT_MANUFACTURER := realme
PRODUCT_RELEASE_NAME := realme Neo8

PRODUCT_GMS_CLIENTID_BASE := android-oplus

BUILD_FINGERPRINT := realme/RMX8899/RE6402L1:16/BP2A.250605.015/B.1f08cd6_4cba44_4cba45:user/release-keys
PRIVATE_BUILD_DESC := RMX8899-user 16 BP2A.250605.015 B.1f08cd6_4cba44_4cba45 release-keys
