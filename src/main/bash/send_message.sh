#!/usr/local/bin/bash

unset TGBOTS_BOT_ID
unset TGBOTS_BOT_SECRET_SRC
unset TGBOTS_CHAT_ID
unset TGBOTS_TOPIC_ID
unset TGBOTS_MESSAGE
unset TGBOTS_DST
unset TGBOTS_PARSE_MODE

while [[ $# -gt 1 ]]; do
 case "$1" in
  '--bot_id')
   if [[ -v TGBOTS_BOT_ID ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   TGBOTS_BOT_ID="$2"; shift 2;;
  '--bot_secret_src')
   if [[ -v TGBOTS_BOT_SECRET_SRC ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   TGBOTS_BOT_SECRET_SRC="$2"; shift 2;;
  '--chat_id')
   if [[ -v TGBOTS_CHAT_ID ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   TGBOTS_CHAT_ID="$2"; shift 2;;
  '--topic_id')
   if [[ -v TGBOTS_TOPIC_ID ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   TGBOTS_TOPIC_ID="$2"; shift 2;;
  '--message')
   if [[ -v TGBOTS_MESSAGE ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   TGBOTS_MESSAGE="$2"; shift 2;;
  '--dst')
   if [[ -v TGBOTS_DST ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   TGBOTS_DST="$2"; shift 2;;
  '--parse_mode')
   if [[ -v TGBOTS_PARSE_MODE ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   TGBOTS_PARSE_MODE="$2"; shift 2;;
  *) echo "\"$1\" is not supported!" >&2; exit 1;;
 esac
done

if [[ -z "${TGBOTS_BOT_ID}" ]]; then
 echo 'No bot id!' >&2; exit 1
elif [[ ! "${TGBOTS_BOT_ID}" =~ ^[1-9][0-9]{7,15}$ ]]; then
 echo 'Wrong bot id!' >&2; exit 1
fi

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

if [[ -z "${TGBOTS_CHAT_ID}" ]]; then
 echo 'No chat id!' >&2; exit 1
elif [[ ! "${TGBOTS_CHAT_ID}" =~ ^-?[1-9][0-9]*$ ]]; then
 echo 'Wrong chat id!' >&2; exit 1
fi

if [[ -v TGBOTS_TOPIC_ID ]]; then
 if [[ -z "${TGBOTS_TOPIC_ID}" ]]; then
  echo 'No topic id!' >&2; exit 1
 elif [[ ! "${TGBOTS_TOPIC_ID}" =~ ^[1-9][0-9]*$ ]]; then
  echo 'Wrong topic id!' >&2; exit 1
 fi
fi

if [[ -z "${TGBOTS_MESSAGE}" ]]; then
 echo 'No message!' >&2; exit 1
elif [[ "${#TGBOTS_MESSAGE}" -gt 4096 ]]; then
 echo 'Wrong message size!' >&2; exit 1
fi

if [[ -v TGBOTS_DST ]]; then
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
fi

if [[ -v TGBOTS_PARSE_MODE ]]; then
 case "${TGBOTS_PARSE_MODE}" in
  'Markdown');;
  '') echo 'No parse mode id!' >&2; exit 1;;
  *) echo "\"${TGBOTS_PARSE_MODE}\" is not supported!" >&2; exit 1;;
 esac
fi

TGBOTS_REQUEST_BODY="{
\"chat_id\":${TGBOTS_CHAT_ID},
\"link_preview_options\":{\"is_disabled\":true}}"

TGBOTS_REQUEST_BODY="$(printf '%s' "${TGBOTS_REQUEST_BODY}" | \
 STR_VALUE="${TGBOTS_MESSAGE}" \
 yq -M -I=0 -p=json -o=json '.text=strenv(STR_VALUE)')"

if [[ -v TGBOTS_TOPIC_ID ]]; then
 TGBOTS_REQUEST_BODY="$(printf '%s' "${TGBOTS_REQUEST_BODY}" | \
  yq -M -I=0 -p=json -o=json ".message_thread_id=${TGBOTS_TOPIC_ID}")"
fi

if [[ -v TGBOTS_PARSE_MODE ]]; then
 TGBOTS_REQUEST_BODY="$(printf '%s' "${TGBOTS_REQUEST_BODY}" | \
  STR_VALUE="${TGBOTS_PARSE_MODE}" \
  yq -M -I=0 -p=json -o=json '.parse_mode=strenv(STR_VALUE)')"
fi

TGBOTS_URL='https://api.telegram.org'

# https://core.telegram.org/bots/api#sendmessage

HTTP_CODE=$(curl -m 8 -w '%{http_code}' \
 -K <(printf 'url="%s/bot%s:%s/sendMessage"' "${TGBOTS_URL}" "${TGBOTS_BOT_ID}" "${!TGBOTS_BOT_SECRET_SRC}") \
 -H 'Content-Type: application/json' \
 --data "${TGBOTS_REQUEST_BODY}" \
 -o /dev/null 2>/dev/null)

#if [[ $? -ne 0 ]]; then
# echo 'Request error!' >&2; exit 1; fi

#if [[ "${HTTP_CODE}" != '200' ]]; then
# echo 'Code error!' >&2; exit 1; fi

#if [[ -L "${TGBOTS_DST}" ]]; then
# echo "\"${TGBOTS_DST}\" is a symlink!" >&2; exit 1
#elif [[ ! -e "${TGBOTS_DST}" ]]; then
# echo "\"${TGBOTS_DST}\" does not exist!" >&2; exit 1
#elif [[ ! -f "${TGBOTS_DST}" ]]; then
# echo "\"${TGBOTS_DST}\" is not a file!" >&2; exit 1
#elif [[ ! -s "${TGBOTS_DST}" ]]; then
# echo "\"${TGBOTS_DST}\" is empty!" >&2; exit 1
#fi

#TGBOTS_DST_TAGS="$(yq -Mer -p=json -o=json 'tag' "${TGBOTS_DST}" 2>/dev/null)"
#if [[ $? -ne 0 || "${TGBOTS_DST_TAGS}" != '!!map' ]]; then
# echo 'Parse dst error!' >&2; exit 1; fi

#TGBOTS_CHECKS="$(yq -M -p=json -o=json '.ok // false' "${TGBOTS_DST}" 2>/dev/null)"
#if [[ "${TGBOTS_CHECKS}" != 'true' ]]; then
# echo 'Check dst error!' >&2; exit 1; fi
