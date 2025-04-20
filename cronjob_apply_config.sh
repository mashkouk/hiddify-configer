#!/bin/bash

# === MENU ===
echo "Lotfan yek gozine entekhab konid:"
echo "1) Didan cron job haye feli"
echo "2) Virayesh cron job ha"
echo "3) Ezafe kardan cron job emal taghirat automatic"
echo -n "Entekhab shoma (1-3): "
read CHOICE

case "$CHOICE" in
    1)
        echo "=== Cron job haye feli ==="
        crontab -l 2>/dev/null || echo "Cron jobi vojood nadarad."
        ;;
    2)
        echo "=== Dar hale baz kardan cron tab baraye virayesh... ==="
        crontab -e
        ;;
    3)
        echo "=== Dar hale ezafe kardan cron job ==="
        CRON_JOB="12 * * * * bash /opt/hiddify-manager/apply_configs.sh --no-gui --no-log"
        (crontab -l 2>/dev/null | grep -F "$CRON_JOB") >/dev/null

        if [ $? -eq 0 ]; then
            echo "In cron job ghablan ezafe shode."
        else
            (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
            echo "Cron job ba movafaghiat ezafe shod."
        fi
        ;;
    *)
        echo "Gozine namotabar. Lotfan adad 1 ta 3 ra vared konid."
        ;;
esac
