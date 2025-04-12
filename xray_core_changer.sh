#!/bin/bash

# Stop kardan service-ha
service hiddify-xray stop
service hiddify-haproxy stop
clear

echo "🔍 Dar hal-e tashkhis-e me'mari-ye system..."
arch=$(uname -m)
case $arch in
    x86_64)
        arch_name="64"
        ;;
    aarch64)
        arch_name="arm64-v8a"
        ;;
    *)
        echo "❌ Me'mari-ye system poshtibani nemishavad: $arch"
        exit 1
        ;;
esac

# Gereftan-e akharin version az GitHub
echo "🌐 Dar hal-e gereftan-e akharin version Xray-core az GitHub..."
latest_version=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep tag_name | cut -d '"' -f4)

# Sakhte link bar asas-e me'mari
latest_link="https://github.com/XTLS/Xray-core/releases/download/${latest_version}/Xray-linux-${arch_name}.zip"

# List-e pishnahadi az link-ha
options_links=(
    "$latest_link"
    "https://github.com/GFW-knocker/Xray-core/releases/download/v1.8.23-mahsa-r3/Xray-linux-${arch_name}.zip"
    "https://github.com/XTLS/Xray-core/releases/download/v24.9.30/Xray-linux-${arch_name}.zip"
)

echo ""
echo "📦 Lotfan yeki az gozine-haye zir ra baraye download-e hast-e Xray entekhab konid:"
echo "────────────────────────────────────────────"
for i in "${!options_links[@]}"; do
    echo " $((i+1)). 🔗 ${options_links[$i]}"
done
echo " $(( ${#options_links[@]} + 1 )). ✏️  Vared kardan-e link-e delkhah"
echo "────────────────────────────────────────────"

# Gereftan-e entekhab az karbar
while true; do
    read -p "👉 Shomare-ye gozine-ye mored nazar ra vared konid: " choice
    if [[ "$choice" -ge 1 && "$choice" -le ${#options_links[@]} ]]; then
        link="${options_links[$((choice-1))]}"
        echo "✅ Shoma link-e zir ra entekhab kardid:"
        echo "$link"
        break
    elif [[ "$choice" -eq $(( ${#options_links[@]} + 1 )) ]]; then
        read -p "✍️ Lotfan link-e delkhah-e khod ra vared konid: " custom_link
        link=$custom_link
        echo "✅ Link-e delkhah-e shoma: $link"
        break
    else
        echo "❗ Lotfan gozine-ye sahih vared konid."
    fi
done

# Edame-ye nasb
clear
echo "🧹 Dar hal-e pak kardan-e file-haye ghabli..."
rm -rf /opt/hiddify-manager/xray/bin/*

echo "⬇️ Dar hal-e download-e file Xray..."
wget "$link" -O xray.zip || { echo "❌ Download ba moshkel movajeh shod."; exit 1; }

echo "🗂️ Dar hal-e extract kardan-e file..."
unzip xray.zip -d /opt/hiddify-manager/xray/bin/

echo "🧽 Dar hal-e hazf-e file-e zip..."
rm xray.zip

echo "🔐 Dadan-e dastresi-ye ejraei..."
chmod +x /opt/hiddify-manager/xray/bin/xray

# Ejra-ye script-haye restart
echo "🚀 Dar hal-e restart-e service-ha..."
bash /opt/hiddify-manager/restart.sh
bash /opt/hiddify-manager/apply_configs.sh

# Pishnahad-e reboot
read -p "🔁 Aya mikhahid system ra reboot konid? (y/n): " restart_ans
if [[ "$restart_ans" == "y" ]]; then
    sudo reboot
fi
