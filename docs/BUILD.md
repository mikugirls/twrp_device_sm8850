# Build Guide

## Environment

**Recommended:** WSL2 + Ubuntu 24.04

## Prerequisites

```bash
sudo apt update
sudo apt install -y git-core gnupg flex bison build-essential zip curl \
    zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
    libncurses5-dev lib32ncurses5-dev x11proto-core-dev libx11-dev \
    lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig \
    repo bc ccache
```

## Initialize TWRP Source

```bash
mkdir -p ~/android/twrp && cd ~/android/twrp
repo init -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-16
repo sync -c --no-tags --no-clone-bundle -j$(nproc)
```

## Clone This Repository

```bash
cd ~/android/twrp
git clone https://github.com/MissMyTime/TWRP-SM8850.git
```

## Apply Source Changes

```bash
cd ~/android/twrp
TWRP-SM8850/scripts/apply-patches.sh .
```

This script will:
1. Apply git patches from `source_changes/patches/`
2. Copy modified source files from `source_changes/files/`

## Build

```bash
source build/envsetup.sh
lunch twrp_<codename>-eng
mka recoveryimage
```

Example for realme Neo8:
```bash
lunch twrp_RE6402L1-eng
mka recoveryimage
```

Output path:
```
out/target/product/<codename>/recovery.img
```

## Flash

```bash
fastboot flash recovery recovery.img
```

Or temporarily boot:
```bash
fastboot boot recovery.img
```

## Troubleshooting

### WSL2 Out of Memory

Create `~/.wslconfig`:
```ini
[wsl2]
memory=64GB
swap=32GB
processors=16
```

### Symlinks on Windows

If you cloned this repo on Windows and then copied to WSL2, symbolic links in `device/<vendor>/<codename>/recovery/root/odm/` may be broken. On WSL2, re-clone or use:
```bash
git config core.symlinks true
git checkout .
```
