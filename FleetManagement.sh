#!/bin/bash

chatId="<YOUR_CHAT_ID>"
API="https://api.telegram.org/bot<YOUR_BOT_TOKEN>/sendMessage?parse_mode=HTML"

battery_data()
{
  flag=0
  phone=$1

  #battery percentage
  battery_dumpsys=$(adb -s "$phone" shell dumpsys battery)
  percentage=$(echo "$battery_dumpsys"| grep "level" | cut -d":" -f2 | xargs)

  if [[ $percentage -le 30 ]]; then
    flag=1
   curl --data chat_id="$chatId" --data-urlencode "text=Your phone $phone is at $percentage % charge. please charge it." "$API"
  fi

  #temprature
   temperature=$(($(echo "$battery_dumpsys"| grep "temperature" | cut -d":" -f2 | xargs)/10))

   if [[ $temperature -ge 38 ]];then
     flag=1
     curl --data chat_id="$chatId" --data-urlencode "text=Your phone $phone is running hot at
                                                          $temperature Celsius please keep it ventilating" "$API"

  fi

  #memory usage
  memory_dumpsys=$(adb -s "$phone" shell cat /proc/meminfo)
  total_ram=$(echo "$memory_dumpsys" | grep "MemTotal" | awk '{print $2}')
  available_ram=$(echo "$memory_dumpsys" | grep "MemAvailable" | awk '{print $2}')
  used_ram=$((total_ram - available_ram))
  ram_percentage=$(( (used_ram * 100) / total_ram ))

  if [[ $ram_percentage -ge 90 ]];then
  flag=1
   curl --data chat_id="$chatId" --data-urlencode "text=Your phone $phone is at it's $ram_percentage% ram
                                                        usage please do check it out and end unnecessary tasks." "$API"
  fi

  #if everything is fine
  if [[ $flag -eq 0 ]];then
      curl --data chat_id="$chatId" --data-urlencode "text=Your phone $phone is doing great keep this up ." "$API"
    fi
}

  #main array for devices
  Main_Devices=()
  check=true
  read -p "Please enter y to start the server : " choice
if [[ $choice != y && $choice != Y ]]; then
  echo "Fine we'll postpone the session"
  check=false

else
        while [[ $check = true ]];
        do
              #starting the server
                adb start-server
                echo "Welcome to fleet management"
                #temporary array for devices
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
                curl --data chat_id="$chatId" --data-urlencode "text=Your phone $oldy is Disconnected." "$API"
                    fi
                done

                # Check for new devices
                for device in "${devices[@]}"; do
                    if [[ " ${Main_Devices[*]} " != *" $device "* ]]; then
                curl --data chat_id="$chatId" --data-urlencode "text=A new phone $device is Connected." "$API"
                    fi
                done

                #Analysing all main devices
                Main_Devices=("${devices[@]}")
                        for device in "${devices[@]}";
                        do
                                battery_data "$device"
                        done

         #delay main loop by 10 seconds
         sleep 10
       done
fi
