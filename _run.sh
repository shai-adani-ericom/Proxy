#!/bin/sh

docker run  --env UPSTREAM_HOST="qa-proxy-med1.shield-service.net" --env UPSTREAM_PORT='3128' --env TENANT_ID='507d1ae5-ba7c-4295-89e4-f21bf4f4fe1c' --env AUTH_GROUPS='' --env PROFILES='' --env X_AUTH_USER='' --rm --name "proxy-no-auth" -p 3111:3128 "securebrowsing/proxy-no-auth:latest"