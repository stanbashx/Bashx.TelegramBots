#!/usr/local/bin/bash

tests='src/test/bash'
asserts="${tests}/asserts"
tgbots="src/main/bash"

. $tests/readme_test.sh
. $tests/license_test.sh
. $tests/create_forum_topic_test.sh
. $tests/download_file_test.sh
. $tests/edit_topic_emoji_test.sh
. $tests/get_file_test.sh
. $tests/get_me_test.sh
. $tests/get_topic_stickers_test.sh
. $tests/get_updates_test.sh
. $tests/send_document_test.sh
. $tests/send_message_test.sh

echo 'All tests were successful.'
