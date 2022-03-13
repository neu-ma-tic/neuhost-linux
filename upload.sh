#!/bin/bash
F=$(uuidgen)
NAME="$HOME/Pictures/"
KEY=""
DOMAIN="i.neumatic.club"
API="https://i.neumatic.club/api/v1"
QUERY="&lang=zh" # mandarin url

# flameshot ss tool
flameshot config -f "$F"
flameshot gui -r -p "$NAME" > /dev/null

NAME="$NAME$F"

mv "$NAME.bmp" "$NAME.png" # bmp -> png
mogrify -strip "$NAME.png" # remove excess data because nginx no likey

URL="https://$DOMAIN/$(curl -X POST \
      -H "Content-Type: multipart/form-data" \
      -H "Accept: application/json" \
      -H "User-Agent: neuhost.sh/1.0" \
      -H "key: $KEY" \
      -F "file=@$NAME.png" "$API/upload?&curl=true")" # upload
    printf "%s" "$URL" | xclip -sel clip # copy
echo "Uploaded successfully. URL: $URL"
