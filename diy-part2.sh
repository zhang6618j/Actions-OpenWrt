#!/bin/bash
# ==================================================
# DIY PART 2. 修改 OpenWrt 源码中的默认配置文件
# ==================================================

# 1. 修改默认管理地址 (将 192.168.1.1 改为 192.168.8.1)
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate

# 2. 修改默认网络接口配置文件
mkdir -p files/etc/config

cat > files/etc/config/network << 'EOF'
config interface 'loopback'
    option ifname 'lo'
    option proto 'static'
    option ipaddr '127.0.0.1'
    option netmask '255.0.0.0'

config globals 'globals'
    option ula_prefix 'fd08::/48'

config interface 'lan'
    option type 'bridge'
    option ifname 'eth0'
    option proto 'static'
    option ipaddr '192.168.8.1'
    option netmask '255.255.255.0'
    option ip6assign '60'
    list dns '183.221.253.100'
    list dns '211.137.96.205'

config interface 'wan'
    option ifname 'eth1'
    option proto 'pppoe'
    option username '15882125003'
    option password '125003'
    option ipv6 '1'
    option peerdns '0'
    list dns '114.114.114.114'
    list dns '223.5.5.5'
    list dns '8.8.8.8'

config interface 'wan6'
    option ifname 'eth1'
    option proto 'dhcpv6'
EOF

# 3. 修改默认 opkg 软件源为阿里云
mkdir -p files/etc/opkg
cat > files/etc/opkg/distfeeds.conf << 'EOF'
src/gz openwrt_base https://mirrors.aliyun.com/openwrt/snapshots/packages/x86_64/base
src/gz openwrt_luci https://mirrors.aliyun.com/openwrt/snapshots/packages/x86_64/luci
src/gz openwrt_packages https://mirrors.aliyun.com/openwrt/snapshots/packages/x86_64/packages
src/gz openwrt_routing https://mirrors.aliyun.com/openwrt/snapshots/packages/x86_64/routing
src/gz openwrt_telephony https://mirrors.aliyun.com/openwrt/snapshots/packages/x86_64/telephony
EOF

echo "✅ DIY Part 2 执行完成：IP、接口、PPPoE、DNS、阿里云源已配置。"
