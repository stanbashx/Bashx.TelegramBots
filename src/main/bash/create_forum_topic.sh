#!/usr/local/bin/bash

if [[ $# -ne 5 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

TGBOTS_BOT_ID="$1"
if [[ -z "${TGBOTS_BOT_ID}" ]]; then
 echo 'No bot id!' >&2; exit 1
elif [[ ! "${TGBOTS_BOT_ID}" =~ ^[1-9][0-9]{7,15}$ ]]; then
 echo 'Wrong bot id!' >&2; exit 1
fi

TGBOTS_BOT_SECRET_SRC="$2"
if [[ -z "${TGBOTS_BOT_SECRET_SRC}" ]]; then
 echo 'No bot secret src!' >&2; exit 1
elif [[ ! "${TGBOTS_BOT_SECRET_SRC}" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
 echo 'Wrong bot secret src!' >&2; exit 1
elif [[ ! -v "${TGBOTS_BOT_SECRET_SRC}" ]]; then
 echo 'Bot secret is unset!' >&2; exit 1
elif [[ -z "${!TGBOTS_BOT_SECRET_SRC}" ]]; then
 echo 'No bot secret!' >&2; exit 1
elif [[ ! "${!TGBOTS_BOT_SECRET_SRC}" =~ ^[a-zA-Z0-9_-]{35}$ ]]; then
 echo 'Wrong bot secret!' >&2; exit 1
fi

TGBOTS_CHAT_ID="$3"
if [[ -z "${TGBOTS_CHAT_ID}" ]]; then
 echo 'No chat id!' >&2; exit 1
elif [[ ! "${TGBOTS_CHAT_ID}" =~ ^-?[1-9][0-9]*$ ]]; then
 echo 'Wrong chat id!' >&2; exit 1
fi

TGBOTS_TOPIC_NAME="$4"
if [[ -z "${TGBOTS_TOPIC_NAME}" ]]; then
 echo 'No topic name!' >&2; exit 1
elif [[ "${#TGBOTS_TOPIC_NAME}" -gt 128 ]]; then
 echo 'Wrong topic name size!' >&2; exit 1
fi

TGBOTS_DST="$5"
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

TGBOTS_REQUEST_BODY="{\"chat_id\":${TGBOTS_CHAT_ID}}"

TGBOTS_REQUEST_BODY="$(printf '%s' "${TGBOTS_REQUEST_BODY}" | \
 STR_VALUE="${TGBOTS_TOPIC_NAME}" \
 yq -M -I=0 -p=json -o=json '.name=strenv(STR_VALUE)')"

TGBOTS_URL='https://api.telegram.org'

# https://core.telegram.org/bots/api#createforumtopic

HTTP_CODE=$(curl -m 8 -w '%{http_code}' \
 -K <(printf 'url="%s/bot%s:%s/createForumTopic"' "${TGBOTS_URL}" "${TGBOTS_BOT_ID}" "${!TGBOTS_BOT_SECRET_SRC}") \
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

TGBOTS_TOPIC_ID="$(yq -M -p=json -o=json '.result.message_thread_id // ""' "${TGBOTS_DST}" 2>/dev/null)"
if [[ ! "${TGBOTS_TOPIC_ID}" =~ ^[1-9][0-9]*$ ]]; then
 echo 'Check topic error!' >&2; exit 1; fi
