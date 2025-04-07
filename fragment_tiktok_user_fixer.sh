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
options_tlshello=("1) tlshello" "2) 1-1" "3) 1-2" "4) 1-3" "5) Meghdar delkhah")

select tlshello in "${options_tlshello[@]}"; do
    case $REPLY in
        1) tlshello="tlshello";;
        2) tlshello="1-1";;
        3) tlshello="1-2";;
        4) tlshello="1-3";;
        5) read -p "➤ Lotfan meghdar delkhah ra vared konid: " tlshello;;
        *) echo "❌ Lotfan adad sahih vared konid."; continue;;
    esac
    echo "✅ $tlshello entekhab shod."
    break
done

sed -i "56s/tlshello/$tlshello/" base_xray_config.json.j2
clear

# Fragment length
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Lotfan length fragment ra entekhab konid:"
options_tlsfragment=("1) 5" "2) 4-9" "3) 3-5" "4) 10-19" "5) Meghdar delkhah")

select tlsfragment in "${options_tlsfragment[@]}"; do
    case $REPLY in
        1) tlsfragment="5";;
        2) tlsfragment="4-9";;
        3) tlsfragment="3-5";;
        4) tlsfragment="10-19";;
        5) read -p "➤ Lotfan meghdar delkhah ra vared konid: " tlsfragment;;
        *) echo "❌ Adad sahih vared konid."; continue;;
    esac
    echo "✅ $tlsfragment entekhab shod."
    break
done

sed -i "57s/{{ hconfig(ConfigEnum.tls_fragment_size) }}/$tlsfragment/" base_xray_config.json.j2
clear

# Fragment interval
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Lotfan interval fragment ra entekhab konid:"
options_tlsfragment_sleep=("1) 0" "2) 5" "3) 1-2" "4) 3-5" "5) Meghdar delkhah")

select tlsfragment_sleep in "${options_tlsfragment_sleep[@]}"; do
    case $REPLY in
        1) tlsfragment_sleep="0";;
        2) tlsfragment_sleep="5";;
        3) tlsfragment_sleep="1-2";;
        4) tlsfragment_sleep="3-5";;
        5) read -p "➤ Lotfan meghdar delkhah ra vared konid: " tlsfragment_sleep;;
        *) echo "❌ Adad sahih vared konid."; continue;;
    esac
    echo "✅ $tlsfragment_sleep entekhab shod."
    break
done

sed -i "58s/{{ hconfig(ConfigEnum.tls_fragment_sleep) }}/$tlsfragment_sleep/" base_xray_config.json.j2

# DNS taghir
sed -i '3,7d' base_xray_config.json.j2
sed -i '3i \
  "dns": {\n    "servers": [\n      "8.8.4.4",\n      "76.76.10.0"\n    ]\n  },' base_xray_config.json.j2
clear

# Download user.py
wget https://raw.githubusercontent.com/hiddify/HiddifyPanel/refs/heads/main/hiddifypanel/models/user.py
clear

# GB baraye user
echo "📦 Lotfan meghdar GB default baraye user ra vared konid:"
read -p "➤ Chand gig? " custom_value
sed -i "71s/1000/$custom_value/" user.py
clear

# Rooz baraye user
echo "🗓 Lotfan tedad rooz default baraye user ra vared konid:"
read -p "➤ Chand rooz? " custom_value_90
sed -i "72s/90/$custom_value_90/" user.py
clear

# Copy & Clean
sudo cp user.py /opt/hiddify-manager/.venv/lib/python3.10/site-packages/hiddifypanel/models/
cd /root && rm -f user.py
sudo cp base_xray_config.json.j2 /opt/hiddify-manager/.venv/lib/python3.10/site-packages/hiddifypanel/panel/user/templates/
rm -f base_xray_config.json.j2
clear

# Ejra
echo "🚀 Dar hale ejra-ye apply_configs.sh ..."
bash /opt/hiddify-manager/apply_configs.sh
