#!/bin/bash
# اطمینان از Public بودن پورت‌ها
echo "Setting ports to public..."
gh codespace ports visibility 443:public -c $CODESPACE_NAME || true
gh codespace ports visibility 8080:public -c $CODESPACE_NAME || true

tmux kill-session -t nikvpn 2>/dev/null || true
tmux new-session -d -s nikvpn
tmux send-keys -t nikvpn "sudo /usr/local/bin/xray run -c /etc/xray/config.json &>/tmp/xray.log" Enter
sleep 2
show-link.sh
sleep 2
web-server.sh &

tmux new-window -t nikvpn -n keepalive
tmux send-keys -t nikvpn:keepalive "while true; do curl -s --max-time 5 https://github.com/ -o /dev/null; sleep 180; done" Enter
echo "[NikVPN] Xray is running (tmux: nikvpn)"
echo "[NikVPN] Web link: port 8080"
