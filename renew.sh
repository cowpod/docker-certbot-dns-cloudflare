#!/bin/ash -l

set -e

certbot renew -q

# handle certs renaming

cd /etc/letsencrypt/live

for f in *; do
	if [ ! -d "$f" ]; then
		continue
	fi
	cd "$f"

	dcrt="/certs/$f.crt"
	dkey="/certs/$f.key"

	c_fullchain1="_nofile1"
	c_fullchain2="_nofile2"
	c_privkey1="_nofile3"
	c_privkey2="_nofile4"

	if [[ -f "fullchain.pem" ]]; then
		c_fullchain1="$(sha1sum fullchain.pem)"
		c_fullchain1="<${c_fullchain1%%  *}>"
		echo "fullchain.pem shasum: $c_fullchain1"
	else
		echo "fullchain.pem is not present. skipping."
		continue
	fi
	if [[ -f "privkey.pem" ]]; then
		c_privkey1="$(sha1sum privkey.pem)"
		c_privkey1="<${c_privkey1%%  *}>"
		echo "privkey.pem shasum: $c_privkey1"
	else
		echo "privkey.pem is not present. skipping."
		continue
	fi

	if [[ -f "$dcrt" ]]; then
		c_fullchain2="$(sha1sum $dcrt)"
		c_fullchain2="<${c_fullchain2%%  *}>"
		echo "$(basename $dcrt) shasum: $c_fullchain2"
	fi
	if [[ -f "$dkey" ]]; then
		c_privkey2="$(sha1sum $dkey)"
		c_privkey2="<${c_privkey2%%  *}>"
		echo "$(basename $dkey) shasum: $c_privkey2"
	fi

	if [[ "$c_fullchain1" != "$c_fullchain2" ]]; then
		echo "copying $(pwd)/fullchain.pem to $dcrt"
		if [[ -f "$dcrt" ]]; then
			rm "$dcrt"
		fi
		cp fullchain.pem "$dcrt"
	fi
	if [[ "$c_privkey1" != "$c_privkey2" ]]; then
		echo "copying $(pwd)/privkey.pem to $dkey"
		if [[ -f "$dkey" ]]; then
			rm "$dkey"
		fi
		cp privkey.pem "$dkey"
	fi

	cd /etc/letsencrypt/live
done

