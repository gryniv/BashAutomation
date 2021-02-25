#!/bin/bash

gpStatus=$(globalprotect show --status)

if [[ "$gpStatus" == *"Connected"* ]]; then
  globalprotect disconnect
else
  #Not Secure Script but fully automatic
  export PORTAL="mfa-portal.amwayconnect.com"
  export NICKNAME="RUVNAME"
  export PASSWORD="VERY_SECURE_PASSWORD"
  export ONE_TIME=$(~/./ga-cmd gp)

  # shellcheck disable=SC2016
    expect -c '
        spawn globalprotect connect --portal $env(PORTAL) --username $env(NICKNAME)

        expect "username($env(NICKNAME)):"
        send -- "$env(NICKNAME)\r"

        expect "Password:"
        send -- "$env(PASSWORD)\r"

        expect "Please select your second authentication method*"
        send -- "3\r"

        expect "Enter the code for Google Authenticator. Enter '0' to abort. :"
        send -- "$env(ONE_TIME)\r"

        expect ""
        expect eof
'
fi