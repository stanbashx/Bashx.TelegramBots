#!/usr/local/bin/bash

if [[ $# -ne 6 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

TGBOTS_BOT_ID="$1"
TGBOTS_BOT_SECRET="$2"
TGBOTS_CHAT_ID="$3"
TGBOTS_MESSAGE="$4"
TGBOTS_INPUT="$5"
TGBOTS_OUTPUT="$6"

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
elif [[ "${#TGBOTS_MESSAGE}" -gt 1024 ]]; then
 echo 'Wrong message size!' >&2; exit 1
fi

if [[ -z "${TGBOTS_INPUT}" ]]; then
 echo 'No input!' >&2; exit 1
elif [[ -L "${TGBOTS_INPUT}" ]]; then
 echo "\"${TGBOTS_INPUT}\" is a symlink!" >&2; exit 1
elif [[ ! -e "${TGBOTS_INPUT}" ]]; then
 echo "\"${TGBOTS_INPUT}\" does not exist!" >&2; exit 1
elif [[ ! -f "${TGBOTS_INPUT}" ]]; then
 echo "\"${TGBOTS_INPUT}\" is not a file!" >&2; exit 1
elif [[ ! -s "${TGBOTS_INPUT}" ]]; then
 echo "\"${TGBOTS_INPUT}\" is empty!" >&2; exit 1
fi

TGBOTS_INPUT_SIZE="$(stat -c %s "${TGBOTS_INPUT}")"
if [[ $? -ne 0 || ! "${TGBOTS_INPUT_SIZE}" =~ ^[1-9][0-9]*$ ]]; then
 echo 'Get file size error!' >&2; exit 1
elif [[ "${TGBOTS_INPUT_SIZE}" -gt 32000000 ]]; then
 echo "\"${TGBOTS_INPUT}\" has wrong size!" >&2; exit 1
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

TGBOTS_URL="https://api.telegram.org/bot${TGBOTS_BOT_ID}:${TGBOTS_BOT_SECRET}"

# https://core.telegram.org/bots/api#senddocument

TGBOTS_REQUEST_ARGS=(
 --form-string "chat_id=${TGBOTS_CHAT_ID}"
)

if [[ -n "${TGBOTS_MESSAGE}" ]]; then
 TGBOTS_REQUEST_ARGS+=(
  --form-string "caption=${TGBOTS_MESSAGE}"
  --form-string 'parse_mode=Markdown'
 ); fi

HTTP_CODE=$(curl -m 8 -w '%{http_code}' \
 "${TGBOTS_URL}/sendDocument" \
 --form "document=@\"${TGBOTS_INPUT}\"" \
 "${TGBOTS_REQUEST_ARGS[@]}" \
 -o "${TGBOTS_OUTPUT}" 2>/dev/null)

if [[ $? -ne 0 ]]; then
 echo 'Request error!' >&2; exit 1
elif [[ "${HTTP_CODE}" != '200' ]]; then
 echo 'Code error!' >&2; exit 1
fi

if [[ -L "${TGBOTS_OUTPUT}" ]]; then
 echo "\"${TGBOTS_OUTPUT}\" is a symlink!" >&2; exit 1
elif [[ ! -e "${TGBOTS_OUTPUT}" ]]; then
 echo "\"${TGBOTS_OUTPUT}\" does not exist!" >&2; exit 1
elif [[ ! -f "${TGBOTS_OUTPUT}" ]]; then
 echo "\"${TGBOTS_OUTPUT}\" is not a file!" >&2; exit 1
elif [[ ! -s "${TGBOTS_OUTPUT}" ]]; then
 echo "\"${TGBOTS_OUTPUT}\" is empty!" >&2; exit 1
fi

TGBOTS_OUTPUT_TAGS="$(yq -Mer -p=json -o=json 'tag' "${TGBOTS_OUTPUT}" 2>/dev/null)"
if [[ $? -ne 0 || "${TGBOTS_OUTPUT_TAGS}" != '!!map' ]]; then
 echo 'Parse output error!' >&2; exit 1; fi

TGBOTS_CHECKS="$(yq -M -p=json -o=json '.ok // false' "${TGBOTS_OUTPUT}" 2>/dev/null)"
if [[ "${TGBOTS_CHECKS}" != 'true' ]]; then
 echo 'Check output error!' >&2; exit 1; fi
