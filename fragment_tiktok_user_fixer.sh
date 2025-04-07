#!/bin/bash

clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Lotfan noe config ra entekhab konid:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1) 🟢 Estefade az maghadir pishfarz va behine"
echo "2) ⚙️  Vared kardan tanzimate delkhah"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -p "➤ Shomare gozine morede nazar ra vared konid (1 ya 2): " config_choice

if [[ "$config_choice" == "1" ]]; then
    echo "📥 Dar hal download filehaye config pishfarz..."

    wget -q --show-progress -O base_xray_config.json.j2 https://raw.githubusercontent.com/mashkouk/files-hiddify-configer/refs/heads/main/base_xray_config.json.j2
    sudo cp base_xray_config.json.j2 /opt/hiddify-manager/.venv/lib/python3.10/site-packages/hiddifypanel/panel/user/templates/
    rm -f base_xray_config.json.j2

    wget -q --show-progress -O xrayjson.py https://raw.githubusercontent.com/mashkouk/files-hiddify-configer/refs/heads/main/xrayjson.py
    sudo cp xrayjson.py /opt/hiddify-manager/.venv/lib/python3.10/site-packages/hiddifypanel/hutils/proxy/
    rm -f xrayjson.py

    echo "✅ Config pishfarz ba movafaghiat emal shod."
    echo "🚀 Ejra-ye apply_configs.sh ..."
    bash /opt/hiddify-manager/apply_configs.sh
    exit 0

elif [[ "$config_choice" != "2" ]]; then
    echo "❌ Gozine na motabar. Lotfan faghat 1 ya 2 ra vared konid."
    exit 1
fi

# Edame baraye gozine 2 (tanzimate delkhah)

# Download file base_xray_config.json.j2
wget https://raw.githubusercontent.com/hiddify/HiddifyPanel/refs/heads/main/hiddifypanel/panel/user/templates/base_xray_config.json.j2
clear

# Taghir meghdar khat 15 az true be false
sed -i '15s/true/false/' base_xray_config.json.j2

# Hazf khotoot az 68 be baad va ezafe kardan meghdar jadid
sed -i '68,$d' base_xray_config.json.j2
echo '    }
  ],
  "routing": {
    "domainStrategy": "AsIs",
    "rules": []
  }
}' >> base_xray_config.json.j2
clear

# Entkhab packet fragment
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Lotfan meghdar packets fragment ra entekhab konid:"
options_tlshello=("tlshello" "1-1" "1-2" "1-3")

select tlshello in "${options_tlshello[@]}" "⏺ Vared kardan meghdar delkhah"; do
    if [[ $REPLY -eq ${#options_tlshello[@]}+1 ]]; then
        read -p "➤ Meghdar delkhah ra vared konid: " custom_tlshello
        tlshello=$custom_tlshello
        echo "✅ Meghdar delkhah entekhab shod: $tlshello"
        break
    elif [[ -n "$tlshello" ]]; then
        echo "✅ Gozine entekhab shode: $tlshello"
        break
    else
        echo "❌ Lotfan gozine sahih entekhab konid."
    fi
done

sed -i "56s/tlshello/$tlshello/" base_xray_config.json.j2
clear

# Fragment length
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Lotfan length fragment ra entekhab konid:"
options_tlsfragment=("5" "4-9" "3-5" "10-19")

select tlsfragment in "${options_tlsfragment[@]}" "⏺ Meghdar delkhah"; do
    if [[ $REPLY -eq ${#options_tlsfragment[@]}+1 ]]; then
        read -p "➤ Meghdar delkhah ra vared konid: " custom_tlsfragment
        tlsfragment=$custom_tlsfragment
        echo "✅ $tlsfragment entekhab shod"
        break
    elif [[ -n "$tlsfragment" ]]; then
        echo "✅ Gozine entekhab shode: $tlsfragment"
        break
    else
        echo "❌ Lotfan gozine motabar entekhab konid."
    fi
done

sed -i "57s/{{ hconfig(ConfigEnum.tls_fragment_size) }}/$tlsfragment/" base_xray_config.json.j2
clear

# Fragment interval
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Lotfan interval fragment ra entekhab konid:"
options_tlsfragment_sleep=("0" "5" "1-2" "3-5")

select tlsfragment_sleep in "${options_tlsfragment_sleep[@]}" "⏺ Meghdar delkhah"; do
    if [[ $REPLY -eq ${#options_tlsfragment_sleep[@]}+1 ]]; then
        read -p "➤ Meghdar delkhah ra vared konid: " custom_tlsfragment_sleep
        tlsfragment_sleep=$custom_tlsfragment_sleep
        echo "✅ $tlsfragment_sleep entekhab shod"
        break
    elif [[ -n "$tlsfragment_sleep" ]]; then
        echo "✅ Gozine entekhab shode: $tlsfragment_sleep"
        break
    else
        echo "❌ Lotfan gozine dorost entekhab konid."
    fi
done

sed -i "58s/{{ hconfig(ConfigEnum.tls_fragment_sleep) }}/$tlsfragment_sleep/" base_xray_config.json.j2

# Hazf khat ha va ezafe kardan DNS
sed -i '3,7d' base_xray_config.json.j2
sed -i '3i \
  "dns": {\n    "servers": [\n      "8.8.4.4",\n      "76.76.10.0"\n    ]\n  },' base_xray_config.json.j2
clear

# Download user.py
wget https://raw.githubusercontent.com/hiddify/HiddifyPanel/refs/heads/main/hiddifypanel/models/user.py
clear

# Entkhab volume default baraye user
echo "📦 Lotfan meghdar GB default baraye user ra vared konid:"
read -p "➤ Chand gig? " custom_value
sed -i "71s/1000/$custom_value/" user.py
clear

# Entkhab rooz default
echo "🗓 Lotfan tedad rooz default baraye user ra vared konid:"
read -p "➤ Chand rooz? " custom_value_90
sed -i "72s/90/$custom_value_90/" user.py
clear

# Copy va pak sazi
sudo cp user.py /opt/hiddify-manager/.venv/lib/python3.10/site-packages/hiddifypanel/models/
cd /root && rm -f user.py
sudo cp base_xray_config.json.j2 /opt/hiddify-manager/.venv/lib/python3.10/site-packages/hiddifypanel/panel/user/templates/
rm -f base_xray_config.json.j2
clear

# Ejra
echo "🚀 Dar hale ejra-ye apply_configs.sh ..."
bash /opt/hiddify-manager/apply_configs.sh
