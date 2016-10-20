export VAULT_TOKEN="`echo $1`"
export VAULT_ADDR="`echo $2`"

vault write -format=json vault_intermediate/issue/web_server common_name="`echo $3`"  ip_sans="`echo $4`" ttl=720h > ./tmp.json
cat ./tmp.json | jq -r .data.issuing_ca | cat > `echo $5`
cat ./tmp.json | jq -r .data.certificate | cat > `echo $6`
cat ./tmp.json | jq -r .data.private_key | cat > `echo $7`
