#!/usr/local/bin/bash

if test $# -ne 2; then
 echo 'Wrong arguments!'; exit 1; fi

TG_MESSAGE="$1"
TG_INPUT="$2"

ARGUMENTS=(TG_BOT_ID TG_BOT_TOKEN TG_CHAT_ID TG_MESSAGE TG_INPUT)
for (( INDEX=0; INDEX<${#ARGUMENTS[@]}; INDEX++ )); do
 ARGUMENT="${ARGUMENTS[INDEX]}"
 if test -z "${!ARGUMENT}"; then
  echo "Argument \"$ARGUMENT\" is empty!"; exit $((100+INDEX)); fi
done

if [[ ! "${TG_CHAT_ID}" =~ ^-?[0-9]+$ ]]; then
 echo 'Wrong chat id!'; exit 1; fi

if [[ ! -f "${TG_INPUT}" ]]; then
 echo "No file \"${TG_INPUT}\"!"; exit 1
elif [[ ! -s "${TG_INPUT}" ]]; then
 echo "File \"${TG_INPUT}\" is empty!"; exit 1
fi

# https://core.telegram.org/bots/api#senddocument

CODE=$(curl -m 8 -w %{http_code} -o /dev/null \
 --form "document=@${TG_INPUT}" \
 --form-string "chat_id=${TG_CHAT_ID}" \
 --form-string "caption=${TG_MESSAGE}" \
 --form-string 'parse_mode=Markdown' \
 "https://api.telegram.org/bot${TG_BOT_ID}:${TG_BOT_TOKEN}/sendDocument")

if test $? -ne 0; then
 echo 'Curl error!'; exit 1; fi

if [[ "${CODE}" != '200' ]]; then
 echo 'Send tg document error!'; exit 1; fi
