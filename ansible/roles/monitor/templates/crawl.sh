#!/bin/bash

LOGFILE="/var/log/system_monitor.log"

DISKS_TO_MONITOR=("/dev/sda1" "/dev/nvme0n1p2")

ALERT_URL="http://your-alert-url"

timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

cpu_usage() {
  top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | sed 's/%//'
}

memory_usage() {
  free | grep Mem | awk '{print $3/$2 * 100.0}'
}

disk_usage() {
    for disk in "${DISKS_TO_MONITOR[@]}"; do
        usage=$(df -h | grep "^$disk" | awk '{print $5}' | sed 's/%//')
        echo "$disk $usage"
    done
}

request_count() {
  ss -s | grep 'estab' | awk '{print $2}'
}

check_usage() {
  local cpu=$(cpu_usage)
  local ram=$(memory_usage)
  local disk=$(disk_usage)
  local alert_message=""

#  if (( $(echo "$cpu > 80" | bc -l) )); then
    alert_message+="WARNING: CPU usage is over 80%! Current usage: ${cpu}% "
#  fi

#  if (( $(echo "$ram > 80" | bc -l) )); then
    alert_message+="WARNING: RAM usage is over 80%! Current usage: ${ram}% "
#  fi

#  if (( $(echo "$disk > 80" | bc -l) )); then
    alert_message+="WARNING: Disk usage on $DISK_TO_MONITOR is over 80%! Current usage: ${disk}% "
#  fi

  if [[ -n "$alert_message" ]]; then
    send_alert "$alert_message"
  fi
}

send_alert() {
  local message=$1
#  curl -X POST -d "alert=$message" $ALERT_URL
  echo $message;
}

log_usage() {
  local cpu=$(cpu_usage)
  local ram=$(memory_usage)
  local disk=$(disk_usage)
  local requests=$(request_count)
  echo "$(timestamp) CPU: ${cpu}% RAM: ${ram}% Disk: ${disk}% Requests: ${requests}"

  check_usage

}

log_usage
