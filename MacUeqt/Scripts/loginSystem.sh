#!bin/sh
cat >/tmp/Login_Automatically.sh <<-"EOF"
# osascript -e 'tell application "System Events" to keystroke "xujiase"'; \
# osascript -e 'tell application "System Events" to keystroke tab'; \
osascript -e 'tell application "System Events" to keystroke "passwordhere"'; \
osascript -e 'tell application "System Events" to keystroke return'
EOF
chmod 755 /tmp/Login_Automatically.sh
. /tmp/Login_Automatically.sh
rm -f /tmp/Login_Automatically.sh
