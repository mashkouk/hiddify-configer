#!/bin/bash

while true; do
    echo ""
    echo "=============================================="
    echo "🎛️  LOTFAN YEK GOZINE ENTEKHAB KONID:"
    echo "----------------------------------------------"
    echo "1️⃣  Didan cron job haye feli"
    echo "2️⃣  Virayesh cron job ha"
    echo "3️⃣  Ezafe kardan cron job emal taghirat automatic"
    echo "4️⃣  Khorooj"
    echo "----------------------------------------------"
    echo -n "🔸 Entekhab shoma (1-4): "
    read CHOICE
    echo "=============================================="

    case "$CHOICE" in
        1)
            echo ""
            echo "📋 Cron job haye feli:"
            echo "----------------------------------------------"
            crontab -l 2>/dev/null || echo "❌ Cron jobi vojood nadarad."
            echo "----------------------------------------------"
            ;;
        2)
            echo ""
            echo "🛠️  Baz kardan cron tab baraye virayesh..."
            sleep 1
            crontab -e
            ;;
        3)
            echo ""
            echo "⏱️  NOE ZAMANBANDI RA ENTEKHAB KONID:"
            echo "----------------------------------------------"
            echo "1️⃣  Har chand daghighe yekbar"
            echo "2️⃣  Har saat dar daghighe moshakhas"
            echo "----------------------------------------------"
            echo -n "🔸 Entekhab (1 ya 2): "
            read TIME_TYPE
            echo "----------------------------------------------"

            if [ "$TIME_TYPE" == "1" ]; then
                echo -n "🔁 Har chand daghighe yekbar ejra shavad? (mesalan 15): "
                read MIN_INTERVAL
                CRON_TIME="*/$MIN_INTERVAL * * * *"
            elif [ "$TIME_TYPE" == "2" ]; then
                echo -n "🕐 Dar kodam daghighe az har saat ejra shavad? (0 ta 59): "
                read MINUTE
                CRON_TIME="$MINUTE * * * *"
            else
                echo "❌ Entekhab namotabar. Bargasht be menu."
                continue
            fi

            CRON_CMD="bash /opt/hiddify-manager/apply_configs.sh --no-gui --no-log"
            CRON_JOB="$CRON_TIME $CRON_CMD"

            echo ""
            echo "📌 Cron job sakhte shode:"
            echo "👉  $CRON_JOB"
            echo ""

            # Check if job already exists
            (crontab -l 2>/dev/null | grep -F "$CRON_JOB") >/dev/null
            if [ $? -eq 0 ]; then
                echo "⚠️  In cron job ghablan ezafe shode."
            else
                (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
                echo "✅ Cron job ba movafaghiat ezafe shod."
            fi
            break
            ;;
        4)
            echo ""
            echo "👋 Khorooj az barname. Movafagh bashid!"
            echo "=============================================="
            break
            ;;
        *)
            echo ""
            echo "❌ Gozine namotabar. Lotfan adad 1 ta 4 ra vared konid."
            ;;
    esac
done
