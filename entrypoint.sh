#!/bin/ash -l

set -e

if [[ ! -d /etc/letsencrypt/live ]]; then
	echo "Please ensure that /etc/letsencrypt is persistent! Or is this the first run?"
fi
if [[ "${CLOUDFLARE_API_TOKEN}" == "" ]]; then
	echo "CLOUDFLARE_API_TOKEN not set. This is required."
	exit 2
fi
if [[ "${DOMAIN}" == "" ]]; then
	echo "DOMAIN variable not set."
	exit 3
fi
if [[ "${EMAIL}" == "" ]]; then
	echo "EMAIL variable not set."
	exit 4
fi

echo "$(date) running initial certbot command..."

if [[ "$(whoami)" == "root" ]]; then
	HOME_DIR=$( getent passwd "certbot" | cut -d: -f6 )
	echo "runing as default certbot user... $HOME_DIR"

	# user may have overriden with bad permisisons
	chown -R certbot:certbot /etc/letsencrypt /var/lib/letsencrypt /var/log/letsencrypt

	echo "dns_cloudflare_api_token=${CLOUDFLARE_API_TOKEN}" > "$HOME_DIR/cloudflare.ini"

	chmod 600 "$HOME_DIR/cloudflare.ini"
	chown certbot:certbot "$HOME_DIR/cloudflare.ini"

	sudo -u certbot certbot certonly --dns-cloudflare --dns-cloudflare-credentials "$HOME_DIR/cloudflare.ini" -d ${DOMAIN} --non-interactive --agree-tos -m ${EMAIL}
fi

echo "$(date) running crond in forefront... to change, overwrite /etc/letsencrypt/crontabs/certbot"

if [[ "$(whoami)" == "root" ]]; then
	echo "running as default certbot user..."
	sudo -u certbot crond -l 2 -f
fi

echo "crond died...? sleeping"
sleep infinity
