#!/usr/bin/env bash

# # source .env.example
# # ./create.sh certs/.env
# source $1


OUTPUT=certs/domain
DOMAIN=${DOMAIN:-dev.example.com}
echo $DOMAIN

function create_domain() {
    local days=${DAYS:-731}
    local root=certs/root

    if [ ! -e "$root/ca.crt" ]; then
        echo "CA root ceftificate not found."
        echo "Path: $root/ca.crt"
        exit 1;
    fi
    if [ ! -e "$root/ca.key" ]; then
        echo "CA root private key not found."
        echo "Path: $root/ca.key"
        exit 1;
    fi

    mkdir -p $OUTPUT
    local domain_key=$OUTPUT/$DOMAIN.key
    local domain_request=$OUTPUT/$DOMAIN.csr
    local domain_cert=$OUTPUT/$DOMAIN.crt

    # Domain key
    if [ ! -e "$domain_key" ]; then
        openssl genrsa -out $domain_key 2048
    fi
    # Request
    openssl req -new -sha256 \
        -key $domain_key \
        -reqexts SAN \
        -config <(cat ./openssl.cnf \
            <(printf "\n[SAN]\nsubjectAltName=DNS:*.$DOMAIN,DNS:$DOMAIN,DNS:www.$DOMAIN")) \
        -subj "/CN=DEV certificate for $DOMAIN" \
        -out $domain_request

    # check request
    # openssl req -noout -text -in $domain_request
   
    openssl x509 -req -days $days -sha256 \
        -in $domain_request \
        -CA $root/ca.crt \
        -CAkey $root/ca.key \
        -CAcreateserial \
        -out $domain_cert \
        -extensions SAN \
        -extfile <(cat ./openssl.cnf \
            <(printf "\n[SAN]\nsubjectAltName=DNS:*.$DOMAIN,DNS:$DOMAIN,DNS:www.$DOMAIN"))

    rm $domain_request
    echo ""
    echo "Files created:"
    echo $domain_cert
    echo $domain_key
}

create_domain
