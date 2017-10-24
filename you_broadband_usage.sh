#!/bin/bash

# Set all required constants
USER_ID="<INSERT_LOGIN_ID_HERE>"
PASSWORD="<INSERT_PASSWORD_HERE>"
QUERY="login=$USER_ID&password=$PASSWORD"
LOGIN_URL="https://itapps.youbroadband.in/default/homeuser/login_sql.jsp"
USAGE_URL="https://itapps.youbroadband.in/default/susage/mybalance.jsp"
LOGOUT_URL="https://itapps.youbroadband.in/default/homeuser/logout.jsp"
COOKIE_FILE="/tmp/.xyzz3"
MARKER_TEXT='<td align="center" valign="middle" bgcolor="#FFFFFF" width="130" class="breadcrum-link">'

# Make a login request to begin the session
curl -s -X POST -d $QUERY --cookie-jar $COOKIE_FILE $LOGIN_URL -o /dev/null

# Make the request to the usage page using the generated session
# Cut as required
resp=$(curl -s --cookie $COOKIE_FILE $USAGE_URL |\
       grep "$MARKER_TEXT" |\
       cut -d '>' -f 2 |\
       cut -d '<' -f 1)

# Log out just in case
curl -s --cookie $COOKIE_FILE $LOGOUT_URL -o /dev/null

# Clean up the cookie file
rm $COOKIE_FILE

# 1st line is `data left` and 2nd line is `days left`
data=$(echo -e "$resp" | head -1)
data_in_gb=$(echo "scale=2; ${data}/1024" | bc)
days=$(echo -e "$resp" | tail -1)

# Display relevant information
echo "Data Left: $data MB ($data_in_gb GB)"
echo "Days Left: $days"
