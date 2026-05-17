#!/bin/bash
CONFIG="/etc/xray/config.json"
UUID=$(grep -o '"id": *"[^"]*"' "$CONFIG" | head -1 | grep -o '"[^"]*"$' | tr -d '"')

if [ -z "$UUID" ]; then
    echo "[NikVPN] Error: UUID not found in config."
    exit 1
fi

SNI="${CODESPACE_NAME}-443.app.github.dev"
LINK="vless://${UUID}@94.130.50.12:443?encryption=none&security=tls&sni=${SNI}&host=${SNI}&fp=chrome&allowInsecure=1&type=xhttp&mode=packet-up&path=%2F#nikvpn-codespace"

echo ""
echo "========================================"
echo "🔗 NikVPN - Your VLESS xHTTP Link"
echo "========================================"
echo "${LINK}"
echo ""

# ذخیره لینک در فایل برای وب سرور
echo "$LINK" > /workspaces/nikvpn-codespace/nikvpn-link.txt
echo "📁 Link saved to: nikvpn-link.txt"

echo "📌 Make sure port 443 is PUBLIC (check PORTS tab)"
echo "🌐 Also open port 8080 in browser to get your link easily"
echo "========================================"
echo ""