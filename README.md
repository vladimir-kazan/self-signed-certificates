# Create self-signed certicates

## 0. Prepare config files

- ./ca.cnf — issuer information

## 1. Create Certificate Authority (CA) - The Issuer of certifcates

```txt
CA root key not found, creating...
Generating RSA private key, 4096 bit long modulus
.....................................++
.....................................................++
e is 65537 (0x10001)

Files created:
certs/root/ca.key
certs/root/ca.crt
```

After you can add root certificate `ca.crt` to your certifcate storage and mark as trusted. It allows to trust all issued domain certicates.

## 2. Create domain certificate and private key

```txt

$ DOMAIN=demo.example.com ./create-domain.sh

demo.example.com
Generating RSA private key, 2048 bit long modulus
...................................................+++
.............................+++
e is 65537 (0x10001)
Signature ok
subject=/CN=DEV certificate for demo.example.com
Getting CA Private Key

Files created:
certs/domain/demo.example.com.crt
certs/domain/demo.example.com.key
```

