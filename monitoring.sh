#!/bin/bash

# 🧱 ARCHITECTURE
arch=$(uname -a)

# 💾 CPU PHYSICAL
cpuf=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)

# 💽 CPU VIRTUAL
cpuv=$(grep -c "^processor" /proc/cpuinfo)

# 🧠 RAM (compatível com sistema em português)
ram_total=$(free --mega | awk 'NR==2 {print $2}')
ram_use=$(free --mega | awk 'NR==2 {print $3}')
ram_percent=$(free --mega | awk 'NR==2 {printf "%.2f", $3/$2*100}')

# 💿 DISK (somando todas as partições, exceto /boot)
disk_total=$(df -m | awk '/^\/dev\// && !/\/boot/ {disk_t += $2} END {printf "%.1fGb", disk_t/1024}')
disk_use=$(df -m | awk '/^\/dev\// && !/\/boot/ {disk_u += $3} END {printf "%d", disk_u}')
disk_percent=$(df -m | awk '/^\/dev\// && !/\/boot/ {disk_u += $3; disk_t += $2} END {printf "%d", disk_u/disk_t*100}')

# ⚙️ CPU LOAD
cpu_idle=$(vmstat 1 2 | tail -1 | awk '{print $15}')

# 🕒 LAST BOOT
lb=$(who -b | awk '{print $3, $4}')

# 🧩 LVM USE
lvmu=$(lsblk | grep -q "lvm" && echo yes || echo no)

# 🌐 TCP CONNECTIONS
tcpc=$(ss -ta state established | wc -l)

# 👤 USER LOGGED
ulog=$(users | wc -w)

# 📡 NETWORK
ip=$(hostname -I | awk '{print $1}')
mac=$(ip link | awk '/link\/ether/ {print $2}')

# 🔑 SUDO COMMANDS
cmnd=$(journalctl _COMM=sudo 2>/dev/null | grep COMMAND | wc -l)

# 🧾 OUTPUT
wall "
🖥️ Architecture: $arch
💾 CPU physical: $cpuf
⚙️ vCPU: $cpuv
🧠 Memory Usage: ${ram_use}/${ram_total}MB (${ram_percent}%)
💿 Disk Usage: ${disk_use}/${disk_total} (${disk_percent}%)
🔥 CPU load: ${cpu_load}%
🕒 Last boot: $lb
🧩 LVM use: $lvmu
🌐 Connections TCP: $tcpc ESTABLISHED
👤 User log: $ulog
📡 Network: IP $ip ($mac)
🔑 Sudo: $cmnd cmd
"
