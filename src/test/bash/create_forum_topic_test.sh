#!/usr/local/bin/bash

ISSUER="$tgbots/create_forum_topic.sh"

ACTUAL_VALUE="$(${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 0)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 0 0)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 0 0 0 0)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(TG_BOT_ID='' TG_BOT_TOKEN='' ${ISSUER} '' '' '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "TG_BOT_ID" is empty!'

ACTUAL_VALUE="$(TG_BOT_ID=0 TG_BOT_TOKEN='' ${ISSUER} '' '' '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "TG_BOT_TOKEN" is empty!'

ACTUAL_VALUE="$(TG_BOT_ID=0 TG_BOT_TOKEN=0 ${ISSUER} '' '' '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "TG_CHAT_ID" is empty!'

ACTUAL_VALUE="$(TG_BOT_ID=0 TG_BOT_TOKEN=0 ${ISSUER} 0 '' '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "TG_TOPIC_NAME" is empty!'

ACTUAL_VALUE="$(TG_BOT_ID=0 TG_BOT_TOKEN=0 ${ISSUER} 0 0 '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "TG_OUTPUT" is empty!'

ACTUAL_VALUE="$(TG_BOT_ID=0 TG_BOT_TOKEN=0 ${ISSUER} x 0 0)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong chat id!'

ACTUAL_VALUE="$(TG_BOT_ID=0 TG_BOT_TOKEN=0 ${ISSUER} 0 abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789a 0)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong topic name!'
