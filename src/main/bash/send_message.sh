#!/usr/local/bin/bash

if [[ $# -ne 4 ]]; then
 echo 'Wrong arguments!'; exit 1; fi

TGBOTS_BOT_ID="$1"
TGBOTS_BOT_TOKEN="$2"
TGBOTS_CHAT_ID="$3"
TGBOTS_MESSAGE="$4"

args=(TGBOTS_BOT_ID TGBOTS_BOT_TOKEN TGBOTS_CHAT_ID TGBOTS_MESSAGE)
for ((i=0; i<${#args[@]}; i++ )); do
 arg="${args[i]}"
 if [[ -z "${!arg}" ]]; then
  echo "\"${arg}\" is empty!"; exit 1; fi
done

if [[ ! "${TGBOTS_CHAT_ID}" =~ ^-?[0-9]+$ ]]; then
 echo 'Wrong chat id!'; exit 1; fi

TGBOTS_PARSE_MODE='Markdown'

REQUEST_BODY='{}'

REQUEST_BODY="$(printf '%s' "${REQUEST_BODY}" | \
 STR_VALUE="${TGBOTS_PARSE_MODE}" \
 yq -Me -p=json -o=json '.parse_mode=strenv(STR_VALUE)')" || exit 1
REQUEST_BODY="$(printf '%s' "${REQUEST_BODY}" | \
 yq -Me -p=json -o=json '.link_preview_options.is_disabled=true')" || exit 1
REQUEST_BODY="$(printf '%s' "${REQUEST_BODY}" | \
 yq -Me -p=json -o=json ".chat_id=${TGBOTS_CHAT_ID}")" || exit 1
REQUEST_BODY="$(printf '%s' "${REQUEST_BODY}" | \
 STR_VALUE="${TGBOTS_MESSAGE}" \
 yq -Me -p=json -o=json '.text=strenv(STR_VALUE)')" || exit 1

echo "${REQUEST_BODY}" | yq

echo 'Not implemented!'; exit 1 # todo

TGBOTS_URL="https://api.telegram.org/bot${TGBOTS_BOT_ID}:${TGBOTS_BOT_TOKEN}"

# https://core.telegram.org/bots/api#sendmessage

CODE=$(curl -m 8 -w %{http_code} -o /dev/null \
 "${TGBOTS_URL}/sendMessage" \
 -H 'Content-Type: application/json' \
 --data "${REQUEST_BODY}")

if [[ $? -ne 0 ]]; then
 echo 'Curl error!'; exit 1
elif [[ "${CODE}" != '200' ]]; then
 echo 'Send tg message error!'; exit 1
fi
