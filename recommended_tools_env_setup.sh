#!/usr/bin/env bash
# recommended_tools_env_setup.sh
# Runs core examples in the same order as the text document.
# It avoids making irreversible changes by default (firewall enable is not executed).
# Some commands require sudo; run with a sudo-capable user.

set -euo pipefail

echo "=== Git ==="
git --version || echo "git not installed. Install: sudo apt update && sudo apt install -y git"
echo "Example (not executed): git clone <REPO_URL>"
echo "Example: git status / git pull / git log --oneline -n 10 / git diff / git remote -v"

echo
echo "=== tmux ==="
tmux -V || echo "tmux not installed. Install: sudo apt update && sudo apt install -y tmux"
echo "Core usage tips:"
echo "tmux new -s robot"
echo "Detach: Ctrl+b then d"
echo "List: tmux ls"
echo "Attach: tmux attach -t robot"
echo "Split panes: Ctrl+b then %  OR  Ctrl+b then \""
echo "Help: Ctrl+b then ? (press q to quit help)"

echo
echo "=== SSH ==="
ssh -V || true
echo "Example connect (not executed): ssh user@ROBOT_IP"
echo "Generate key (safe):"
if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
  echo "Key already exists: ~/.ssh/id_ed25519"
else
  mkdir -p "$HOME/.ssh"
  ssh-keygen -t ed25519 -C "robot-key" -f "$HOME/.ssh/id_ed25519" -N ""
  echo "Created key: ~/.ssh/id_ed25519"
fi
echo "Copy key (not executed): ssh-copy-id user@ROBOT_IP"
echo "Remote command (not executed): ssh user@ROBOT_IP \"uname -a && uptime\""
echo "Copy files (not executed): scp / rsync examples shown in the .md.txt"

echo
echo "=== ufw ==="
if command -v ufw >/dev/null 2>&1; then
  sudo ufw status verbose || true
else
  echo "ufw not installed. Install: sudo apt update && sudo apt install -y ufw"
fi
echo "Safety: enabling ufw can lock you out of SSH if rules are wrong."
echo "Recommended before enabling (not executed): sudo ufw allow OpenSSH"
echo "Enable (not executed): sudo ufw enable"
echo "Allow port example (not executed): sudo ufw allow 7400/tcp"
echo "Rules list (not executed): sudo ufw status numbered"

echo
echo "=== raspi-config (Raspberry Pi OS only) ==="
if command -v raspi-config >/dev/null 2>&1; then
  echo "raspi-config found."
  echo "Run (interactive): sudo raspi-config"
else
  echo "raspi-config not found. That's normal on Ubuntu."
fi

echo
echo "=== Ubuntu Wi-Fi alternative: nmcli (NetworkManager) ==="
if command -v nmcli >/dev/null 2>&1; then
  nmcli radio || true
  nmcli device status || true
  echo "Scan networks (may require permissions): nmcli dev wifi list"
  echo "Connect (not executed): sudo nmcli dev wifi connect \"SSID\" password \"PASSWORD\""
else
  echo "nmcli not found. If you want it: sudo apt update && sudo apt install -y network-manager"
fi

echo
echo "=== Ubuntu Server alternative: netplan ==="
if ls /etc/netplan/*.yaml >/dev/null 2>&1; then
  echo "Netplan files:"
  ls -la /etc/netplan
  echo "Apply (not executed): sudo netplan apply"
  echo "Try safely (interactive, not executed): sudo netplan try"
else
  echo "No /etc/netplan/*.yaml found (may be a non-netplan system)."
fi

echo
echo "=== Troubleshooting quick checks ==="
echo "Network sanity:"
ip a || true
ip route || true
echo "DNS vs IP test examples:"
echo "ping -c 3 8.8.8.8"
echo "ping -c 3 google.com"
echo "If Wi-Fi blocked:"
echo "rfkill list"
echo "sudo rfkill unblock wifi"

echo
echo "Done."

