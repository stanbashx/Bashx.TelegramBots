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

"${SCRIPT}" 'a' '' '' '' 2>"${STDERR}"; CODE=$?
. $asserts/strings/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" '"TGBOTS_BOT_TOKEN" is empty!'

"${SCRIPT}" 'a' 'b' '' '' 2>"${STDERR}"; CODE=$?
. $asserts/strings/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" '"TGBOTS_CHAT_ID" is empty!'

"${SCRIPT}" 'a' 'b' 'c' '' 2>"${STDERR}"; CODE=$?
. $asserts/strings/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" '"TGBOTS_MESSAGE" is empty!'

"${SCRIPT}" 'a' 'b' 'c' 'd' 2>"${STDERR}"; CODE=$?
. $asserts/strings/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong chat id!'

rm "${STDERR}"
