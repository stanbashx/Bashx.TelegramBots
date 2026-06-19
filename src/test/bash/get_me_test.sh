#!/usr/local/bin/bash

SCRIPT='src/main/bash/get_me.sh'

echo "Running test for \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! /usr/local/bin/bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has invalid syntax!" >&2; exit 1; fi

STDOUT="$(mktemp)"
STDERR="$(mktemp)"

#

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' '' '' >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

#

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID=''
"${SCRIPT}" "${TGBOTS_BOT_ID}" '' '' >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No bot id!\n'

TGBOTS_BOT_IDS=('a' '1234567' '12345678901234567' '01234567' '123456a')
for TGBOTS_BOT_ID in "${TGBOTS_BOT_IDS[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 "${SCRIPT}" "${TGBOTS_BOT_ID}" '' '' >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" $'Wrong bot id!\n'
done

TGBOTS_BOT_IDS=('12345678' '1234567890123456')
for TGBOTS_BOT_ID in "${TGBOTS_BOT_IDS[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 TGBOTS_BOT_SECRET=''
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" '' >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" $'No bot secret!\n'
done

TGBOTS_BOT_SECRETS=('a' "$(printf '%.1s' {1..34})" "$(printf '%.1s' {1..36})" "$(printf '%.1s' {1..34})?")
for TGBOTS_BOT_SECRET in "${TGBOTS_BOT_SECRETS[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 TGBOTS_BOT_ID='12345678'
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" '' >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" $'Wrong bot secret!\n'
done

#

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_DST=''
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_DST}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No dst!\n'

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_DST="$(mktemp -d)"
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_DST}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${TGBOTS_DST}\" is not a file!"$'\n'
rm -r "${TGBOTS_DST}"

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_DST="$(mktemp)"
rm "${TGBOTS_DST}"
ln -s "${TGBOTS_DST}" "${TGBOTS_DST}"
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_DST}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${TGBOTS_DST}\" is a symlink!"$'\n'
rm "${TGBOTS_DST}"

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_DST="$(mktemp)"
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_DST}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${TGBOTS_DST}\" exists!"$'\n'
rm "${TGBOTS_DST}"

#

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_DST="$(mktemp)"
rm "${TGBOTS_DST}"
PATH="${mocks}/curl/bin:${PATH}" \
 MOCKS_CURL_EXIT_CODE=1 \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_DST}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Request error!\n'
. $asserts/files/not_exists.sh "${TGBOTS_DST}"

HTTP_CODES=(2 20 22 202 2000 401 403 429 500 '' 'foo' '-1' '200 ' ' 200' $'\n200' $'\t200')
for HTTP_CODE in "${HTTP_CODES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 TGBOTS_BOT_ID='12345678'
 TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
 TGBOTS_DST="$(mktemp)"
 rm "${TGBOTS_DST}"
 PATH="${mocks}/curl/bin:${PATH}" \
  MOCKS_CURL_HTTP_CODE="${HTTP_CODE}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_DST}" >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" $'Code error!\n'
 . $asserts/files/not_exists.sh "${TGBOTS_DST}"
done

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_DST="$(mktemp)"
rm "${TGBOTS_DST}"
PATH="${mocks}/curl/bin:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_DST}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${TGBOTS_DST}\" does not exist!"$'\n'
. $asserts/files/not_exists.sh "${TGBOTS_DST}"

#

VALUES=('foo' '{}0' '[]' 'null' '42')
for MOCKS_CURL_DST in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 TGBOTS_BOT_ID='12345678'
 TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
 TGBOTS_DST="$(mktemp)"
 rm "${TGBOTS_DST}"
 PATH="${mocks}/curl/bin:${PATH}" \
  MOCKS_CURL_HTTP_CODE=200 \
  MOCKS_CURL_DST="${MOCKS_CURL_DST}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_DST}" >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" $'Parse dst error!\n'
 rm "${TGBOTS_DST}"
done

VALUES=('{}' '{"ok":null}' '{"ok":{}}' '{"ok":[]}' '{"ok":0}' '{"ok":1}' '{"ok":-1}' '{"ok":""}' '{"ok":"true"}' '{"ok":false}')
for MOCKS_CURL_DST in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 TGBOTS_BOT_ID='12345678'
 TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
 TGBOTS_DST="$(mktemp)"
 rm "${TGBOTS_DST}"
 PATH="${mocks}/curl/bin:${PATH}" \
  MOCKS_CURL_HTTP_CODE=200 \
  MOCKS_CURL_DST="${MOCKS_CURL_DST}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_DST}" >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" $'Check dst error!\n'
 rm "${TGBOTS_DST}"
done

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_DST="$(mktemp)"
rm "${TGBOTS_DST}"
PATH="${mocks}/curl/bin:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_DST='{"ok":true}' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_DST}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}"  $'Check bot id error!\n'
rm "${TGBOTS_DST}"

TGBOTS_BOT_ID='12345678'
VALUES=(
 '{"ok":true,"result":{"id":"'${TGBOTS_BOT_ID}'"}}'
 '{"ok":true,"result":{"id":"'${TGBOTS_BOT_ID}'","is_bot":null}}'
 '{"ok":true,"result":{"id":"'${TGBOTS_BOT_ID}'","is_bot":{}}}'
 '{"ok":true,"result":{"id":"'${TGBOTS_BOT_ID}'","is_bot":[]}}'
 '{"ok":true,"result":{"id":"'${TGBOTS_BOT_ID}'","is_bot":1}}'
 '{"ok":true,"result":{"id":"'${TGBOTS_BOT_ID}'","is_bot":"true"}}'
)
for MOCKS_CURL_DST in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
 TGBOTS_DST="$(mktemp)"
 rm "${TGBOTS_DST}"
 PATH="${mocks}/curl/bin:${PATH}" \
  MOCKS_CURL_HTTP_CODE=200 \
  MOCKS_CURL_DST="${MOCKS_CURL_DST}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_DST}" >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" $'Check bot error!\n'
 rm "${TGBOTS_DST}"
done

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_DST="$(mktemp)"
rm "${TGBOTS_DST}"
MOCKS_CURL_DST='{"ok":true,"result":{"id":"'${TGBOTS_BOT_ID}'","is_bot":true}}'
PATH="${mocks}/curl/bin:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_DST="${MOCKS_CURL_DST}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_DST}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"
. $asserts/files/equals.sh "${TGBOTS_DST}" "${MOCKS_CURL_DST}"
rm "${TGBOTS_DST}"

#

rm "${STDOUT}"
rm "${STDERR}"
