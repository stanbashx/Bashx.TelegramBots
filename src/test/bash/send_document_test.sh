#!/usr/local/bin/bash

SCRIPT='src/main/bash/send_document.sh'

echo "Running test of \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has wrong syntax!" >&2; exit 1; fi

STDERR="$(mktemp)"

"${SCRIPT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong arguments!'

:> "${STDERR}"
"${SCRIPT}" '' '' '' '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong arguments!'

:> "${STDERR}"
"${SCRIPT}" '' '' '' '' '' '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong arguments!'

echo 'Not implemented!' >&2; exit 1 # todo

:> "${STDERR}"
"${SCRIPT}" '' '' '' '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'No bot id!'

TGBOTS_BOT_IDS=('a' '1234567' '12345678901234567' '01234567' '123456a')
for TGBOTS_BOT_ID in "${TGBOTS_BOT_IDS[@]}"; do
 :> "${STDERR}"
 "${SCRIPT}" "${TGBOTS_BOT_ID}" '' '' '' '' 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/strings/eq.sh "Check bot id(${#TGBOTS_BOT_ID}): \"${TGBOTS_BOT_ID}\"" "$(<"${STDERR}")" 'Wrong bot id!'
done

TGBOTS_BOT_ID='1234567890123456'
:> "${STDERR}"
"${SCRIPT}" "${TGBOTS_BOT_ID}" '' '' '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'No bot secret!'

TGBOTS_BOT_ID='12345678'
:> "${STDERR}"
"${SCRIPT}" "${TGBOTS_BOT_ID}" '' '' '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'No bot secret!'

TGBOTS_BOT_SECRETS=('a' "$(printf '%.1s' {1..34})" "$(printf '%.1s' {1..36})" "$(printf '%.1s' {1..34})?")
for TGBOTS_BOT_SECRET in "${TGBOTS_BOT_SECRETS[@]}"; do
 :> "${STDERR}"
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" '' '' '' 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/strings/eq.sh "Check bot secret(${#TGBOTS_BOT_SECRET}): \"${TGBOTS_BOT_SECRET}\"" "$(<"${STDERR}")" 'Wrong bot secret!'
done

TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"

:> "${STDERR}"
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" '' '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'No chat id!'

TGBOTS_CHAT_IDS=('a' '0' '-0' '1a')
for TGBOTS_CHAT_ID in "${TGBOTS_CHAT_IDS[@]}"; do
 :> "${STDERR}"
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" '' '' 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/strings/eq.sh "Check chat id(${#TGBOTS_CHAT_ID}): \"${TGBOTS_CHAT_ID}\"" "$(<"${STDERR}")" 'Wrong chat id!'
done

TGBOTS_CHAT_ID=1

:> "${STDERR}"
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" '' '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'No message!'

:> "${STDERR}"
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "$(printf '%.1s' {1..4097})" '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong message size!'

TGBOTS_MESSAGE="$(printf '%.1s' {1..4096})"

:> "${STDERR}"
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'No output!'

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

HTTP_CODES=(2 20 22 202 2000 401 403 429 500 '' 'foo')
for HTTP_CODE in "${HTTP_CODES[@]}"; do
 :> "${STDERR}"
 PATH="src/test/bash/mocks:${PATH}" \
  MOCKS_CURL_HTTP_CODE="${HTTP_CODE}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/strings/eq.sh "Check http code(${#HTTP_CODE}): \"${HTTP_CODE}\"" "$(<"${STDERR}")" 'Code error!'
done

:> "${STDERR}"
PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_OUTPUT_TYPE='symlink' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_OUTPUT}\" is a symlink!"
rm "${TGBOTS_OUTPUT}"

:> "${STDERR}"
PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_OUTPUT_TYPE='dir' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_OUTPUT}\" is not a file!"
rm -rf "${TGBOTS_OUTPUT}"

:> "${STDERR}"
PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_OUTPUT_TYPE='file' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_OUTPUT}\" is empty!"
rm "${TGBOTS_OUTPUT}"

:> "${STDERR}"
PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_OUTPUT='' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_OUTPUT}\" does not exist!"

:> "${STDERR}"
PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_OUTPUT='foo' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Parse output error!'
rm "${TGBOTS_OUTPUT}"

:> "${STDERR}"
PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_OUTPUT='{}0' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Parse output error!'
rm "${TGBOTS_OUTPUT}"

:> "${STDERR}"
PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_OUTPUT='{"ok":false}' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Check output error!'
rm "${TGBOTS_OUTPUT}"

:> "${STDERR}"
PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_OUTPUT='{"ok":"true"}' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Check output error!'
rm "${TGBOTS_OUTPUT}"

MOCKS_CURL_DATA_PATH="$(mktemp)"

:> "${STDERR}"
PATH="src/test/bash/mocks:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_DATA_PATH="${MOCKS_CURL_DATA_PATH}" \
 MOCKS_CURL_OUTPUT='{"ok":true}' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_OUTPUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/strings/empty.sh "${SCRIPT}" "$(<"${STDERR}")"
. $asserts/files/not_empty.sh "${TGBOTS_OUTPUT}"
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${TGBOTS_OUTPUT}")" '{"ok":true}'
. $asserts/strings/eq.sh "${SCRIPT}" "$(yq -Mr -p=json -o=json .chat_id "${MOCKS_CURL_DATA_PATH}")" "${TGBOTS_CHAT_ID}"
. $asserts/strings/eq.sh "${SCRIPT}" "$(yq -Mr -p=json -o=json .text "${MOCKS_CURL_DATA_PATH}")" "${TGBOTS_MESSAGE}"
rm "${MOCKS_CURL_DATA_PATH}"
rm "${TGBOTS_OUTPUT}"

rm "${STDERR}"
