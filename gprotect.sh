#!/bin/bash

GP_ITEM="gscmu3ibzgf4ucovrjwjny2cqq"
gpStatus=$(globalprotect show --status)

if [[ "$gpStatus" == *"Connected"* ]]; then
    globalprotect disconnect
else
       eval $(op signin my)

    # expect -c '
    # spawn "$(eval $(op signin my))"
    #     expect "Enter the password*"
    #     send -- "w1nl0ads42\r"
    
    #     expect ""
    #     expect eof
# '
    export   PORTAL=$(op get item $GP_ITEM | jq -r '.overview.URLs[] | select(.l=="portal").u')
    export NICKNAME=$(op get item $GP_ITEM | jq -r '.details.fields[] | select(.designation=="username").value')
    export PASSWORD=$(op get item $GP_ITEM | jq -r '.details.fields[] | select(.designation=="password").value')
    export ONE_TIME=$(op get totp $GP_ITEM)

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