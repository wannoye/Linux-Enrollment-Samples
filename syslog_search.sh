#!/bin/bash
devices=./inventory
read -p "Enter Customer Code: " cust
cust=$(echo $cust | tr '[:upper:]' '[:lower:]')
touch ~/${cust}_syslogs.txt
archivedir="/home/archive/logs/`date "+%Y"`/`date "+%m"`/"
logfile="/var/log/syslog"

help() {
   printf "\nSyslog search script"
   printf "\nThis script requires an 'inventory' file containing containining devices."
   printf "\nSee the example 'inventory' template or use the device name column in enrollment templates."
   printf "\n\nSyntax: ./syslog-search.sh Optional[-h]"
   printf "\n\nOptions:"
   printf "\nh     Print this help dialog"
}

search_syslog () {
        echo -e "\n-------------------------\n$(date +%m-%d-%Y) $dev\n" >> ${cust}_syslogs.txt
        log=$(awk -v v="$dev" '$7 ~ v' $logfile | head -3)
        if [[ -n $log ]]; then
                echo "$log" >> ${cust}_syslogs.txt
        elif [[ -z $log ]]; then
                echo -e "No logs found for $dev on $(date +%m-%d-%Y)" >> ${cust}_syslogs.txt
        fi
}

search_log_archive () {
        if [ -z "$1" ]; then
                echo -e "\n-------------------------\n$(date +%m-%d-%Y -d "-1 day") $dev\n" >> ${cust}_syslogs.txt
                log=$(bzcat $archivedir*-$(date +%m-%d-%Y).bz2 | awk -v v="$dev" '$7 ~ v' | head -3)
        else
                echo -e "\n-------------------------\n$(date +%m-%d-%Y -d "-"$1" day") $dev\n" >> ${cust}_syslogs.txt
                num=$((1+1))
                log=$(bzcat $archivedir*-$(date +%m-%d-%Y -d "-"$num" day").bz2 | awk -v v="$dev" '$7 ~ v' | head -3)
        fi
        if [[ -n $log ]]; then
                echo "$log" >> ${cust}_syslogs.txt
        elif [[ -z $log ]]; then
                echo -e "No logs found for $dev on $(date +%m-%d-%Y -d "-"$1" day")" >> ${cust}_syslogs.txt
        fi
}

if [ ! -f "$devices" ]; then
    printf "\n$devices file not found\n"
    help
    exit 9
fi

while getopts ":h" option; do
    case $option in
        h) # Display Help
            help
            exit;;
        ?) # Invalid Option
            printf "\nError - Invalid Option: $1\n"
            help
            exit;;
    esac
done

while IFS= read ci; do
        dev=$(echo $ci | tr '[:upper:]' '[:lower:]')
        search_syslog
        if [ -n "$log" ]; then continue; fi
        search_log_archive
        if [ -n "$log" ]; then continue; fi
        search_log_archive 1
        if [ -n "$log" ]; then continue; fi
        search_log_archive 2
        if [ -n "$log" ]; then continue; fi
        search_log_archive 3
done < $devices
exit
