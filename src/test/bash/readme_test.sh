#!/usr/local/bin/bash

ISSUER='build/yml/metadata.yml'
. $asserts/file.sh "${ISSUER}"

VERSION="$(yq -erM .version "${ISSUER}")" || exit 1
REP_OWNER="$(yq -erM .repository.owner "${ISSUER}")" || exit 1
REP_NAME="$(yq -erM .repository.name "${ISSUER}")" || exit 1

ISSUER='README.md'
. $asserts/file.sh "${ISSUER}"

EXPECTED_TEXT="\`${VERSION}\`
| [GitHub](https://github.com/${REP_OWNER}/${REP_NAME}/releases/tag/${VERSION})"

. $asserts/contains.sh "$(cat "${ISSUER}")" "${EXPECTED_TEXT}"
