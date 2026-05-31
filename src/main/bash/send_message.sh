#!/usr/local/bin/bash

if [[ $# -ne 5 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

TGBOTS_BOT_ID="$1"
TGBOTS_BOT_SECRET="$2"
TGBOTS_CHAT_ID="$3"
TGBOTS_MESSAGE="$4"
TGBOTS_OUTPUT="$5"

if [[ -z "${TGBOTS_BOT_ID}" ]]; then
 echo 'No bot id!' >&2; exit 1
elif [[ ! "${TGBOTS_BOT_ID}" =~ ^[1-9][0-9]{7,15}$ ]]; then
 echo 'Wrong bot id!' >&2; exit 1
elif [[ -z "${TGBOTS_BOT_SECRET}" ]]; then
 echo 'No bot secret!' >&2; exit 1
elif [[ ! "${TGBOTS_BOT_SECRET}" =~ ^[a-zA-Z0-9_-]{35}$ ]]; then
 echo 'Wrong bot secret!' >&2; exit 1
elif [[ -z "${TGBOTS_CHAT_ID}" ]]; then
 echo 'No chat id!' >&2; exit 1
elif [[ ! "${TGBOTS_CHAT_ID}" =~ ^-?[1-9][0-9]*$ ]]; then
 echo 'Wrong chat id!' >&2; exit 1
elif [[ -z "${TGBOTS_MESSAGE}" ]]; then
 echo 'No message!' >&2; exit 1
elif [[ "${#TGBOTS_MESSAGE}" -gt 4096 ]]; then
 echo 'Wrong message size!' >&2; exit 1
fi

if [[ -z "${TGBOTS_OUTPUT}" ]]; then
 echo 'No output!' >&2; exit 1
elif [[ -L "${TGBOTS_OUTPUT}" ]]; then
 echo "\"${TGBOTS_OUTPUT}\" is a symlink!" >&2; exit 1
elif [[ -e "${TGBOTS_OUTPUT}" ]]; then
 if [[ -f "${TGBOTS_OUTPUT}" ]]; then
  echo "\"${TGBOTS_OUTPUT}\" exists!" >&2; exit 1
 else
  echo "\"${TGBOTS_OUTPUT}\" is not a file!" >&2; exit 1
 fi
fi

TGBOTS_REQUEST_BODY="{
\"chat_id\":${TGBOTS_CHAT_ID},
\"parse_mode\":\"Markdown\",
\"link_preview_options\":{\"is_disabled\":true}}"

TGBOTS_REQUEST_BODY="$(printf '%s' "${TGBOTS_REQUEST_BODY}" | \
 STR_VALUE="${TGBOTS_MESSAGE}" \
 yq -Me -p=json -o=json '.text=strenv(STR_VALUE)')" || exit 1

TGBOTS_URL="https://api.telegram.org/bot${TGBOTS_BOT_ID}:${TGBOTS_BOT_SECRET}"

# https://core.telegram.org/bots/api#sendmessage

HTTP_CODE=$(curl -m 8 -w '%{http_code}' \
 "${TGBOTS_URL}/sendMessage" \
 -H 'Content-Type: application/json' \
 --data "${TGBOTS_REQUEST_BODY}" \
 -o "${TGBOTS_OUTPUT}" 2>/dev/null)

if [[ $? -ne 0 ]]; then
 echo 'Request error!' >&2; exit 1
elif [[ "${HTTP_CODE}" != '200' ]]; then
 echo 'Send tg message error!' >&2; exit 1
fi

if [[ ! -e "${TGBOTS_OUTPUT}" ]]; then
 echo "\"${TGBOTS_OUTPUT}\" does not exist!" >&2; exit 1
elif [[ ! -f "${TGBOTS_OUTPUT}" ]]; then
 echo "\"${TGBOTS_OUTPUT}\" is not a file!" >&2; exit 1
elif [[ ! -s "${TGBOTS_OUTPUT}" ]]; then
 echo "\"${TGBOTS_OUTPUT}\" is empty!" >&2; exit 1
fi

TGBOTS_CHECKS="$(yq -Mr -p=json -o=json '.ok // false' "${TGBOTS_OUTPUT}" 2>/dev/null)"
if [[ $? -ne 0 ]]; then
 echo 'Parse output error!' >&2; exit 1
elif [[ "${TGBOTS_CHECKS}" != 'true' ]]; then
 echo 'Check output error!' >&2; exit 1
fi
