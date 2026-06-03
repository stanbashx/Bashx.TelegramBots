#!/usr/local/bin/bash

if [[ $# -ne 3 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

TGBOTS_BOT_ID="$1"
TGBOTS_BOT_SECRET="$2"
TGBOTS_DST="$3"

if [[ -z "${TGBOTS_BOT_ID}" ]]; then
 echo 'No bot id!' >&2; exit 1
elif [[ ! "${TGBOTS_BOT_ID}" =~ ^[1-9][0-9]{7,15}$ ]]; then
 echo 'Wrong bot id!' >&2; exit 1
elif [[ -z "${TGBOTS_BOT_SECRET}" ]]; then
 echo 'No bot secret!' >&2; exit 1
elif [[ ! "${TGBOTS_BOT_SECRET}" =~ ^[a-zA-Z0-9_-]{35}$ ]]; then
 echo 'Wrong bot secret!' >&2; exit 1
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

TGBOTS_URL="https://api.telegram.org/bot${TGBOTS_BOT_ID}:${TGBOTS_BOT_SECRET}"

# https://core.telegram.org/bots/api#getme

HTTP_CODE=$(curl -m 8 -w '%{http_code}' \
 "${TGBOTS_URL}/getMe" \
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

RESPONSE_BOT_ID="$(yq -Mr -p=json -o=json '.result.id // ""' "${TGBOTS_DST}" 2>/dev/null)"
if [[ "${TGBOTS_BOT_ID}" != "${RESPONSE_BOT_ID}" ]]; then
 echo 'Check bot id error!' >&2; exit 1; fi

RESPONSE_IS_BOT="$(yq -M -p=json -o=json '.result.is_bot // false' "${TGBOTS_DST}" 2>/dev/null)"
if [[ "${RESPONSE_IS_BOT}" != 'true' ]]; then
 echo 'Check bot error!' >&2; exit 1; fi
