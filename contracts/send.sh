#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
	echo "Usage: ${0} <to> <amount>"
	echo 'Amount in Wei  -  1 Ether = 1000000000000000000 Wei'
	exit 1
fi

address_file='../parity-deploy/deployment/1/address.txt'
password_file='../parity-deploy/deployment/1/password'

if [ ! -f $address_file ]; then
	echo 'Address file not found.'
	echo 'Be sure to execute the deploy scripts in "parity-deploy" directory first.'
	exit 1
fi

if [ ! -f $password_file ]; then
	echo 'Password file not found.'
	echo 'Be sure to execute the deploy script in "parity-deploy" directory first.'
	exit 1
fi

from=`cat ${address_file}`
password=`cat ${password_file}`
to=$1
amount="$(printf '0x%04x' $2)" # decimal to hex

curl --data "{\"method\":\"personal_sendTransaction\",\"params\":[{\"from\":\"${from}\",\"to\":\"${to}\",\"value\":\"${amount}\"},\"${password}\"],\"id\":1,\"jsonrpc\":\"2.0\"}" -H "Content-Type: application/json" -X POST localhost:8545
