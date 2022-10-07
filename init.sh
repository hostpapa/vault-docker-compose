#!/usr/bin/env sh

set -ex

init () {
   vault operator init > /vault/file/keys
}

unseal () {
   vault operator unseal $(grep 'Key 1:' /vault/file/keys | awk '{print $NF}')
   vault operator unseal $(grep 'Key 2:' /vault/file/keys | awk '{print $NF}')
   vault operator unseal $(grep 'Key 3:' /vault/file/keys | awk '{print $NF}')
}

login () {
   export ROOT_TOKEN=$(grep 'Initial Root Token:' /vault/file/keys | awk '{print $NF}')
   vault login $ROOT_TOKEN
}

create_token () {
   vault token create -id $MY_VAULT_TOKEN
}

if [ -s /vault/file/keys ]; then
   unseal
else
   init
   unseal
   login
   create_token
fi

vault status > /vault/file/status