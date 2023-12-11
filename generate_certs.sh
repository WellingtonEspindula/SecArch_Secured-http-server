#!/usr/bin/env bash

mkdir -p certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./certs/server.key -out ./certs/server.crt -subj "/CN=FR\/emailAddress=admin@example.com/C=FR/ST=Isere/L=/O=Ensimag/OU=Some Unit" 

mkdir -p .ssh
ssh-keygen -t rsa -b 4096 -C "admin@example.com" -f .ssh/id_rsa
chmod 600 ./.ssh/id_rsa
chmod 644 ./.ssh/id_rsa.pub
chmod 700 ./.ssh
