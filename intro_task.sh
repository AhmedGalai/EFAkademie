#!/usr/bin/env bash
# intro_task.sh
# This file documents accepted answers for intro_task.md.txt.
# It is not an auto-grader; it's a reference for trainers/reviewers.

set -euo pipefail

cat <<'ANSWERS'
Accepted Answers (Reference)

Question 1
Expected points:
- Terminal: the window/app where you type commands.
- Shell: the interpreter that reads commands and runs them.
- Bash: a common shell used interactively and for scripting.

Example acceptable answer:
"A terminal is the program/window. The shell is the command interpreter running inside it. Bash is a widely used shell that runs commands and scripts."

Question 2
Expected points:
- LTS = Long-Term Support.
- Stable release with years of security/maintenance updates.
- Robotics prefers stability/predictable dependencies and fewer breaking changes.

Example acceptable answer:
"Ubuntu LTS is the long-supported stable Ubuntu line. Robotics uses LTS because ROS/dependencies/drivers are sensitive and deployments need predictable updates."

Question 3
Accepted command pairs:
- pwd and ls
- pwd and ls -la
(Any equivalent that shows current directory and lists content is acceptable.)

Examples:
pwd
ls -la

Question 4
Accepted command:
mkdir -p ~/robotics/{scripts,logs}
or two mkdir -p commands for each directory, but the question asks for one command.

Question 5
Expected points:
- 2 refers to stderr.
- /dev/null discards output.
- So it hides error messages (permission denied, file not found) while keeping normal output.
- Example: grep/find across /var/log or a tree with restricted directories.

Accepted example commands:
grep -R "ERROR" /var/log 2>/dev/null
find /var/log -type f -name "*.log" 2>/dev/null

Question 6
Accepted commands:
- Last 50 lines:
tail -n 50 robot.log
- Follow live:
tail -f robot.log
(Also acceptable: tail -n 50 /path/to/robot.log)

Question 7
Expected points:
- Likely missing execute permission.
- Fix: chmod +x script.sh (or chmod u+x script.sh)
- Explain: adds executable permission bit so the OS can execute the file.

Accepted command:
chmod +x ./script.sh

Question 8
Expected sequence:
- Find PID:
pgrep -a robot_node
(or ps aux | grep robot_node, but pgrep preferred)
- Graceful stop:
kill -TERM <PID>
- Force kill if needed:
kill -KILL <PID>
Alternative acceptable:
pkill -TERM robot_node
pkill -KILL robot_node
(Explain that pkill can match multiple processes; safer is PID-based.)

Question 9
Accepted commands:
- Confirm disk usage:
df -h
- Find what consumes space:
du -sh /var/log/* 2>/dev/null | sort -h
or
du -sh ~/robotics
or
du -sh /path/* 2>/dev/null | head
Any reasonable du usage that identifies large folders is acceptable.

Question 10
Accepted commands:
- Status:
sudo systemctl status robot-app@robotop --no-pager
- Logs:
sudo journalctl -u robot-app@robotop -n 100 --no-pager

Common “not found” reason (any one accepted):
- Unit file missing or not installed under /etc/systemd/system or /lib/systemd/system
- Template service file named wrong: using robot-app.service instead of robot-app@.service
- Forgot sudo systemctl daemon-reload after creating/editing the unit

ANSWERS

