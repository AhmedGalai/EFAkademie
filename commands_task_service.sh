#!/usr/bin/env bash
# commands_task_service.sh
# This follows text_task_service.md.txt and performs the advanced task end-to-end.
# It assumes you want to use the user "robotop".
# Some steps require sudo. Run this script as a sudo-capable user.

set -euo pipefail

USER_NAME="robotop"

echo "=== Step 1: confirm user exists ==="
if id "$USER_NAME" >/dev/null 2>&1; then
  echo "User exists: $USER_NAME"
else
  echo "Creating user: $USER_NAME"
  sudo adduser "$USER_NAME"
fi

echo "Home entry:"
getent passwd "$USER_NAME"

echo
echo "=== Step 2: create folders ==="
sudo -u "$USER_NAME" mkdir -p "/home/$USER_NAME/robotics/{scripts,logs}" || true
# Brace expansion won't work inside quotes in all contexts; do it explicitly:
sudo -u "$USER_NAME" mkdir -p "/home/$USER_NAME/robotics/scripts"
sudo -u "$USER_NAME" mkdir -p "/home/$USER_NAME/robotics/logs"

echo
echo "=== Step 3: create example bash script (service payload) ==="
sudo -u "$USER_NAME" bash -lc 'cat > "$HOME/robotics/scripts/robot_app.sh" <<'"'"'EOF'"'"'
#!/usr/bin/env bash
set -euo pipefail

NAME="${1:-robot-app}"
MODE="${2:-normal}"       # normal or fast
INTERVAL="${3:-2}"         # seconds
LOG_DIR="$HOME/robotics/logs"
LOG_FILE="$LOG_DIR/robot_app.log"

mkdir -p "$LOG_DIR"

echo "[$(date -Is)] starting: NAME=$NAME MODE=$MODE INTERVAL=$INTERVAL" | tee -a "$LOG_FILE"

if [[ "$MODE" != "normal" && "$MODE" != "fast" ]]; then
  echo "[$(date -Is)] ERROR: MODE must be '"'"'normal'"'"' or '"'"'fast'"'"'" | tee -a "$LOG_FILE"
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
EOF'

echo
echo "=== Step 4: chmod +x and quick manual test ==="
sudo chmod +x "/home/$USER_NAME/robotics/scripts/robot_app.sh"
echo "Manual test for 5 seconds (will be killed):"
sudo -u "$USER_NAME" timeout 5 "/home/$USER_NAME/robotics/scripts/robot_app.sh" demo normal 1 || true
sudo -u "$USER_NAME" tail -n 5 "/home/$USER_NAME/robotics/logs/robot_app.log" || true

echo
echo "=== Step 5: install systemd template unit ==="
sudo tee /etc/systemd/system/robot-app@.service >/dev/null <<EOF
[Unit]
Description=Robot App (Example) for user %i
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=%i
WorkingDirectory=/home/%i
ExecStart=/home/%i/robotics/scripts/robot_app.sh
Restart=always
RestartSec=2
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

echo
echo "=== Step 6: daemon-reload ==="
sudo systemctl daemon-reload

echo
echo "=== Step 7: start service instance and show status ==="
sudo systemctl start "robot-app@$USER_NAME"
sudo systemctl status "robot-app@$USER_NAME" --no-pager || true

echo
echo "=== Step 8: enable autostart ==="
sudo systemctl enable "robot-app@$USER_NAME"
sudo systemctl is-enabled "robot-app@$USER_NAME" || true

echo
echo "=== Step 9: show recent logs ==="
sudo journalctl -u "robot-app@$USER_NAME" -n 30 --no-pager || true

echo
echo "=== Step 11: show script log file ==="
sudo -u "$USER_NAME" tail -n 10 "/home/$USER_NAME/robotics/logs/robot_app.log" || true

echo
echo "Done. To follow logs live run:"
echo "sudo journalctl -u robot-app@$USER_NAME -f"

