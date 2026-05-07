#!/usr/local/bin/bash

if test $# -ne 1; then
 echo 'Wrong arguments!'; exit 1; fi

TG_OUTPUT="$1"

ARGUMENTS=(TG_BOT_ID TG_BOT_TOKEN TG_OUTPUT)
for (( INDEX=0; INDEX<${#ARGUMENTS[@]}; INDEX++ )); do
 ARGUMENT="${ARGUMENTS[INDEX]}"
 if test -z "${!ARGUMENT}"; then
  echo "Argument \"${ARGUMENT}\" is empty!"; exit $((100+INDEX)); fi
done

if test -f "${TG_OUTPUT}"; then
 echo "File \"${TG_OUTPUT}\" exists!"; exit 1; fi

# https://core.telegram.org/bots/api#getforumtopiciconstickers

CODE=$(curl -m 8 -w '%{http_code}' -o "${TG_OUTPUT}" \
 "https://api.telegram.org/bot${TG_BOT_ID}:${TG_BOT_TOKEN}/getForumTopicIconStickers")

if test $? -ne 0; then
 echo 'Curl error!'; exit 1; fi

if [[ "${CODE}" != '200' ]]; then
 echo 'Get topic stickers error!'; exit 1; fi

if [[ ! -f "${TG_OUTPUT}" ]]; then
 echo "No file \"${TG_OUTPUT}\"!"; exit 1
elif [[ ! -s "${TG_OUTPUT}" ]]; then
 echo "File \"${TG_OUTPUT}\" is empty!"; exit 1
fi

TG_CHECKS="$(yq -e '.ok // false' "${TG_OUTPUT}" 2>/dev/null)"

if test $? -ne 0; then
 echo 'Parse error!'; exit 1; fi

if [[ "${TG_CHECKS}" != 'true' ]]; then
 echo 'Check error!'; exit 1; fi
