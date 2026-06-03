#!/usr/local/bin/bash

if [[ $# -ne 5 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

TGBOTS_BOT_ID="$1"
TGBOTS_BOT_SECRET="$2"
TGBOTS_CHAT_ID="$3"
TGBOTS_MESSAGE="$4"
TGBOTS_DST="$5"

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

if [[ -z "${TGBOTS_DST}" ]]; then
 echo 'No dst!' >&2; exit 1
elif [[ -L "${TGBOTS_DST}" ]]; then
 echo "\"${TGBOTS_DST}\" is a symlink!" >&2; exit 1
elif [[ -e "${TGBOTS_DST}" ]]; then
 if [[ -f "${TGBOTS_DST}" ]]; then
  echo "\"${TGBOTS_DST}\" exists!" >&2; exit 1
 else
  echo "\"${TGBOTS_DST}\" is not a file!" >&2; exit 1
 fi
fi

TGBOTS_REQUEST_BODY="{
\"chat_id\":${TGBOTS_CHAT_ID},
\"parse_mode\":\"Markdown\",
\"link_preview_options\":{\"is_disabled\":true}}"

TGBOTS_REQUEST_BODY="$(printf '%s' "${TGBOTS_REQUEST_BODY}" | \
 STR_VALUE="${TGBOTS_MESSAGE}" \
 yq -M -I=0 -p=json -o=json '.text=strenv(STR_VALUE)')"

TGBOTS_URL="https://api.telegram.org/bot${TGBOTS_BOT_ID}:${TGBOTS_BOT_SECRET}"

# https://core.telegram.org/bots/api#sendmessage

HTTP_CODE=$(curl -m 8 -w '%{http_code}' \
 "${TGBOTS_URL}/sendMessage" \
 -H 'Content-Type: application/json' \
 --data "${TGBOTS_REQUEST_BODY}" \
 -o "${TGBOTS_DST}" 2>/dev/null)

if [[ $? -ne 0 ]]; then
 echo 'Request error!' >&2; exit 1
elif [[ "${HTTP_CODE}" != '200' ]]; then
 echo 'Code error!' >&2; exit 1
fi

if [[ -L "${TGBOTS_DST}" ]]; then
 echo "\"${TGBOTS_DST}\" is a symlink!" >&2; exit 1
elif [[ ! -e "${TGBOTS_DST}" ]]; then
 echo "\"${TGBOTS_DST}\" does not exist!" >&2; exit 1
elif [[ ! -f "${TGBOTS_DST}" ]]; then
 echo "\"${TGBOTS_DST}\" is not a file!" >&2; exit 1
elif [[ ! -s "${TGBOTS_DST}" ]]; then
 echo "\"${TGBOTS_DST}\" is empty!" >&2; exit 1
fi

TGBOTS_DST_TAGS="$(yq -Mer -p=json -o=json 'tag' "${TGBOTS_DST}" 2>/dev/null)"
if [[ $? -ne 0 || "${TGBOTS_DST_TAGS}" != '!!map' ]]; then
 echo 'Parse dst error!' >&2; exit 1; fi

TGBOTS_CHECKS="$(yq -M -p=json -o=json '.ok // false' "${TGBOTS_DST}" 2>/dev/null)"
if [[ "${TGBOTS_CHECKS}" != 'true' ]]; then
 echo 'Check dst error!' >&2; exit 1; fi
