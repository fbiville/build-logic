#!/usr/bin/env bash

set -e

KEY=$1

if [[ -z "$BOT_TOKEN" ]]; then
  echo "Set the $BOT_TOKEN env variable."
  exit 1
fi

RELEASE=$(curl -s \
  -H "Authorization: token $BOT_TOKEN" \
  -H "Accept: application/vnd.github+json" \
    https://api.github.com/repos/liquibase/hashicorp-vault-plugin/releases |
    jq -r ".[] | select(.draft == true)")

if [[ "${#RELEASE}" -eq 0 ]]; then
    echo "Draft release not found."
    exit 1;
fi

case $KEY in
    TAG)
        HTML_URL=$(echo $RELEASE | jq -r ".html_url")
        echo "$HTML_URL" | rev | cut -d "/" -f1 | rev
        ;;
    UPLOAD_URL)
        UPLOAD_URL=$(echo $RELEASE | jq -r ".upload_url")
        echo "${UPLOAD_URL//{?name,label\}}"
        ;;
esac