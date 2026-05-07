#!/usr/local/bin/bash

if test $# -ne 3; then
 echo 'Wrong arguments!'; exit 1; fi

TG_CHAT_ID="$1"
TG_TOPIC_ID="$2"
TG_EMOJI_ID="$3"

ARGUMENTS=(TG_BOT_ID TG_BOT_TOKEN TG_CHAT_ID TG_TOPIC_ID TG_EMOJI_ID)
for (( INDEX=0; INDEX<${#ARGUMENTS[@]}; INDEX++ )); do
 ARGUMENT="${ARGUMENTS[INDEX]}"
 if test -z "${!ARGUMENT}"; then
  echo "Argument \"$ARGUMENT\" is empty!"; exit $((100+INDEX)); fi
done

if [[ ! "${TG_CHAT_ID}" =~ ^-?[0-9]+$ ]]; then
 echo 'Wrong chat id!'; exit 1; fi

if [[ ! "${TG_TOPIC_ID}" =~ ^[1-9][0-9]?$ ]]; then
 echo 'Wrong topic id!'; exit 1; fi

REQUEST_BODY="{
 \"chat_id\": ${TG_CHAT_ID},
 \"message_thread_id\": ${TG_TOPIC_ID}
}"

REQUEST_BODY="$(echo "${REQUEST_BODY}" | TG_EMOJI_ID="${TG_EMOJI_ID}" yq -M -o=json '.icon_custom_emoji_id=strenv(TG_EMOJI_ID)')"
if test $? -ne 0; then echo 'Request body error!'; exit 1; fi

# https://core.telegram.org/bots/api#editforumtopic

CODE=$(curl -m 8 -w '%{http_code}' -o /dev/null \
 "https://api.telegram.org/bot${TG_BOT_ID}:${TG_BOT_TOKEN}/editForumTopic" \
 -H 'Content-Type: application/json' \
 --data "${REQUEST_BODY}")

if test $? -ne 0; then
 echo 'Curl error!'; exit 1; fi

if [[ "${CODE}" != '200' ]]; then
 echo 'Edit topic emoji error!'; exit 1; fi
