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

echo "$(date) starting certbot scripts"

if [[ "$(whoami)" == "root" ]]; then
	HOME_DIR=$( getent passwd "certbot" | cut -d: -f6 )
	echo "runing as default user certbot, home $HOME_DIR"

	chown -R certbot:certbot /etc/letsencrypt /var/lib/letsencrypt /var/log/letsencrypt /certs

	echo "dns_cloudflare_api_token=${CLOUDFLARE_API_TOKEN}" > "$HOME_DIR/cloudflare.ini"
	chmod 600 "$HOME_DIR/cloudflare.ini"
	chown certbot:certbot "$HOME_DIR/cloudflare.ini"

	sudo -u certbot certbot certonly --dns-cloudflare --dns-cloudflare-credentials "$HOME_DIR/cloudflare.ini" -d ${DOMAIN} --non-interactive --agree-tos -m ${EMAIL}
else
	cd ~
	echo "running as custom user $USER, home $(pwd)"

	echo "dns_cloudflare_api_token=${CLOUDFLARE_API_TOKEN}" > ~/cloudflare.ini
	chmod 600 ~/cloudflare.ini

	certbot certonly --dns-cloudflare --dns-cloudflare-credentials ~/cloudflare.ini -d ${DOMAIN} --non-interactive --agree-tos -m ${EMAIL}
fi

echo "$(date) running renewal script"

if [[ "$(whoami)" == "root" ]]; then
	echo "running as default user certbot"
	sudo -u certbot /renew.sh
else
	echo "running as custom user $USER"
	/renew.sh
fi

echo "$(date) running crond in forefront."
echo "\tto change, overwrite /etc/letsencrypt/crontabs/certbot."

if [[ "$(whoami)" == "root" ]]; then
	echo "running as default user certbot"
	sudo -u certbot crond -l 2 -f
else
	echo "running as custom user $USER"
	crond -l 2 -f
fi
