#!/usr/local/bin/bash

SCRIPT='src/main/bash/send_message.sh'

echo "Running test of \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has wrong syntax!" >&2; exit 1; fi

STDERR="$(mktemp)"

"${SCRIPT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong arguments!'

:> "${STDERR}"

"${SCRIPT}" '' '' '' '' '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong arguments!'

:> "${STDERR}"

"${SCRIPT}" '' '' '' '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'No bot id!'

:> "${STDERR}"

"${SCRIPT}" 'a' '' '' '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong bot id!'

TGBOTS_BOT_ID='10000000'

:> "${STDERR}"

"${SCRIPT}" "${TGBOTS_BOT_ID}" '' '' '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'No bot secret!'

:> "${STDERR}"

"${SCRIPT}" "${TGBOTS_BOT_ID}" 'a' '' '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong bot secret!'

TGBOTS_BOT_SECRET='123456789012345678901234567890abcde'

:> "${STDERR}"

"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" '' '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'No chat id!'

:> "${STDERR}"

"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" 'a' '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong chat id!'

TGBOTS_CHAT_ID=1

:> "${STDERR}"

"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'No message!'

:> "${STDERR}"

"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "$(printf '%.1s' {0..4096})" '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong message size!'

TGBOTS_MESSAGE='foo'

:> "${STDERR}"

"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'No output!'

:> "${STDERR}"

TGBOTS_OUTPUT="$(mktemp -d)"
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_OUTPUT}\" is not a file!"
rm -rf "${TGBOTS_OUTPUT}"

:> "${STDERR}"

TGBOTS_OUTPUT="$(mktemp)"
rm "${TGBOTS_OUTPUT}"
ln -s "${TGBOTS_OUTPUT}" "${TGBOTS_OUTPUT}"
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_OUTPUT}\" is a symlink!"
rm "${TGBOTS_OUTPUT}"

:> "${STDERR}"

TGBOTS_OUTPUT="$(mktemp)"
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_OUTPUT}\" exists!"
rm "${TGBOTS_OUTPUT}"

:> "${STDERR}"

PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_EXIT_CODE=1 \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Request error!'

:> "${STDERR}"

PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_CODE=500 \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Send tg message error!'

MOCKS_CURL_DATA_PATH="$(mktemp)"

:> "${STDERR}"

PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_CODE=200 \
 MOCKS_CURL_DATA_PATH="${MOCKS_CURL_DATA_PATH}" \
 MOCKS_CURL_OUTPUT='foo' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Parse output error!'
rm "${MOCKS_CURL_DATA_PATH}"
rm "${TGBOTS_OUTPUT}"

:> "${STDERR}"

PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_CODE=200 \
 MOCKS_CURL_DATA_PATH="${MOCKS_CURL_DATA_PATH}" \
 MOCKS_CURL_OUTPUT='{"ok":false}' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Check output error!'
rm "${MOCKS_CURL_DATA_PATH}"
rm "${TGBOTS_OUTPUT}"

:> "${STDERR}"

PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_CODE=200 \
 MOCKS_CURL_DATA_PATH="${MOCKS_CURL_DATA_PATH}" \
 MOCKS_CURL_OUTPUT='{"ok":true}' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/strings/empty.sh "${SCRIPT}" "$(<"${STDERR}")"
. $asserts/strings/eq.sh "${SCRIPT}" "$(yq -Mr -p=json -o=json .chat_id "${MOCKS_CURL_DATA_PATH}")" "${TGBOTS_CHAT_ID}"
. $asserts/strings/eq.sh "${SCRIPT}" "$(yq -Mr -p=json -o=json .text "${MOCKS_CURL_DATA_PATH}")" "${TGBOTS_MESSAGE}"
rm "${MOCKS_CURL_DATA_PATH}"
rm "${TGBOTS_OUTPUT}"

rm "${STDERR}"
