#!/bin/bash

# دانلود فایل base_xray_config.json.j2
wget https://raw.githubusercontent.com/hiddify/HiddifyPanel/refs/heads/main/hiddifypanel/panel/user/templates/base_xray_config.json.j2
clear
# تغییر مقدار خط 15-34-6 از true به false
sed -i '6s/warning/none/' base_xray_config.json.j2
sed -i '15s/true/false/' base_xray_config.json.j2
sed -i '34s/true/false/' base_xray_config.json.j2
clear
# پیشنهادات برای جایگزینی عبارت tlshello در خط 56
echo "mizan packets fragment ra vared va ya az zir entekhab konid:"
options_tlshello=("tlshello" "1-1" "1-2" "1-3")

select tlshello in "${options_tlshello[@]}" "mizan del khah ra vared konid"; do
    if [[ $REPLY -eq ${#options_tlshello[@]}+1 ]]; then
        read -p "lodfan mizan del khah ra vared konid: " custom_tlshello
        tlshello=$custom_tlshello
        echo "shoma mizan del khah khod ra vared kardid: $tlshello"
        break
    elif [[ -n "$tlshello" ]]; then
        echo "shoma gozine zir ra entekhab kardid: $tlshello"
        break
    else
        echo "lotfan gozine motabar ra vared konid."
    fi
done

# تغییر عبارت tlshello در خط 56
sed -i "56s/tlshello/$tlshello/" base_xray_config.json.j2
clear
# پیشنهادات برای جایگزینی عبارت {{ hconfig(ConfigEnum.tls_fragment_size) }} در خط 57
echo "mizan length fragment ra vared va ya az zir entekhab konid:"
options_tlsfragment=("5" "4-9" "3-5" "10-19")

select tlsfragment in "${options_tlsfragment[@]}" "mizan del khah ra vared konid"; do
    if [[ $REPLY -eq ${#options_tlsfragment[@]}+1 ]]; then
        read -p "lodfan mizan del khah ra vared konid: " custom_tlsfragment
        tlsfragment=$custom_tlsfragment
        echo "shoma mizan del khah khod ra vared kardid: $tlsfragment"
        break
    elif [[ -n "$tlsfragment" ]]; then
        echo "shoma gozine zir ra entekhab kardid: $tlsfragment"
        break
    else
        echo "lotfan gozine motabar ra vared konid."
    fi
done

# تغییر عبارت {{ hconfig(ConfigEnum.tls_fragment_size) }} در خط 57
sed -i "57s/{{ hconfig(ConfigEnum.tls_fragment_size) }}/$tlsfragment/" base_xray_config.json.j2
clear
# پیشنهادات برای جایگزینی عبارت {{ hconfig(ConfigEnum.tls_fragment_sleep) }} در خط 58
echo "mizan ****interval fragment**** ra vared va ya az zir entekhab konid:"
options_tlsfragment_sleep=("0" "5" "1-2" "3-5")

select tlsfragment_sleep in "${options_tlsfragment_sleep[@]}" "mizan del khah ra vared konid"; do
    if [[ $REPLY -eq ${#options_tlsfragment_sleep[@]}+1 ]]; then
        read -p "lodfan mizan del khah ra vared konid: " custom_tlsfragment_sleep
        tlsfragment_sleep=$custom_tlsfragment_sleep
        echo "shoma mizan del khah khod ra vared kardid: $tlsfragment_sleep"
        break
    elif [[ -n "$tlsfragment_sleep" ]]; then
        echo "shoma gozine zir ra entekhab kardid: $tlsfragment_sleep"
        break
    else
        echo "lotfan gozine motabar ra vared konid."
    fi
done

# تغییر عبارت {{ hconfig(ConfigEnum.tls_fragment_sleep) }} در خط 58
sed -i "58s/{{ hconfig(ConfigEnum.tls_fragment_sleep) }}/$tlsfragment_sleep/" base_xray_config.json.j2
clear
# دانلود فایل user.py
wget https://raw.githubusercontent.com/hiddify/HiddifyPanel/refs/heads/main/hiddifypanel/models/user.py
clear
# پیشنهاد برای تغییر مقدار 1000 در خط 71
echo "mizan hajm pishfarz sakht user jadid ra vared konid be GB :"
read -p "chand gig?: " custom_value

# تغییر مقدار 1000 در خط 71
sed -i "71s/1000/$custom_value/" user.py
clear
# پیشنهاد برای تغییر مقدار 90 در خط 72
echo "mizan rooz pishfarz sakht user jadid ra vared konid be day:"
read -p "chand rooz?: " custom_value_90

# تغییر مقدار 90 در خط 72
sed -i "72s/90/$custom_value_90/" user.py
clear
# کپی کردن فایل user.py به مسیر مورد نظر
sudo cp user.py /opt/hiddify-manager/.venv/lib/python3.10/site-packages/hiddifypanel/models/
clear
# پاک کردن فایل user.py از دایرکتوری فعلی
cd /root
rm -rf user.py
clear
# کپی کردن فایل ویرایش‌شده base_xray_config.json.j2 به مسیر مورد نظر
sudo cp base_xray_config.json.j2 /opt/hiddify-manager/.venv/lib/python3.10/site-packages/hiddifypanel/panel/user/templates/
clear
# پاک کردن فایل base_xray_config.json.j2 از دایرکتوری فعلی
cd /root
rm -rf base_xray_config.json.j2
clear
# اجرای اسکریپت apply_configs.sh برای اعمال تنظیمات
bash /opt/hiddify-manager/apply_configs.sh
