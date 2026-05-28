#!/bin/bash
battery_data()
{
  phone=$1
  percentage=$(adb -s "$phone" shell dumpsys battery | grep "level" | cut -d":" -f2 | xargs)
   curl --data chat_id="-5268621856" --data-urlencode "text=Your phone $phone is at $percentage % charge." "https://api.telegram.org/bot8711118758:AAHAo6oqssGodCV1olbtRWpoJ6k25s4IXKM/sendMessage?parse_mode=HTML"

   temperature=$(($(adb -s "$phone" shell dumpsys battery | grep "temperature" | cut -d":" -f2 | xargs)/10))
   if [[ $temperature -ge 35 ]];then
     curl --data chat_id="-5268621856" --data-urlencode "text=Your phone $phone is running hot at $temperature Celsius please keep it ventilating" "https://api.telegram.org/bot8711118758:AAHAo6oqssGodCV1olbtRWpoJ6k25s4IXKM/sendMessage?parse_mode=HTML"
   elif [[ $temperature -ge 30 ]];then
  curl --data chat_id="-5268621856" --data-urlencode "text=Your phone $phone is at $temperature Celsius .it's fine but try to cool it down for better performance" "https://api.telegram.org/bot8711118758:AAHAo6oqssGodCV1olbtRWpoJ6k25s4IXKM/sendMessage?parse_mode=HTML"
   else
  curl --data chat_id="-5268621856" --data-urlencode "text=Your phone $phone is at $temperature Celsius and it's perfectly fine don't worry ." "https://api.telegram.org/bot8711118758:AAHAo6oqssGodCV1olbtRWpoJ6k25s4IXKM/sendMessage?parse_mode=HTML"

  fi
}
Main_Devices=()
iteration_count=0
check=true
read -p "Please enter y to start the server " choice
                  if [[ $choice != y && $choice != Y ]]; then
                          echo "Fine we'll postpone the session"
                          check=false
else
        while [[ $check = true ]];
        do
                adb start-server
                echo "Welcome to fleet management"
                devices=()
                devices=($(adb devices | grep -v "List" | awk '{print $1}' | grep .))
                device_count=0
                echo "Following is the list of connected devices"
                for device in "${devices[@]}";
                do
                        ((device_count++))
                        echo "$device_count. $device"
                done
                # Check for disconnected devices
                for oldy in "${Main_Devices[@]}"; do
                    if [[ " ${devices[*]} " != *" $oldy "* ]]; then
                curl --data chat_id="-5268621856" --data-urlencode "text=Your phone $oldy is Disconnected." "https://api.telegram.org/bot8711118758:AAHAo6oqssGodCV1olbtRWpoJ6k25s4IXKM/sendMessage?parse_mode=HTML"
                    fi
                done

                # Check for new devices
                for device in "${devices[@]}"; do
                    if [[ " ${Main_Devices[*]} " != *" $device "* ]]; then
                curl --data chat_id="-5268621856" --data-urlencode "text=A new phone $device is Connected." "https://api.telegram.org/bot8711118758:AAHAo6oqssGodCV1olbtRWpoJ6k25s4IXKM/sendMessage?parse_mode=HTML"
                    fi
                done
                Main_Devices=("${devices[@]}")
                        for device in "${devices[@]}";
                        do
                                battery_data "$device"
                        done
         sleep 10
       done
fi