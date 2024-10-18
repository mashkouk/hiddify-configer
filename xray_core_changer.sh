#!/bin/bash

# توقف سرویس‌های hiddify-xray و hiddify-haproxy
service hiddify-xray stop
service hiddify-haproxy stop

# پیشنهاد لینک‌های دانلود هسته XRay به کاربر
echo "lotfan link haste khod ra vard konid ya az pishnahadat zir yeki ra entekhab konid:"
options_links=("https://github.com/GFW-knocker/Xray-core/releases/download/v1.8.23-mahsa-r3/Xray-linux-arm64-v8a.zip" \
               "https://github.com/XTLS/Xray-core/releases/download/v24.9.30/Xray-linux-arm64-v8a.zip" \
               "https://github.com/GFW-knocker/Xray-core/releases/download/v1.8.23-mahsa-r3/Xray-linux-64.zip" \
               "https://github.com/XTLS/Xray-core/releases/download/v24.9.30/Xray-linux-64.zip")

# نمایش گزینه‌های پیشنهادی به کاربر
select link in "${options_links[@]}" "link del khah khod ra vared konid"; do
    if [[ $REPLY -eq ${#options_links[@]}+1 ]]; then
        # اگر کاربر گزینه "لینک دلخواه وارد کنید" را انتخاب کرد
        read -p "lotfan link khod ra vared konid: " custom_link
        link=$custom_link
        echo "shoma link del khah khod ra vared kardid: $link"
        break
    elif [[ -n "$link" ]]; then
        # اگر کاربر یکی از گزینه‌های پیشنهادی را انتخاب کرد
        echo "shoma link zir ra entekhab kardid: $link"
        break
    else
        # اگر ورودی معتبر نباشد
        echo "lotfan gozine sahih ra vared konid."
    fi
done

# حذف محتوای فعلی در پوشه XRay
rm -rf /opt/hiddify-manager/xray/bin/*

# دانلود فایل XRay از لینکی که کاربر انتخاب یا وارد کرده است
wget "$link" -O xray.zip

# از حالت فشرده خارج کردن فایل XRay
unzip xray.zip -d /opt/hiddify-manager/xray/bin/

# حذف فایل فشرده
rm xray.zip

# اعطای دسترسی اجرایی به فایل XRay
chmod +x /opt/hiddify-manager/xray/bin/xray

# اجرای اسکریپت‌های راه‌اندازی و اعمال تنظیمات
bash /opt/hiddify-manager/restart.sh
bash /opt/hiddify-manager/apply_configs.sh

# ری‌استارت سیستم برای اعمال تغییرات
# sudo reboot
