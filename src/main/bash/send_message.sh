#!/usr/local/bin/bash

if [[ $# -ne 4 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

TGBOTS_BOT_ID="$1"
TGBOTS_BOT_TOKEN="$2"
TGBOTS_CHAT_ID="$3"
TGBOTS_MESSAGE="$4"

if [[ ! "${TGBOTS_BOT_ID}" =~ ^[1-9][0-9]{7,15}$ ]]; then
 echo 'Wrong bot id!' >&2; exit 1
elif [[ ! "${TGBOTS_BOT_TOKEN}" =~ ^AA[a-zA-Z0-9_-]{33}$ ]]; then
 echo 'Wrong bot token!' >&2; exit 1
elif [[ ! "${TGBOTS_CHAT_ID}" =~ ^-?[1-9][0-9]*$ ]]; then
 echo 'Wrong chat id!' >&2; exit 1
elif [[ -z "${TGBOTS_MESSAGE}" || "${#TGBOTS_MESSAGE}" -gt 4096 ]]; then
 echo 'Wrong message size!' >&2; exit 1
fi

TGBOTS_REQUEST_BODY="{
\"chat_id\":${TGBOTS_CHAT_ID},
\"parse_mode\":\"Markdown\",
\"link_preview_options\":{\"is_disabled\":true}}"

TGBOTS_REQUEST_BODY="$(printf '%s' "${TGBOTS_REQUEST_BODY}" | \
 STR_VALUE="${TGBOTS_MESSAGE}" \
 yq -Me -p=json -o=json '.text=strenv(STR_VALUE)')" || exit 1

TGBOTS_URL="https://api.telegram.org/bot${TGBOTS_BOT_ID}:${TGBOTS_BOT_TOKEN}"

# https://core.telegram.org/bots/api#sendmessage

CODE=$(curl -m 8 -w '%{http_code}' -o /dev/null \
 "${TGBOTS_URL}/sendMessage" \
 -H 'Content-Type: application/json' \
 --data "${TGBOTS_REQUEST_BODY}" \
 2>/dev/null)

if [[ $? -ne 0 ]]; then
 echo 'Curl error!' >&2; exit 1
elif [[ "${CODE}" != '200' ]]; then
 echo 'Send tg message error!' >&2; exit 1
fi
