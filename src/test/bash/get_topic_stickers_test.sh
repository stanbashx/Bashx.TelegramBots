#!/usr/local/bin/bash

ISSUER="$tgbots/get_topic_stickers.sh"

ACTUAL_VALUE="$(${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 0 0)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(TG_BOT_ID='' TG_BOT_TOKEN='' ${ISSUER} '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "TG_BOT_ID" is empty!'

ACTUAL_VALUE="$(TG_BOT_ID=0 TG_BOT_TOKEN='' ${ISSUER} '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "TG_BOT_TOKEN" is empty!'

ACTUAL_VALUE="$(TG_BOT_ID=0 TG_BOT_TOKEN=0 ${ISSUER} '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "TG_OUTPUT" is empty!'
