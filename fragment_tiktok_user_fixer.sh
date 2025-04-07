#!/bin/bash

clear
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " لطفاً نوع پیکربندی را انتخاب کنید:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1) 🟢 استفاده از مقادیر پیش‌فرض بهینه"
echo "2) ⚙️  وارد کردن تنظیمات دلخواه"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -p "➤ شماره گزینه مورد نظر را وارد کنید (1 یا 2): " config_choice

if [[ "$config_choice" == "1" ]]; then
    echo "📥 در حال دانلود فایل‌های پیکربندی پیش‌فرض..."
    
    wget -q --show-progress -O base_xray_config.json.j2 https://raw.githubusercontent.com/mashkouk/files-hiddify-configer/refs/heads/main/base_xray_config.json.j2
    sudo cp base_xray_config.json.j2 /opt/hiddify-manager/.venv/lib/python3.10/site-packages/hiddifypanel/panel/user/templates/
    rm -f base_xray_config.json.j2

    wget -q --show-progress -O xrayjson.py https://raw.githubusercontent.com/mashkouk/files-hiddify-configer/refs/heads/main/xrayjson.py
    sudo cp xrayjson.py /opt/hiddify-manager/.venv/lib/python3.10/site-packages/hiddifypanel/hutils/proxy/
    rm -f xrayjson.py

    echo "✅ پیکربندی پیش‌فرض به درستی اعمال شد."
    echo "🚀 اجرای apply_configs.sh ..."
    bash /opt/hiddify-manager/apply_configs.sh
    exit 0

elif [[ "$config_choice" != "2" ]]; then
    echo "❌ گزینه نامعتبر وارد شده است. لطفاً فقط عدد 1 یا 2 را وارد کنید."
    exit 1
fi

# -------------------------------
# در ادامه فقط اگر گزینه ۲ انتخاب شده باشد، تنظیمات دلخواه اجرا می‌شوند
# -------------------------------

# دانلود فایل base_xray_config.json.j2
wget https://raw.githubusercontent.com/hiddify/HiddifyPanel/refs/heads/main/hiddifypanel/panel/user/templates/base_xray_config.json.j2
clear

# تغییر مقدار خط 15-34-6 از true به false
sed -i '15s/true/false/' base_xray_config.json.j2

# حذف خطوط از 68 به بعد و اضافه کردن مقادیر جدید
sed -i '68,$d' base_xray_config.json.j2
echo '    }
  ],
  "routing": {
    "domainStrategy": "AsIs",
    "rules": []
  }
}' >> base_xray_config.json.j2
clear

# پیشنهادات برای جایگزینی عبارت tlshello در خط 56
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " لطفاً مقدار packets fragment را انتخاب کنید:"
options_tlshello=("tlshello" "1-1" "1-2" "1-3")

select tlshello in "${options_tlshello[@]}" "⏺ وارد کردن مقدار دلخواه"; do
    if [[ $REPLY -eq ${#options_tlshello[@]}+1 ]]; then
        read -p "➤ لطفاً مقدار دلخواه را وارد کنید: " custom_tlshello
        tlshello=$custom_tlshello
        echo "✅ مقدار دلخواه انتخاب شد: $tlshello"
        break
    elif [[ -n "$tlshello" ]]; then
        echo "✅ گزینه انتخاب‌شده: $tlshello"
        break
    else
        echo "❌ لطفاً گزینه معتبر وارد کنید."
    fi
done

# تغییر عبارت tlshello در خط 56
sed -i "56s/tlshello/$tlshello/" base_xray_config.json.j2
clear

# پیشنهادات برای tls_fragment_size
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " لطفاً مقدار length fragment را انتخاب کنید:"
options_tlsfragment=("5" "4-9" "3-5" "10-19")

select tlsfragment in "${options_tlsfragment[@]}" "⏺ وارد کردن مقدار دلخواه"; do
    if [[ $REPLY -eq ${#options_tlsfragment[@]}+1 ]]; then
        read -p "➤ لطفاً مقدار دلخواه را وارد کنید: " custom_tlsfragment
        tlsfragment=$custom_tlsfragment
        echo "✅ مقدار دلخواه انتخاب شد: $tlsfragment"
        break
    elif [[ -n "$tlsfragment" ]]; then
        echo "✅ گزینه انتخاب‌شده: $tlsfragment"
        break
    else
        echo "❌ لطفاً گزینه معتبر وارد کنید."
    fi
done

# تغییر عبارت مربوطه در خط 57
sed -i "57s/{{ hconfig(ConfigEnum.tls_fragment_size) }}/$tlsfragment/" base_xray_config.json.j2
clear

# پیشنهادات برای tls_fragment_sleep
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " لطفاً مقدار interval fragment را انتخاب کنید:"
options_tlsfragment_sleep=("0" "5" "1-2" "3-5")

select tlsfragment_sleep in "${options_tlsfragment_sleep[@]}" "⏺ وارد کردن مقدار دلخواه"; do
    if [[ $REPLY -eq ${#options_tlsfragment_sleep[@]}+1 ]]; then
        read -p "➤ لطفاً مقدار دلخواه را وارد کنید: " custom_tlsfragment_sleep
        tlsfragment_sleep=$custom_tlsfragment_sleep
        echo "✅ مقدار دلخواه انتخاب شد: $tlsfragment_sleep"
        break
    elif [[ -n "$tlsfragment_sleep" ]]; then
        echo "✅ گزینه انتخاب‌شده: $tlsfragment_sleep"
        break
    else
        echo "❌ لطفاً گزینه معتبر وارد کنید."
    fi
done

# اعمال مقدار interval fragment
sed -i "58s/{{ hconfig(ConfigEnum.tls_fragment_sleep) }}/$tlsfragment_sleep/" base_xray_config.json.j2

# حذف خطوط 3 تا 7 و افزودن DNS جدید
sed -i '3,7d' base_xray_config.json.j2
sed -i '3i \
  "dns": {\n    "servers": [\n      "8.8.4.4",\n      "76.76.10.0"\n    ]\n  },' base_xray_config.json.j2
clear

# دانلود فایل user.py
wget https://raw.githubusercontent.com/hiddify/HiddifyPanel/refs/heads/main/hiddifypanel/models/user.py
clear

# مقدار حجم پیش‌فرض
echo "📦 لطفاً حجم پیش‌فرض ساخت یوزر را وارد کنید (به GB):"
read -p "➤ چند گیگ؟ " custom_value
sed -i "71s/1000/$custom_value/" user.py
clear

# مقدار روز پیش‌فرض
echo "🗓 لطفاً تعداد روز پیش‌فرض یوزر را وارد کنید:"
read -p "➤ چند روز؟ " custom_value_90
sed -i "72s/90/$custom_value_90/" user.py
clear

# جایگزینی فایل‌ها
sudo cp user.py /opt/hiddify-manager/.venv/lib/python3.10/site-packages/hiddifypanel/models/
cd /root && rm -f user.py
sudo cp base_xray_config.json.j2 /opt/hiddify-manager/.venv/lib/python3.10/site-packages/hiddifypanel/panel/user/templates/
rm -f base_xray_config.json.j2
clear

# اجرای نهایی
echo "🚀 اجرای apply_configs.sh ..."
bash /opt/hiddify-manager/apply_configs.sh
