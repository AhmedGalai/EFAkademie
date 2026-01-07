
```bash
#!/usr/bin/env bash
# commands.sh
# Demo commands in the same order as intro.md.txt narration, including the sample loop/if script.

set -euo pipefail

echo
echo "=== Help system: --help and man ==="
ls --help | head -n 8
echo "Tip: run 'man ls' interactively (press q to quit)."

echo
echo "=== Filesystem basics: pwd / cd / ls / mkdir / touch / cat ==="
pwd
cd ~
pwd
ls
mkdir -p ~/robotics/{projects,logs,scripts}
cd ~/robotics
pwd
ls -la
touch notes.txt
echo "hello robotics" > notes.txt
cat notes.txt

echo
echo "=== whoami / uname / which ==="
whoami
uname -a
which bash || true
which python3 || true

echo
echo "=== echo, redirects, pipes, wc, head, tail, grep ==="
echo "line 1" > file.txt
echo "line 2" >> file.txt
cat file.txt
wc -l file.txt
head -n 1 file.txt
tail -n 1 file.txt
grep "line" file.txt

echo
echo "=== Demonstrate 2>/dev/null (hide errors) ==="
mkdir -p logs
echo "ERROR: motor timeout" > logs/robot.log
echo "INFO: started" > logs/system.log
grep -R "ERROR" ./logs 2>/dev/null
echo "Count ERROR lines:"
grep -R "ERROR" ./logs 2>/dev/null | wc -l

echo
echo "=== Storage and resource sanity checks: df / du / free ==="
df -h
du -sh ~/robotics
free -h || true

echo
echo "=== tree (may not be installed) ==="
tree -a ~/robotics 2>/dev/null || echo "tree not installed. Install with: sudo apt update && sudo apt install -y tree"

echo
echo "=== Processes: ps / pgrep / kill / pkill / top (top is interactive) ==="
ps aux | head -n 5
pgrep -a bash || true

echo "Launching a harmless background process: sleep 300"
sleep 300 &
SLEEP_PID=$!
echo "sleep PID is $SLEEP_PID"
ps -p "$SLEEP_PID" -o pid,cmd

echo "Stopping it gracefully with kill -TERM..."
kill -TERM "$SLEEP_PID" || true
sleep 1
ps -p "$SLEEP_PID" -o pid,cmd || echo "Process stopped."
echo "Tip: top is interactive. Run: top"

echo
echo "=== Permissions and ownership: chmod / chown ==="
cat > ~/robotics/scripts/run_me.sh <<'EOF'
#!/usr/bin/env bash
echo "I can run because I'm executable."
EOF
chmod +x ~/robotics/scripts/run_me.sh
~/robotics/scripts/run_me.sh
echo "Tip: if files end up owned by root, fix with:"
echo "sudo chown -R \$USER:\$USER ~/robotics"

echo
echo "=== sudo and apt (printed, not executed automatically) ==="
echo "sudo apt update"
echo "sudo apt upgrade -y"
echo "sudo apt install -y tree htop net-tools tcpdump"
echo "sudo apt --fix-broken install"
echo "sudo dpkg --configure -a"

echo
echo "=== Users and groups (printed; uncomment if you really want to change users) ==="
echo "sudo adduser robotop"
echo "sudo usermod -aG sudo,dialout robotop"
echo "groups robotop"
groups

echo
echo "=== Variables, env variables, alias, export, env ==="
NAME="robot"
echo "NAME is: $NAME"
export ROBOTICS_WS="$HOME/robotics"
echo "ROBOTICS_WS is: $ROBOTICS_WS"
env | head -n 5
alias ll='ls -la'
ll || true

echo
echo "=== Editors: nano and vim tips ==="
echo "nano ~/robotics/notes.txt    # Ctrl+O save, Enter confirm, Ctrl+X exit, Ctrl+W search"
echo "vim  ~/robotics/notes.txt    # i insert, Esc, :wq save+quit, :q! quit no save, / search then n"

echo
echo "=== Networking: ip / ifconfig / ss / tcpdump ==="
ip a || true
ip route || true
ifconfig || true
ss -tulpn | head -n 20 || true
echo "tcpdump requires sudo:"
echo "sudo tcpdump -i any -n -c 20"

echo
echo "=== Logs and services: journalctl / systemctl examples ==="
journalctl -xe --no-pager | tail -n 20 || true
echo "Examples you can run:"
echo "journalctl -u NetworkManager --no-pager | tail -n 80"
echo "sudo systemctl status ssh --no-pager"
echo "sudo systemctl start ssh"
echo "sudo systemctl enable ssh"

echo
echo "=== find ==="
find ~/robotics -type f -name "*.log" 2>/dev/null || true
find /var/log -type f -name "*syslog*" 2>/dev/null | head -n 5 || true

echo
echo "=== Sample bash script created via cat (variables, if, loops) ==="
cat > ~/robotics/scripts/robot_demo.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

# Variables (positional args with defaults)
NAME="${1:-robot}"
COUNT="${2:-5}"
MODE="${3:-normal}"
LOG="$HOME/robotics/logs/robot_demo.log"

mkdir -p "$(dirname "$LOG")"

echo "[$(date -Is)] Starting demo for: $NAME, COUNT=$COUNT, MODE=$MODE" | tee -a "$LOG"

# If statements
if [[ "$COUNT" -lt 1 ]]; then
  echo "COUNT must be >= 1" | tee -a "$LOG"
  exit 1
fi

if [[ "$MODE" != "normal" && "$MODE" != "fast" ]]; then
  echo "MODE must be 'normal' or 'fast'" | tee -a "$LOG"
  exit 1
fi

# A for-loop
for ((i=1; i<=COUNT; i++)); do
  if (( i % 2 == 0 )); then
    MSG="[$(date -Is)] step $i: even heartbeat OK"
  else
    MSG="[$(date -Is)] step $i: odd heartbeat OK"
  fi
  echo "$MSG" | tee -a "$LOG"

  if [[ "$MODE" == "fast" ]]; then
    sleep 0.2
  else
    sleep 1
  fi
done

# A while-loop (small extra demo)
j=1
while [[ "$j" -le 3 ]]; do
  echo "[$(date -Is)] post-check $j: OK" | tee -a "$LOG"
  sleep 0.5
  j=$((j + 1))
done

echo "[$(date -Is)] Done. Log at: $LOG"
EOF

chmod +x ~/robotics/scripts/robot_demo.sh
~/robotics/scripts/robot_demo.sh "G1" 6 normal
tail -n 20 ~/robotics/logs/robot_demo.log

echo
echo "All demo steps complete."

