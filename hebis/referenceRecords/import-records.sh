#!/usr/bin/env bash

pw=${1:-xxx}
tenant=${2:-ubmz}
iln=${3:-25}
okapi=${4:-http://localhost:9130}
user=${5:-ubmz_admin}
token=$( curl -s -S -D - -H "X-Okapi-Tenant: $tenant" -H "Content-type: application/json" -H "Accept: application/json" -d '{"tenant":"'$tenant'","username":"'$user'","password":"'$pw'"}' $okapi/authn/login | grep -i "^x-okapi-token: " )

if [ $pw == "xxx" ] ; then
    echo "No password!"
    exit 1
fi

loan_type_storage_address=$okapi/loan-types
holdings_sources_storage_address=$okapi/holdings-sources
identifier_type_storage_address=$okapi/identifier-types
instance-statuses_storage_address=$okapi/instance-statuses
instance-relationship-types_storage_address=$okapi/instance-relationship-types
item_note_type_storage_address=$okapi/item-note-types
material_type_storage_address=$okapi/material-types

for f in ./codes2uuid-hebis-iln$iln/loan-types/*.json; do
    echo "PROCESSING -->" $f
    curl -w '\n' -s -X POST -D - \
         -H "Content-type: application/json" \
         -H "X-Okapi-Tenant: ${tenant}" \
	 -H "${token}" \
         -d @$f \
         "${loan_type_storage_address}" | grep 'message\|exists'
done

for f in ./codes2uuid-hebis/holdings-sources/*.json; do
    echo "PROCESSING -->" $f
    curl -w '\n' -s -X POST -D - \
         -H "Content-type: application/json" \
         -H "X-Okapi-Tenant: ${tenant}" \
	 -H "${token}" \
         -d @$f \
         "${holdings_sources_storage_address}" | grep 'message\|exists'
done

for f in ./codes2uuid-hebis/identifier-types/*.json; do
    echo "PROCESSING -->" $f
    curl -w '\n' -s -X POST -D - \
         -H "Content-type: application/json" \
         -H "X-Okapi-Tenant: ${tenant}" \
	 -H "${token}" \
         -d @$f \
         "${identifier_type_storage_address}" | grep 'message\|exists'
done

for f in ./Additional/instance-relationship-types/*.json; do
	echo "PROCESSING -->" $f
    	curl -w '\n' -s -X POST -D - \
         -H "Content-type: application/json" \
         -H "X-Okapi-Tenant: ${tenant}" \
	 -H "${token}" \
         -d @$f \
         "${instance-relationship-types_storage_address}" | grep 'message\|exists'
done

for f in ./K10plus/instance-statuses/*.json; do
	echo "PROCESSING -->" $f
    	curl -w '\n' -s -X POST -D - \
         -H "Content-type: application/json" \
         -H "X-Okapi-Tenant: ${tenant}" \
	 -H "${token}" \
         -d @$f \
         "${instance-statuses_storage_address}" | grep 'message\|exists'
done

for f in ./codes2uuid-hebis/item-note-types/*.json; do
        echo "PROCESSING -->" $f
    	curl -w '\n' -s -X POST -D - \
         -H "Content-type: application/json" \
         -H "X-Okapi-Tenant: ${tenant}" \
	 -H "${token}" \
         -d @$f \
         "${item_note_type_storage_address}" | grep 'message\|exists'
done

for f in ./codes2uuid-hebis/material-types/*.json; do
	echo "PROCESSING -->" $f
    	curl -w '\n' -s -X POST -D - \
         -H "Content-type: application/json" \
         -H "X-Okapi-Tenant: ${tenant}" \
	 -H "${token}" \
         -d @$f \
         "${material_type_storage_address}" | grep 'message\|exists'
done
