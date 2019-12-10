#!/usr/bin/env bash

ROOT_DAYS=731

function create_ca() {
    local root=certs/root
    local days=${ROOT_DAYS:-731}

    mkdir -p $root

    if [ ! -e "$root/ca.key" ]; then 
        echo "CA root key not found, creating..."
        openssl genrsa \
            -out $root/ca.key 4096

        openssl req -x509 -new -nodes -sha256 -days $days \
            -key $root/ca.key \
            -config ./ca.cnf \
            -out $root/ca.crt

        echo ""
        echo "Files created:"
        echo "$root/ca.key"
        echo "$root/ca.crt"
    else
        echo "CA root key already exists: $root/ca.key"
        echo "Delete it before create new one."
    fi
}

create_ca


