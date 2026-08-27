#!/usr/local/bin/bash

SCRIPT='src/main/bash/send_document.sh'

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
"${SCRIPT}" '' '' '' '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' '' '' '' '' '' > "${STDOUT}" 2> "${STDERR}"
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
TGBOTS_SRC=''
TGBOTS_DST=''
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
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
 TGBOTS_SRC=''
 TGBOTS_DST=''
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
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
TGBOTS_SRC=''
TGBOTS_DST=''
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
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
 TGBOTS_SRC=''
 TGBOTS_DST=''
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
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
TGBOTS_SRC=''
TGBOTS_DST=''
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
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
TGBOTS_SRC=''
TGBOTS_DST=''
TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
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
 TGBOTS_SRC=''
 TGBOTS_DST=''
 TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
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
TGBOTS_SRC=''
TGBOTS_DST=''
TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
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
 TGBOTS_SRC=''
 TGBOTS_DST=''
 TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
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
TGBOTS_MESSAGE="$(printf '%.1s' {1..1025})"
TGBOTS_SRC=''
TGBOTS_DST=''
TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
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
TGBOTS_SRC=''
TGBOTS_DST=''
TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No src!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID='1'
TGBOTS_MESSAGE='foobarbaz'
TGBOTS_SRC="$(mktemp)"
TGBOTS_DST=''
TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${TGBOTS_SRC}\" is empty!"$'\n'
rm "${TGBOTS_SRC}"

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID='1'
TGBOTS_MESSAGE='foobarbaz'
TGBOTS_SRC="$(mktemp)"
rm "${TGBOTS_SRC}"
TGBOTS_DST=''
TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${TGBOTS_SRC}\" does not exist!"$'\n'
. $asserts/files/not_exists.sh "${TGBOTS_SRC}"

#

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID='1'
TGBOTS_MESSAGE='foobarbaz'
TGBOTS_SRC="$(mktemp)"
printf '%s' '42' > "${TGBOTS_SRC}"
TGBOTS_DST=''
PATH="${mocks}/stat/bin:${PATH}" \
 MOCKS_STAT_EXIT_CODE=1 \
 TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Get file size error!'$'\n'
rm "${TGBOTS_SRC}"

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID='1'
TGBOTS_MESSAGE='foobarbaz'
TGBOTS_SRC="$(mktemp)"
printf '%s' '42' > "${TGBOTS_SRC}"
TGBOTS_DST=''
PATH="${mocks}/stat/bin:${PATH}" \
 MOCKS_STAT_SIZE='foo' \
 TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Get file size error!'$'\n'
rm "${TGBOTS_SRC}"

:> "${STDOUT}"
:> "${STDERR}"
TGBOTS_BOT_ID='12345678'
TGBOTS_BOT_SECRET="$(printf '%.1s' {1..35})"
TGBOTS_BOT_SECRET_SRC='TGBOTS_BOT_SECRET'
TGBOTS_CHAT_ID='1'
TGBOTS_MESSAGE='foobarbaz'
TGBOTS_SRC="$(mktemp)"
printf '%s' '42' > "${TGBOTS_SRC}"
TGBOTS_DST=''
PATH="${mocks}/stat/bin:${PATH}" \
 MOCKS_STAT_SIZE=32000001 \
 TGBOTS_BOT_SECRET="${TGBOTS_BOT_SECRET}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET_SRC}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${TGBOTS_SRC}\" has wrong size!"$'\n'
rm "${TGBOTS_SRC}"

#

echo 'Not implemented!'; exit 1 # todo

:> "${STDERR}"
PATH="${mocks}/stat/bin:${PATH}" \
 MOCKS_STAT_SIZE=32000001 \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_SRC}\" has wrong size!"

:> "${STDERR}"
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" '' 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'No dst!'

:> "${STDERR}"
TGBOTS_DST="$(mktemp)"
rm "${TGBOTS_DST}"
ln -s "${TGBOTS_DST}" "${TGBOTS_DST}"
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_DST}\" is a symlink!"
rm "${TGBOTS_DST}"

:> "${STDERR}"
TGBOTS_DST="$(mktemp -d)"
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_DST}\" is not a file!"
rm -rf "${TGBOTS_DST}"

:> "${STDERR}"
TGBOTS_DST="$(mktemp)"
"${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_DST}\" exists!"
rm "${TGBOTS_DST}"

:> "${STDERR}"
PATH="${mocks}/curl/bin:${PATH}" \
 MOCKS_CURL_EXIT_CODE=1 \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Request error!'

HTTP_CODES=(2 20 22 202 2000 401 403 429 500 '' 'foo')
for HTTP_CODE in "${HTTP_CODES[@]}"; do
 :> "${STDERR}"
 PATH="${mocks}/curl/bin:${PATH}" \
  MOCKS_CURL_HTTP_CODE="${HTTP_CODE}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/strings/eq.sh "Check http code(${#HTTP_CODE}): \"${HTTP_CODE}\"" "$(<"${STDERR}")" 'Code error!'
done

:> "${STDERR}"
PATH="${mocks}/curl/bin:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_DST_TYPE='issue:symlink' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_DST}\" is a symlink!"
rm "${TGBOTS_DST}"

:> "${STDERR}"
PATH="${mocks}/curl/bin:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_DST_TYPE='issue:dir' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_DST}\" is not a file!"
rm -rf "${TGBOTS_DST}"

:> "${STDERR}"
PATH="${mocks}/curl/bin:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_DST_TYPE='issue:empty_file' \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_DST}\" is empty!"
rm "${TGBOTS_DST}"

:> "${STDERR}"
PATH="${mocks}/curl/bin:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" "\"${TGBOTS_DST}\" does not exist!"

RESPONSES=('foo' '{}0' '[]' 'null' '"ok"')
for MOCKS_CURL_DST in "${RESPONSES[@]}"; do
 :> "${STDERR}"
 PATH="${mocks}/curl/bin:${PATH}" \
  MOCKS_CURL_HTTP_CODE=200 \
  MOCKS_CURL_DST="${MOCKS_CURL_DST}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Parse dst error!'
 rm "${TGBOTS_DST}"
done

RESPONSES=('{"ok":false}' '{"ok":"true"}' '{"ok":1}')
for MOCKS_CURL_DST in "${RESPONSES[@]}"; do
 :> "${STDERR}"
 PATH="${mocks}/curl/bin:${PATH}" \
  MOCKS_CURL_HTTP_CODE=200 \
  MOCKS_CURL_DST="${MOCKS_CURL_DST}" \
  "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Check dst error!'
 rm "${TGBOTS_DST}"
done

MOCKS_CURL_FORM_STRINGS_PATH="$(mktemp)"
rm "${MOCKS_CURL_FORM_STRINGS_PATH}"

MOCKS_CURL_FORMS_PATH="$(mktemp)"
rm "${MOCKS_CURL_FORMS_PATH}"

EXPECTED_FORM_STRINGS="chat_id=${TGBOTS_CHAT_ID}
caption=${TGBOTS_MESSAGE}
parse_mode=Markdown"
:> "${STDERR}"
PATH="${mocks}/curl/bin:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_DST='{"ok":true}' \
 MOCKS_CURL_FORM_STRINGS_PATH="${MOCKS_CURL_FORM_STRINGS_PATH}" \
 MOCKS_CURL_FORMS_PATH="${MOCKS_CURL_FORMS_PATH}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/strings/empty.sh "${SCRIPT}" "$(<"${STDERR}")"
. $asserts/files/not_empty.sh "${TGBOTS_DST}"
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${TGBOTS_DST}")" '{"ok":true}'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${MOCKS_CURL_FORM_STRINGS_PATH}")" "${EXPECTED_FORM_STRINGS}"
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${MOCKS_CURL_FORMS_PATH}")" "document=@\"${TGBOTS_SRC}\""
rm "${TGBOTS_DST}"
rm "${MOCKS_CURL_FORM_STRINGS_PATH}"
rm "${MOCKS_CURL_FORMS_PATH}"

TGBOTS_MESSAGE=''

:> "${STDERR}"
PATH="${mocks}/curl/bin:${PATH}" \
 MOCKS_CURL_HTTP_CODE=200 \
 MOCKS_CURL_DST='{"ok":true}' \
 MOCKS_CURL_FORM_STRINGS_PATH="${MOCKS_CURL_FORM_STRINGS_PATH}" \
 MOCKS_CURL_FORMS_PATH="${MOCKS_CURL_FORMS_PATH}" \
 "${SCRIPT}" "${TGBOTS_BOT_ID}" "${TGBOTS_BOT_SECRET}" "${TGBOTS_CHAT_ID}" "${TGBOTS_MESSAGE}" "${TGBOTS_SRC}" "${TGBOTS_DST}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/strings/empty.sh "${SCRIPT}" "$(<"${STDERR}")"
. $asserts/files/not_empty.sh "${TGBOTS_DST}"
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${TGBOTS_DST}")" '{"ok":true}'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${MOCKS_CURL_FORM_STRINGS_PATH}")" "chat_id=${TGBOTS_CHAT_ID}"
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${MOCKS_CURL_FORMS_PATH}")" "document=@\"${TGBOTS_SRC}\""
rm "${TGBOTS_DST}"
rm "${MOCKS_CURL_FORM_STRINGS_PATH}"
rm "${MOCKS_CURL_FORMS_PATH}"

rm "${TGBOTS_SRC}"
rm "${STDERR}"
