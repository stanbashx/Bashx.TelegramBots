#!/usr/local/bin/bash

SCRIPT='src/main/bash/send_message.sh'

echo "Running test for \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! /usr/local/bin/bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has invalid syntax!" >&2; exit 1; fi

STDOUT="$(mktemp)"
STDERR="$(mktemp)"

#

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' '' '' '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

#

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID=''
TGBOTS_BOT_SECRET_SRC=''
TGBOTS_CHAT_ID=''
TGBOTS_MESSAGE=''
TGBOTS_DST=''
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No bot id!'$'\n'

VALUES=('a' '1234567' '12345678901234567' '01234567' '123456a')
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 TGBOTS_BOT_ID="${VALUE}"
 TGBOTS_BOT_SECRET_SRC=''
 TGBOTS_CHAT_ID=''
 TGBOTS_MESSAGE=''
 TGBOTS_DST=''
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" 'Wrong bot id!'$'\n'
done

#

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET_SRC=''
TGBOTS_CHAT_ID=''
TGBOTS_MESSAGE=''
TGBOTS_DST=''
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No bot secret src!'$'\n'

VALUES=($'\t' $'\n' '-TGBOTS_BOT_SECRET' '42TGBOTS_BOT_SECRET' 'TGBOTS_BOT_SECRET+')
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 TGBOTS_BOT_ID='12345678'
 TGBOTS_BOT_SECRET_SRC="${VALUE}"
 TGBOTS_CHAT_ID=''
 TGBOTS_MESSAGE=''
 TGBOTS_DST=''
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" 'Wrong bot secret src!'$'\n'
done

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID=''
TGBOTS_MESSAGE=''
TGBOTS_DST=''
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Bot secret is unset!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET=''
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID=''
TGBOTS_MESSAGE=''
TGBOTS_DST=''
TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No bot secret!'$'\n'

VALUES=('a' "$(printf '%.1s' {1..34})" "$(printf '%.1s' {1..36})" "$(printf '%.1s' {1..34})?")
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 TGBOTS_BOT_ID='12345678'
 TGBOTS_BOT_SECRET="${VALUE}"
 TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
 TGBOTS_CHAT_ID=''
 TGBOTS_MESSAGE=''
 TGBOTS_DST=''
 TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" 'Wrong bot secret!'$'\n'
done

#

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID=''
TGBOTS_MESSAGE=''
TGBOTS_DST=''
TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No chat id!'$'\n'

VALUES=('a' '0' '-0' '1a')
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 TGBOTS_BOT_ID='12345678'
 TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
 TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
 TGBOTS_CHAT_ID="${VALUE}"
 TGBOTS_MESSAGE=''
 TGBOTS_DST=''
 TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" 'Wrong chat id!'$'\n'
done

#

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID='1'
TGBOTS_MESSAGE=''
TGBOTS_DST=''
TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No message!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID='1'
TGBOTS_MESSAGE="$(printf '%.1s' {1..4097})"
TGBOTS_DST=''
TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong message size!'$'\n'

#

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID='1'
TGBOTS_MESSAGE='foobarbaz'
TGBOTS_DST=''
TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No dst!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID='1'
TGBOTS_MESSAGE='foobarbaz'
TGBOTS_DST="$(mktemp -d)"
TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${TGBOTS_DST}\" is not a file!"$'\n'
rm -r "${TGBOTS_DST}"

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID='1'
TGBOTS_MESSAGE='foobarbaz'
TGBOTS_DST="$(mktemp)"
rm "${TGBOTS_DST}"
ln -s "${TGBOTS_DST}" "${TGBOTS_DST}"
TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${TGBOTS_DST}\" is a symlink!"$'\n'
rm "${TGBOTS_DST}"

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID='1'
TGBOTS_MESSAGE='foobarbaz'
TGBOTS_DST="$(mktemp)"
TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${TGBOTS_DST}\" exists!"$'\n'
rm "${TGBOTS_DST}"

#

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID='1'
TGBOTS_MESSAGE='foobarbaz'
TGBOTS_DST="$(mktemp)"
rm "${TGBOTS_DST}"
PATH="${mocks}/curl/bin:${PATH}" \
 MOCKS_CURL_EXIT_CODE=1 \
 TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Request error!'$'\n'
rm -f "${TGBOTS_DST}"

HTTP_CODES=(2 20 22 202 2000 401 403 429 500 '' 'foo' '-1' '200 ' ' 200' $'\n200' $'\t200')
for HTTP_CODE in "${HTTP_CODES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 TGBOTS_BOT_ID='12345678'
 TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
 TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
 TGBOTS_CHAT_ID='1'
 TGBOTS_MESSAGE='foobarbaz'
 TGBOTS_DST="$(mktemp)"
 rm "${TGBOTS_DST}"
 PATH="${mocks}/curl/bin:${PATH}" \
  MOCKS_CURL_HTTP_CODE="${HTTP_CODE}" \
  TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" 'Code error!'$'\n'
 rm -f "${TGBOTS_DST}"
done

#

VALUES=('foo' '{}0' '[]' 'null' '42')
for MOCKS_CURL_DST in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 TGBOTS_BOT_ID='12345678'
 TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
 TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
 TGBOTS_CHAT_ID='1'
 TGBOTS_MESSAGE='foobarbaz'
 TGBOTS_DST="$(mktemp)"
 rm "${TGBOTS_DST}"
 PATH="${mocks}/curl/bin:${PATH}" \
  MOCKS_CURL_HTTP_CODE=200 \
  MOCKS_CURL_DST="${MOCKS_CURL_DST}" \
  TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" 'Parse dst error!'$'\n'
 rm "${TGBOTS_DST}"
done

VALUES=('{}' '{"ok":null}' '{"ok":{}}' '{"ok":[]}' '{"ok":0}' '{"ok":1}' '{"ok":-1}' '{"ok":""}' '{"ok":"true"}' '{"ok":false}')
for MOCKS_CURL_DST in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 TGBOTS_BOT_ID='12345678'
 TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
 TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
 TGBOTS_CHAT_ID='1'
 TGBOTS_MESSAGE='foobarbaz'
 TGBOTS_DST="$(mktemp)"
 rm "${TGBOTS_DST}"
 PATH="${mocks}/curl/bin:${PATH}" \
  MOCKS_CURL_HTTP_CODE=200 \
  MOCKS_CURL_DST="${MOCKS_CURL_DST}" \
  TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" 'Check dst error!'$'\n'
 rm "${TGBOTS_DST}"
done

#

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID='1'
TGBOTS_MESSAGE='foobarbaz'
TGBOTS_DST="$(mktemp)"
rm "${TGBOTS_DST}"
MOCKS_CURL_DST='{"ok":true}'
PATH="${mocks}/curl/bin:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_DST="${MOCKS_CURL_DST}" \
 TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"
. $asserts/files/equals.sh "${TGBOTS_DST}" "${MOCKS_CURL_DST}"
rm "${TGBOTS_DST}"

#

rm "${STDOUT}"
rm "${STDERR}"
