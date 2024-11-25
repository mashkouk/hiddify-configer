#!/bin/bash

# نصب resolvconf
sudo apt update
sudo apt install -y resolvconf
clear
# دانلود فایل head
wget https://raw.githubusercontent.com/mashkouk/files-hiddify-configer/refs/heads/main/head
clear
# پیشنهادات برای خط 5
echo "yek gozine baraye dns1 entekhab konid:"
options_line5=("nameserver 8.8.8.8" "nameserver 8.8.4.4" "nameserver 9.9.9.9" "nameserver 1.1.1.1" "nameserver 1.0.0.1")
select line5 in "${options_line5[@]}"; do
    if [[ -n "$line5" ]]; then
        echo "shoma entekhab kardid: $line5"
        break
    else
        echo "lotfan yek gozine motabar vared konid."
    fi
done
clear
# پیشنهادات برای خط 6
echo "yek gozine baraye dns2 entekhab konid:"
options_line6=("nameserver 8.8.8.8" "nameserver 8.8.4.4" "nameserver 9.9.9.9" "nameserver 1.1.1.1" "nameserver 1.0.0.1")
select line6 in "${options_line6[@]}"; do
    if [[ -n "$line6" ]]; then
        echo "shoma entekhab kardid: $line6"
        break
    else
        echo "lotfan yek gozine motabar vared konid."
    fi
done
clear
# پیشنهادات برای خط 7
echo "yek gozine baraye dns1 entekhab konid:"
options_line7=("nameserver 8.8.8.8" "nameserver 8.8.4.4" "nameserver 9.9.9.9" "nameserver 1.1.1.1" "nameserver 1.0.0.1")
select line7 in "${options_line7[@]}"; do
    if [[ -n "$line7" ]]; then
        echo "shoma entekhab kardid: $line7"
        break
    else
        echo "lotfan yek gozine motabar vared konid."
    fi
done
clear
# جایگزینی خطوط 5، 6 و 7 در فایل head
sed -i "5s/.*/$line5/" head
sed -i "6s/.*/$line6/" head
sed -i "7s/.*/$line7/" head
clear
# کپی کردن فایل به مسیر /etc/resolvconf/resolv.conf.d/
sudo cp head /etc/resolvconf/resolv.conf.d/
clear
# پاک کردن فایل head از مسیر فعلی
rm -f head
clear
echo "baraye anjam taghirat server ra reboot konid"

# گزینه ری‌استارت برای کاربر
while true; do
    read -p "aya server reboot shavad ? (y/n): " yn
    case $yn in
        [Yy]* ) sudo reboot; break;;
        [Nn]* ) exit;;
        * ) echo "lotfan faghat n ya y ra vared konid ";;
    esac
done
