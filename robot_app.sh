#!/usr/bin/env bash
# robot_app.sh
# Example "robot application" script suitable for running as a systemd service.
# Place it at: /home/<user>/robotics/scripts/robot_app.sh
# Make executable: chmod +x robot_app.sh

set -euo pipefail

NAME="${1:-robot-app}"
MODE="${2:-normal}"       # normal or fast
INTERVAL="${3:-2}"         # seconds
LOG_DIR="$HOME/robotics/logs"
LOG_FILE="$LOG_DIR/robot_app.log"

mkdir -p "$LOG_DIR"

echo "[$(date -Is)] starting: NAME=$NAME MODE=$MODE INTERVAL=$INTERVAL" | tee -a "$LOG_FILE"

if [[ "$MODE" != "normal" && "$MODE" != "fast" ]]; then
  echo "[$(date -Is)] ERROR: MODE must be 'normal' or 'fast'" | tee -a "$LOG_FILE"
  exit 1
fi

if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]]; then
  echo "[$(date -Is)] ERROR: INTERVAL must be an integer seconds value" | tee -a "$LOG_FILE"
  exit 1
fi

count=0
while true; do
  count=$((count + 1))

  if (( count % 5 == 0 )); then
    echo "[$(date -Is)] heartbeat $count: status=OK (periodic-check)" | tee -a "$LOG_FILE"
  else
    echo "[$(date -Is)] heartbeat $count: status=OK" | tee -a "$LOG_FILE"
  fi

  if [[ "$MODE" == "fast" ]]; then
    sleep 0.5
  else
    sleep "$INTERVAL"
  fi
done

