#!/usr/local/bin/bash

if [[ $# -ne 3 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

TGBOTS_BOT_ID="$1"
TGBOTS_BOT_SECRET="$2"
TGBOTS_OUTPUT="$3"

if [[ -z "${TGBOTS_BOT_ID}" ]]; then
 echo 'No bot id!' >&2; exit 1
elif [[ ! "${TGBOTS_BOT_ID}" =~ ^[1-9][0-9]{7,15}$ ]]; then
 echo 'Wrong bot id!' >&2; exit 1
elif [[ -z "${TGBOTS_BOT_SECRET}" ]]; then
 echo 'No bot secret!' >&2; exit 1
elif [[ ! "${TGBOTS_BOT_SECRET}" =~ ^[a-zA-Z0-9_-]{35}$ ]]; then
 echo 'Wrong bot secret!' >&2; exit 1
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

# https://core.telegram.org/bots/api#getme

HTTP_CODE=$(curl -m 8 -w '%{http_code}' \
 "${TGBOTS_URL}/getMe" \
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

RESPONSE_BOT_ID="$(yq -Mr -p=json -o=json '.result.id // ""' "${TGBOTS_OUTPUT}" 2>/dev/null)"
if [[ "${TGBOTS_BOT_ID}" != "${RESPONSE_BOT_ID}" ]]; then
 echo 'Check bot id error!' >&2; exit 1; fi

RESPONSE_IS_BOT="$(yq -M -p=json -o=json '.result.is_bot // false' "${TGBOTS_OUTPUT}" 2>/dev/null)"
if [[ "${RESPONSE_IS_BOT}" != 'true' ]]; then
 echo 'Check bot error!' >&2; exit 1; fi
