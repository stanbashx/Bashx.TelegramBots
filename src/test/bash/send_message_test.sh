#!/usr/local/bin/bash

ISSUER="$tgbots/send_message.sh"

ACTUAL_VALUE="$(${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 0 0)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "TG_BOT_ID" is empty!'

ACTUAL_VALUE="$(TG_BOT_ID=0 ${ISSUER} '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "TG_BOT_TOKEN" is empty!'

ACTUAL_VALUE="$(TG_BOT_ID=0 TG_BOT_TOKEN=0 ${ISSUER} '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "TG_CHAT_ID" is empty!'

ACTUAL_VALUE="$(TG_BOT_ID=0 TG_BOT_TOKEN=0 TG_CHAT_ID=0 ${ISSUER} '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "TG_MESSAGE" is empty!'
