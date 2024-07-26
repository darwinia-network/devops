#!/bin/bash

DISKS_TO_MONITOR=("/dev/sda1" "/dev/nvme0n1p2")

SERVER_NAME='test-server'
NOTIFY_SLACK_WEBHOOK='https://hooks.slack.com/services/xxx/xxx/xxx'
NOTIFY_SLACK_CHANNEL='darwinia-alert-notification'

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

generate_alert_message() {
  local cpu=$(cpu_usage)
  local ram=$(memory_usage)
  local tcp=$(request_count)
  local alert_message="[]"
  local priority='P2'

  if (( $(echo "$cpu > 95" | bc -l) )); then
    priority='P1'
  fi
  if (( $(echo "$ram > 95" | bc -l) )); then
    priority='P1'
  fi
  if [[ "P1" == "$priority" ]]; then
    priority_alert=$(jq -n --arg priority "${priority}" '[{"type":"mrkdwn","text":"*Priority*"},{"type":"plain_text","text":$priority}]')
    alert_message=$(echo "$alert_message" | jq --argjson priority_alert "$priority_alert" '. += $priority_alert')
  fi

  if (( $(echo "$cpu > 80" | bc -l) )); then
    cpu_alert=$(jq -n --arg cpu "${cpu}%" '[{"type":"mrkdwn","text":"*CPU*"},{"type":"plain_text","text":$cpu}]')
    alert_message=$(echo "$alert_message" | jq --argjson cpu_alert "$cpu_alert" '. += $cpu_alert')
  fi

  if (( $(echo "$ram > 80" | bc -l) )); then
    ram_alert=$(jq -n --arg ram "${ram}%" '[{"type":"mrkdwn","text":"*RAM*"},{"type":"plain_text","text":$ram}]')
    alert_message=$(echo "$alert_message" | jq --argjson ram_alert "$ram_alert" '. += $ram_alert')
  fi

  if [[ "$alert_message" != "[]" ]]; then
    tcp_alert=$(jq -n --arg tcp "${tcp}" '[{"type":"mrkdwn","text":"*TCP*"},{"type":"plain_text","text":$tcp}]')
    alert_message=$(echo "$alert_message" | jq --argjson tcp_alert "$tcp_alert" '. += $tcp_alert')
  fi

  echo "$alert_message"
}


generate_disk_alert_message() {
  local alert_message="[]"
  local priority='P2'

  while IFS= read -r line; do
    local disk=$(echo $line | awk '{print $1}')
    local usage=$(echo $line | awk '{print $2}')
    if [[ -z "$usage" ]]; then
      continue
    fi

    if (( $(echo "$usage > 90" | bc -l) )); then
      priority='P1'
    fi
    if (( $(echo "$usage > 80" | bc -l) )); then
      disk_alert=$(jq -n --arg disk "*DISK* ($disk)" --arg usage "${usage}%" '[{"type":"mrkdwn","text":$disk},{"type":"plain_text","text":$usage}]')
      alert_message=$(echo "$alert_message" | jq --argjson disk_alert "$disk_alert" '. += $disk_alert')
    fi
  done < <(disk_usage)

  if [[ "P1" == "$priority" ]]; then
    priority_alert=$(jq -n --arg priority "${priority}" '[{"type":"mrkdwn","text":"*Priority*"},{"type":"plain_text","text":$priority}]')
    alert_message=$(echo "$alert_message" | jq --argjson priority_alert "$priority_alert" '. += $priority_alert')
  fi

  echo "$alert_message"
}


check_and_send_alert() {
  local alert_message=$(generate_alert_message)
  local disk_alert_message=$(generate_disk_alert_message)


  local blocks="[]"

  if [[ "$alert_message" != "[]" ]]; then
    alert_block=$(
      jq -n \
        --arg warning "[*WARNING*]: New server alert > $SERVER_NAME" \
        --argjson msg "$alert_message" \
        '{ "type": "section", "text": {"type": "mrkdwn", "text": $warning}, "fields": $msg }'
    )
    blocks=$(echo "$blocks" | jq --argjson block "$alert_block" '. += [$block]')
  fi

  if [[ "$disk_alert_message" != "[]" ]]; then
    disk_block=$(
      jq -n \
        --arg warning "[*WARNING*]: New disk alert > $SERVER_NAME" \
        --argjson msg "$disk_alert_message" \
        '{ "type": "section", "text": {"type": "mrkdwn", "text": $warning}, "fields": $msg }'
    )
    blocks=$(echo "$blocks" | jq --argjson block "$disk_block" '. += [$block]')
  fi

  if [[ "$blocks" != "[]" ]]; then
    local data=$(jq -n \
      --arg channel "$NOTIFY_SLACK_CHANNEL" \
      --argjson blocks "$blocks" \
      '{
        "username": "ServerBot",
        "icon_emoji": ":loudspeaker:",
        "channel": $channel,
        "blocks": $blocks
      }')

    send_alert "$data"
  fi
}

send_alert() {
  local message=$1

  echo $message

  curl -X POST \
    -H "Content-type: application/json" \
    $NOTIFY_SLACK_WEBHOOK \
    --data "$message"
}

log_usage() {
  local cpu=$(cpu_usage)
  local ram=$(memory_usage)
  local disk=$(disk_usage)
  local requests=$(request_count)
  echo "$(timestamp) CPU: ${cpu}% RAM: ${ram}% Disk: ${disk}% Requests: ${requests}"

  check_and_send_alert

}

log_usage
