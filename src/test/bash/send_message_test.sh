#!/usr/local/bin/bash

SCRIPT='src/main/bash/send_message.sh'

echo "Running test of \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has wrong syntax!" >&2; exit 1; fi

STDERR="$(mktemp)"

"${SCRIPT}" 2>"${STDERR}"; CODE=$?
. $asserts/strings/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong arguments!'

:> "${STDERR}"

"${SCRIPT}" '' '' '' '' '' 2>"${STDERR}"; CODE=$?
. $asserts/strings/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong arguments!'

:> "${STDERR}"

"${SCRIPT}" '' '' '' '' 2>"${STDERR}"; CODE=$?
. $asserts/strings/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" '"TGBOTS_BOT_ID" is empty!'

:> "${STDERR}"

"${SCRIPT}" 'a' '' '' '' 2>"${STDERR}"; CODE=$?
. $asserts/strings/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" '"TGBOTS_BOT_TOKEN" is empty!'

:> "${STDERR}"

"${SCRIPT}" 'a' 'b' '' '' 2>"${STDERR}"; CODE=$?
. $asserts/strings/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" '"TGBOTS_CHAT_ID" is empty!'

:> "${STDERR}"

"${SCRIPT}" 'a' 'b' 'c' '' 2>"${STDERR}"; CODE=$?
. $asserts/strings/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" '"TGBOTS_MESSAGE" is empty!'

:> "${STDERR}"

"${SCRIPT}" 'a' 'b' 'c' 'd' 2>"${STDERR}"; CODE=$?
. $asserts/strings/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong chat id!'

:> "${STDERR}"

PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_EXIT_CODE=1 \
 "${SCRIPT}" 'a' 'b' '1' 'd' 2>"${STDERR}"; CODE=$?
. $asserts/strings/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Curl error!'

:> "${STDERR}"

PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_CODE=500 \
 "${SCRIPT}" 'a' 'b' '1' 'd' 2>"${STDERR}"; CODE=$?
. $asserts/strings/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Send tg message error!'

:> "${STDERR}"

TGBOTS_CHAT_ID=1
TGBOTS_MESSAGE='d'
PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_CODE=200 \
 "${SCRIPT}" 'a' 'b' "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" 2>"${STDERR}"; CODE=$?
. $asserts/strings/eq.sh "${SCRIPT}" "${CODE}" '0'
. $asserts/strings/empty.sh "${SCRIPT}" "$(<"${STDERR}")"
. $asserts/strings/eq.sh "${SCRIPT}" "$(yq -Mr -p=json -o=json .chat_id 'build/tests/mocks_curl_data')" "${TGBOTS_CHAT_ID}"
. $asserts/strings/eq.sh "${SCRIPT}" "$(yq -Mr -p=json -o=json .text 'build/tests/mocks_curl_data')" "${TGBOTS_MESSAGE}"

rm "${STDERR}"
