#!/bin/bash
tmux kill-session -t nikvpn 2>/dev/null || true
tmux new-session -d -s nikvpn
tmux send-keys -t nikvpn "sudo /usr/local/bin/xray run -c /etc/xray/config.json &>/tmp/xray.log" Enter
sleep 2
show-link.sh

# یک تأخیر ۲ ثانیه‌ای بده تا فایل لینک حتماً ذخیره شود
sleep 2

# راه‌اندازی وب سرور برای نمایش لینک
web-server.sh &

tmux new-window -t nikvpn -n keepalive
tmux send-keys -t nikvpn:keepalive "while true; do curl -s --max-time 5 https://github.com/ -o /dev/null; sleep 180; done" Enter
echo "[NikVPN] Xray is running in background (tmux session: nikvpn)"
echo "[NikVPN] View logs: tmux attach -t nikvpn"
echo "[NikVPN] Web link available on port 8080 (check PORTS tab)"
