#!/usr/local/bin/bash

mkdir -p 'build'
mkdir -p 'build/yml'
ISSUER='build/yml/metadata.yml'
echo "repository:
 owner: 'StanleyProjects'
 name: 'TelegramBots'
version: '0.0.3'" > "${ISSUER}"

VERSION="$(yq -erM .version "${ISSUER}")" || exit 1
REP_NAME="$(yq -erM .repository.name "${ISSUER}")" || exit 1

if [[ ! -s 'LICENSE' ]]; then
 echo 'No license!'; exit 1; fi

if [[ ! -s 'README.md' ]]; then
 echo 'No readme!'; exit 1; fi

mkdir -p 'build/zip'
ISSUER="build/zip/${REP_NAME}-${VERSION}.zip"
zip -r "${ISSUER}" 'src/main/bash' 'LICENSE' 'README.md'
