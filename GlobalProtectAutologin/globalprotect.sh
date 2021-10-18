#!/bin/bash

SUCCESS_IMG_PATH="$HOME/success.png"
SUCCESS_IMG_DATA='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'

function status() {
  gpStatus=$(globalprotect show --status)
}

function disconnect() {
  status
  if [[ "$gpStatus" == *"Connected"* ]]; then
    globalprotect disconnect
  fi
}
function createImage() {
  echo -n $SUCCESS_IMG_DATA | base64 -d >$SUCCESS_IMG_PATH
}

function connect() {
  status
  if [[ "$gpStatus" != *"Connected"* ]]; then
    export ONE_TIME=$(~/./ga-cmd gp)

    # shellcheck disable=SC2016
    expect -c '
          spawn globalprotect connect --portal $env(OKTA_PORTAL) --username $env(OKTA_NICKNAME)
          expect "username($env(OKTA_NICKNAME)):"
          send -- "$env(OKTA_NICKNAME)\r"
          expect "Password:"
          send -- "$env(OKTA_PASSWORD)\r"
          expect "Please select your second authentication method*"
          send -- "3\r"
          expect "Enter the code for Google Authenticator. Enter '0' to abort. :"
          send -- "$env(ONE_TIME)\r"
          expect ""
          expect eof'
    status
    if [[ "$gpStatus" == *"Connected"* ]]; then
      if [[ -a "$SUCCESS_IMG_PATH" ]]; then
            createImage
      fi
           notify-send 'Paloalto GlobalProtect' 'GlobalProtect Connected succesfully' --icon="$SUCCESS_IMG_PATH"
    fi
  else
    echo "$gpStatus"
  fi
}

MODE=$1

if [ "$MODE" = "" ]; then
  MODE="connect"
fi
case $MODE in
"connect" | "-c")
  connect
  ;;
"disconnect" | "-d")
  disconnect
  ;;
"status" | "-s")
  status
  echo "$gpStatus"
  ;;
*)
  status
  echo "$gpStatus"
  ;;
esac
