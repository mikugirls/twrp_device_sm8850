#!/system/bin/sh

IFACE="${interface:-wlan0}"
LEASE_FILE=/tmp/recovery/wifi-dhcp.lease
IP_BIN=/system/bin/ip

mask_to_prefix() {
    case "$1" in
        255.255.255.252) echo 30 ;;
        255.255.255.248) echo 29 ;;
        255.255.255.240) echo 28 ;;
        255.255.255.224) echo 27 ;;
        255.255.255.192) echo 26 ;;
        255.255.255.128) echo 25 ;;
        255.255.255.0) echo 24 ;;
        255.255.254.0) echo 23 ;;
        255.255.252.0) echo 22 ;;
        255.255.248.0) echo 21 ;;
        255.255.240.0) echo 20 ;;
        255.255.224.0) echo 19 ;;
        255.255.192.0) echo 18 ;;
        255.255.128.0) echo 17 ;;
        255.255.0.0) echo 16 ;;
        *) echo 24 ;;
    esac
}

case "$1" in
    deconfig)
        rm -f "$LEASE_FILE"
        "$IP_BIN" addr flush dev "$IFACE"
        "$IP_BIN" link set "$IFACE" up
        ;;
    bound|renew)
        PREFIX="$(mask_to_prefix "$subnet")"
        ROUTER="${router%% *}"
        DNS1="${dns%% *}"
        DNS_REST="${dns#* }"
        DNS2="${DNS_REST%% *}"

        "$IP_BIN" addr flush dev "$IFACE" || exit 1
        "$IP_BIN" addr add "$ip/$PREFIX" dev "$IFACE" || exit 1
        "$IP_BIN" link set "$IFACE" up || exit 1
        if [ -n "$ROUTER" ]; then
            "$IP_BIN" route replace default via "$ROUTER" dev "$IFACE" || exit 1
        fi

        mkdir -p /etc /tmp/recovery
        : > /etc/resolv.conf
        if [ -n "$DNS1" ]; then
            echo "nameserver $DNS1" >> /etc/resolv.conf
            setprop net.dns1 "$DNS1"
        fi
        if [ -n "$DNS2" ] && [ "$DNS2" != "$DNS1" ]; then
            echo "nameserver $DNS2" >> /etc/resolv.conf
            setprop net.dns2 "$DNS2"
        fi

        {
            echo "ip=$ip"
            echo "gateway=$ROUTER"
            echo "dns=$dns"
        } > "$LEASE_FILE.tmp"
        mv -f "$LEASE_FILE.tmp" "$LEASE_FILE"
        ;;
esac

exit 0
