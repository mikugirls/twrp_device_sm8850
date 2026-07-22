# patches/myron — 红米 K90 Pro Max

本目录只保存 Myron 专用的 recovery init 映射、MTP/ADB 组合模式和密钥升级拒绝保护。

Myron 保留已验证的 TWRP vold 基线，不覆盖完整 `Decrypt.cpp` 或 `KeyStorage.cpp`，也不绑定、修改 `/data/misc/keystore`。设备树在 KeyMint 启动前提供与当前系统一致的 Android 版本、系统补丁和 vendor 补丁值。若 KeyMint 仍返回升级 blob，解密立即中止，升级结果不会写入 `/metadata`、`/data` 或 `/tmp`。

`mtp_composite.patch` 只为 Myron 使用 `twrp_mtp_adb`，公共源码和其他机型继续使用标准 `mtp,adb`。请勿把 Neo8 或 Nezha 的 vold、MTP、Weaver 或密钥环境代码混入 Myron。
