#!/bin/bash

# خط مورد نظر برای کرون
CRON_JOB="12 * * * * bash /opt/hiddify-manager/apply_configs.sh --no-gui --no-log"

# بررسی وجود خط مشابه در کرون‌تَب فعلی
(crontab -l 2>/dev/null | grep -F "$CRON_JOB") >/dev/null

if [ $? -eq 0 ]; then
    echo "این کرون‌جاب قبلاً اضافه شده است."
else
    # اضافه کردن کرون‌جاب به لیست فعلی
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "کرون‌جاب با موفقیت اضافه شد."
fi
