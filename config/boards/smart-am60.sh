# shellcheck shell=bash

export BOARD_NAME="Smart AM60"
export BOARD_MAKER="Smart"
export BOARD_SOC="Rockchip RK3588"
export BOARD_CPU="ARM Cortex A76 / A55"
export UBOOT_PACKAGE="u-boot-radxa-rk3588"
export UBOOT_RULES_TARGET="smart-am60-rk3588"
export COMPATIBLE_SUITES=("noble")
export COMPATIBLE_FLAVORS=("server" "desktop")

function config_image_hook__smart-am60() {
    local rootfs="$1"
    local overlay="$2"
    local suite="$3"

    if [ "${suite}" == "jammy" ] || [ "${suite}" == "noble" ]; then
        # Install panfork
        chroot "${rootfs}" add-apt-repository -y ppa:jjriek/panfork-mesa
        chroot "${rootfs}" apt-get update
        chroot "${rootfs}" apt-get -y install mali-g610-firmware
        chroot "${rootfs}" apt-get -y dist-upgrade

        # Install libmali blobs alongside panfork
        chroot "${rootfs}" apt-get -y install libmali-g610-x11

        # Install the rockchip camera engine
        # chroot "${rootfs}" apt-get -y install camera-engine-rkaiq-rk3588
        
        # Add Wifi & BT module
        cp -r "${overlay}/firmware/ap6276p/"* "${rootfs}/usr/lib/firmware/ap6275p/"
    fi

    return 0
}
