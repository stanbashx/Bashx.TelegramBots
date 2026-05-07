#!/usr/local/bin/bash

if test $# -ne 3; then
 echo 'Wrong arguments!'; exit 1; fi

TG_CHAT_ID="$1"
TG_TOPIC_NAME="$2"
TG_OUTPUT="$3"

ARGUMENTS=(TG_BOT_ID TG_BOT_TOKEN TG_CHAT_ID TG_TOPIC_NAME TG_OUTPUT)
for (( INDEX=0; INDEX<${#ARGUMENTS[@]}; INDEX++ )); do
 ARGUMENT="${ARGUMENTS[INDEX]}"
 if test -z "${!ARGUMENT}"; then
  echo "Argument \"$ARGUMENT\" is empty!"; exit $((100+INDEX)); fi
done

if [[ ! "${TG_CHAT_ID}" =~ ^-?[0-9]+$ ]]; then
 echo 'Wrong chat id!'; exit 1; fi

if test -f "${TG_OUTPUT}"; then
 echo "File \"${TG_OUTPUT}\" exists!"; exit 1; fi

REQUEST_BODY="{
 \"chat_id\": ${TG_CHAT_ID}
}"

REQUEST_BODY="$(echo "${REQUEST_BODY}" | TG_TOPIC_NAME="${TG_TOPIC_NAME}" yq -M -o=json '.name=strenv(TG_TOPIC_NAME)')"
if test $? -ne 0; then echo 'Request body error!'; exit 1; fi

# https://core.telegram.org/bots/api#createforumtopic

CODE=$(curl -m 8 -w '%{http_code}' -o "${TG_OUTPUT}" \
 "https://api.telegram.org/bot${TG_BOT_ID}:${TG_BOT_TOKEN}/createForumTopic" \
 -H 'Content-Type: application/json' \
 --data "${REQUEST_BODY}")

if test $? -ne 0; then
 echo 'Curl error!'; exit 1; fi

if [[ "${CODE}" != '200' ]]; then
 echo 'Create forum topic error!'; exit 1; fi

if [[ ! -f "${TG_OUTPUT}" ]]; then
 echo "No file \"${TG_OUTPUT}\"!"; exit 1
elif [[ ! -s "${TG_OUTPUT}" ]]; then
 echo "File \"${TG_OUTPUT}\" is empty!"; exit 1
fi

TG_CHECKS="$(yq -e '.ok // false' "${TG_OUTPUT}" 2>/dev/null)"

if test $? -ne 0; then
 echo 'Parse error!'; exit 1; fi

if [[ "${TG_CHECKS}" != 'true' ]]; then
 echo 'Check error!'; exit 1; fi
