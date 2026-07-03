#include <aidl/android/hardware/wifi/IWifi.h>
#include <aidl/android/hardware/wifi/IWifiChip.h>
#include <aidl/android/hardware/wifi/IWifiStaIface.h>
#include <aidl/android/hardware/wifi/IfaceConcurrencyType.h>
#include <android/binder_manager.h>

#include <algorithm>
#include <chrono>
#include <cstdio>
#include <memory>
#include <string>
#include <thread>
#include <vector>

using aidl::android::hardware::wifi::IfaceConcurrencyType;
using aidl::android::hardware::wifi::IWifi;
using aidl::android::hardware::wifi::IWifiChip;
using aidl::android::hardware::wifi::IWifiStaIface;

namespace {

constexpr const char* kWifiInstance = "android.hardware.wifi.IWifi/default";

void printStatus(const char* operation, const ndk::ScopedAStatus& status) {
    std::fprintf(stderr, "%s failed: %s\n", operation, status.getDescription().c_str());
}

std::shared_ptr<IWifi> waitForWifi() {
    for (int attempt = 0; attempt < 100; ++attempt) {
        ndk::SpAIBinder binder(AServiceManager_checkService(kWifiInstance));
        if (binder.get() != nullptr) {
            return IWifi::fromBinder(binder);
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(200));
    }
    std::fprintf(stderr, "Timed out waiting for %s\n", kWifiInstance);
    return nullptr;
}

bool findStaMode(const std::vector<IWifiChip::ChipMode>& modes, int* modeId) {
    for (const auto& mode : modes) {
        for (const auto& combination : mode.availableCombinations) {
            for (const auto& limit : combination.limits) {
                if (std::find(limit.types.begin(), limit.types.end(),
                              IfaceConcurrencyType::STA) != limit.types.end()) {
                    *modeId = mode.id;
                    return true;
                }
            }
        }
    }
    return false;
}

int startSta() {
    auto wifi = waitForWifi();
    if (!wifi) {
        return 2;
    }

    auto status = wifi->start();
    if (!status.isOk()) {
        printStatus("IWifi.start", status);
        return 3;
    }

    std::vector<int32_t> chipIds;
    status = wifi->getChipIds(&chipIds);
    if (!status.isOk() || chipIds.empty()) {
        if (!status.isOk()) {
            printStatus("IWifi.getChipIds", status);
        } else {
            std::fprintf(stderr, "IWifi.getChipIds returned no chips\n");
        }
        return 4;
    }

    std::shared_ptr<IWifiChip> chip;
    status = wifi->getChip(chipIds.front(), &chip);
    if (!status.isOk() || !chip) {
        printStatus("IWifi.getChip", status);
        return 5;
    }

    std::vector<std::string> existingNames;
    status = chip->getStaIfaceNames(&existingNames);
    if (status.isOk() && !existingNames.empty()) {
        std::printf("STA interface already exists: %s\n", existingNames.front().c_str());
        return 0;
    }

    std::vector<IWifiChip::ChipMode> modes;
    status = chip->getAvailableModes(&modes);
    if (!status.isOk()) {
        printStatus("IWifiChip.getAvailableModes", status);
        return 6;
    }

    int modeId = -1;
    if (!findStaMode(modes, &modeId)) {
        std::fprintf(stderr, "No chip mode supports a STA interface\n");
        return 7;
    }

    status = chip->configureChip(modeId);
    if (!status.isOk()) {
        printStatus("IWifiChip.configureChip", status);
        return 8;
    }

    std::shared_ptr<IWifiStaIface> iface;
    status = chip->createStaIface(&iface);
    if (!status.isOk() || !iface) {
        printStatus("IWifiChip.createStaIface", status);
        return 9;
    }

    std::string name;
    status = iface->getName(&name);
    if (!status.isOk()) {
        printStatus("IWifiStaIface.getName", status);
        return 10;
    }

    std::printf("STA interface created: %s\n", name.c_str());
    return 0;
}

int showStatus() {
    auto wifi = waitForWifi();
    if (!wifi) {
        return 2;
    }
    bool started = false;
    auto status = wifi->isStarted(&started);
    if (!status.isOk()) {
        printStatus("IWifi.isStarted", status);
        return 3;
    }
    std::printf("Wi-Fi HAL started: %s\n", started ? "yes" : "no");
    return started ? 0 : 1;
}

int stopWifi() {
    auto wifi = waitForWifi();
    if (!wifi) {
        return 2;
    }
    auto status = wifi->stop();
    if (!status.isOk()) {
        printStatus("IWifi.stop", status);
        return 3;
    }
    std::printf("Wi-Fi HAL stopped\n");
    return 0;
}

}  // namespace

int main(int argc, char** argv) {
    const std::string command = argc > 1 ? argv[1] : "start-sta";
    if (command == "start-sta") {
        return startSta();
    }
    if (command == "status") {
        return showStatus();
    }
    if (command == "stop") {
        return stopWifi();
    }
    std::fprintf(stderr, "Usage: %s [start-sta|status|stop]\n", argv[0]);
    return 64;
}
