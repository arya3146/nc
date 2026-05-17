#!/bin/bash
LINK_FILE="/workspaces/nikvpn-codespace/nikvpn-link.txt"

# صبر می‌کنیم تا فایل لینک ساخته بشه (حداکثر 30 ثانیه)
for i in {1..30}; do
    if [ -f "$LINK_FILE" ]; then
        break
    fi
    sleep 1
done

LINK=$(cat "$LINK_FILE" 2>/dev/null)
if [ -z "$LINK" ]; then
    LINK="Link not ready yet. Please wait or check if setup completed."
fi

# ایجاد صفحه HTML
cat > /workspaces/nikvpn-codespace/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>NikVPN - Get Your Link</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .card {
            background: rgba(0,0,0,0.75);
            backdrop-filter: blur(10px);
            border-radius: 32px;
            padding: 32px 24px;
            max-width: 500px;
            width: 100%;
            text-align: center;
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);
            border: 1px solid rgba(155, 89, 182, 0.3);
        }
        h1 {
            font-size: 28px;
            background: linear-gradient(135deg, #9b59b6, #e84393);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-bottom: 12px;
        }
        .sub {
            color: #aaa;
            font-size: 14px;
            margin-bottom: 28px;
        }
        .link-box {
            background: #0a0a1a;
            padding: 18px;
            border-radius: 20px;
            word-break: break-all;
            font-size: 11px;
            font-family: monospace;
            margin: 20px 0;
            border: 1px solid #9b59b6;
            color: #4ade80;
            text-align: left;
            max-height: 200px;
            overflow: auto;
        }
        .btn-group {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
        }
        button {
            background: linear-gradient(135deg, #9b59b6, #7d3c98);
            color: white;
            border: none;
            padding: 14px 28px;
            border-radius: 40px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, opacity 0.2s;
        }
        button:active { transform: scale(0.96); }
        .btn-secondary {
            background: linear-gradient(135deg, #2c3e50, #1a2632);
        }
        .note {
            font-size: 12px;
            color: #888;
            margin-top: 24px;
            border-top: 1px solid #333;
            padding-top: 20px;
        }
        .status {
            font-size: 12px;
            color: #4ade80;
            margin-top: 12px;
        }
        @media (max-width: 480px) {
            .card { padding: 24px 16px; }
            button { padding: 12px 20px; font-size: 14px; }
            .link-box { font-size: 9px; }
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>🔗 NikVPN</h1>
        <div class="sub">VLESS + xHTTP + TLS</div>
        <div class="link-box" id="link">$LINK</div>
        <div class="btn-group">
            <button onclick="copyLink()">📋 Copy Link</button>
            <button onclick="downloadLink()" class="btn-secondary">💾 Save as File</button>
        </div>
        <div class="status" id="status"></div>
        <div class="note">
            💡 Long press on the link to copy manually if buttons don't work.<br>
            🔗 Port 443 must be PUBLIC for the proxy to work.
        </div>
    </div>
    <script>
        function copyLink() {
            const link = document.getElementById('link').innerText;
            navigator.clipboard.writeText(link).then(() => {
                const status = document.getElementById('status');
                status.innerText = '✅ Copied to clipboard!';
                setTimeout(() => { status.innerText = ''; }, 2000);
            }).catch(() => {
                alert('Long press on the link to copy manually');
            });
        }
        function downloadLink() {
            const link = document.getElementById('link').innerText;
            const blob = new Blob([link], {type: 'text/plain'});
            const a = document.createElement('a');
            const url = URL.createObjectURL(blob);
            a.href = url;
            a.download = 'nikvpn-link.txt';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
            const status = document.getElementById('status');
            status.innerText = '💾 File saved!';
            setTimeout(() => { status.innerText = ''; }, 2000);
        }
    </script>
</body>
</html>
EOF

# اجرای وب سرور روی پورت 8080 در پس‌زمینه
cd /workspaces/nikvpn-codespace
nohup python3 -m http.server 8080 > /tmp/webserver.log 2>&1 &

echo "🌐 Web server started on port 8080"
echo "📱 Open the forwarded URL for port 8080 in your browser"