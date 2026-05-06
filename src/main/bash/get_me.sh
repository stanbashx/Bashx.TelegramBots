#!/usr/local/bin/bash

if test $# -ne 1; then
 echo 'Wrong arguments!'; exit 1; fi

TG_FILEPATH="$1"

ARGUMENTS=(TG_BOT_ID TG_BOT_TOKEN TG_FILEPATH)
for (( INDEX=0; INDEX<${#ARGUMENTS[@]}; INDEX++ )); do
 ARGUMENT="${ARGUMENTS[INDEX]}"
 if test -z "${!ARGUMENT}"; then
  echo "Argument \"${ARGUMENT}\" is empty!"; exit $((100+INDEX)); fi
done

if test -f "${TG_FILEPATH}"; then
 echo "File \"${TG_FILEPATH}\" exists!"; exit 1; fi

# https://core.telegram.org/bots/api#getme

CODE=$(curl -m 8 -w '%{http_code}' -o "${TG_FILEPATH}" \
 "https://api.telegram.org/bot${TG_BOT_ID}:${TG_BOT_TOKEN}/getMe")

if test $? -ne 0; then
 echo 'Curl error!'; exit 1; fi

if [[ "${CODE}" != '200' ]]; then
 echo 'Get me error!'; exit 1; fi

if [[ ! -f "${TG_FILEPATH}" ]]; then
 echo "No file \"${TG_FILEPATH}\"!"; exit 1
elif [[ ! -s "${TG_FILEPATH}" ]]; then
 echo "File \"${TG_FILEPATH}\" is empty!"; exit 1
fi

TG_CHECKS="$(yq -e '.ok // false' "${TG_FILEPATH}" 2>/dev/null)"

if test $? -ne 0; then
 echo 'Parse error!'; exit 1; fi

if [[ "${TG_CHECKS}" != 'true' ]]; then
 echo 'Check error!'; exit 1; fi

RESPONSE_BOT_ID="$(yq -e '.result.id // ""' "${TG_FILEPATH}" 2>/dev/null)"

if test $? -ne 0; then
 echo 'Parse error!'; exit 1; fi

if [[ "${TG_BOT_ID}" != "${RESPONSE_BOT_ID}" ]]; then
 echo 'Wrong bot id!'; exit 1; fi
