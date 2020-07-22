#!/bin/sh
echo "environment variables to use:"
echo "host" "$UPSTREAM_HOST"
echo "port" "$UPSTREAM_PORT"
echo "tenant" "$TENANT_ID"
echo "auth-groups" "$AUTH_GROUPS"
echo "profiles" "$PROFILES"
#create squid conf

consul-template -template "/config/squid.conf.ctmpl:/etc/squid/squid.conf" -once

#init ssl DB
/usr/lib/squid/security_file_certgen -c -s /var/cache/squid/ssl_db -M 4MB

CHOWN=$(/usr/bin/which chown)
SQUID=$(/usr/bin/which squid)

# Ensure permissions are set correctly on the Squid cache + log dir.
"$CHOWN" -R squid:squid /var/cache/squid
"$CHOWN" -R squid:squid /var/log/squid
"$CHOWN" -R squid:squid /var/run

# Prepare the cache using Squid.
echo "Initializing cache..."
"$SQUID" -z

# Give the Squid cache some time to rebuild.
sleep 5

# Launch squid
echo "Starting Squid..."
exec "$SQUID" -NYCd 1