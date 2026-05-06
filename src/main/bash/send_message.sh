#!/usr/local/bin/bash

if test $# -ne 1; then
 echo 'Wrong arguments!'; exit 1; fi

TG_MESSAGE="$1"

ARGUMENTS=(TG_BOT_ID TG_BOT_TOKEN TG_CHAT_ID TG_MESSAGE)
for (( INDEX=0; INDEX<${#ARGUMENTS[@]}; INDEX++ )); do
 ARGUMENT="${ARGUMENTS[INDEX]}"
 if test -z "${!ARGUMENT}"; then
  echo "Argument \"$ARGUMENT\" is empty!"; exit $((100+INDEX)); fi
done

REQUEST_BODY="{
 \"parse_mode\": \"markdown\",
 \"link_preview_options\": {
  \"is_disabled\": true
 },
 \"chat_id\": ${TG_CHAT_ID}
}"

REQUEST_BODY="$(echo "${REQUEST_BODY}" | TG_MESSAGE="${TG_MESSAGE}" yq -M -o=json '.text=strenv(TG_MESSAGE)')"
if test $? -ne 0; then echo 'Request body error!'; exit 1; fi

# https://core.telegram.org/bots/api#sendmessage

CODE=$(curl -m 8 -w %{http_code} -o /dev/null \
 "https://api.telegram.org/bot${TG_BOT_ID}:${TG_BOT_TOKEN}/sendMessage" \
 -H 'Content-Type: application/json' \
 --data "${REQUEST_BODY}")

if test $? -ne 0; then
 echo 'Curl error!'; exit 1; fi

if [[ "${CODE}" != '200' ]]; then
 echo 'Send tg message error!'; exit 1; fi
