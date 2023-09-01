#!/bin/sh
# vim:sw=4:ts=4:et
set -e

if [ ! -z "$USERNAME" ] && [ ! -z "$PASSWORD" ]; then
	/bin/bash /root/create_user.sh "$USERNAME" "$PASSWORD"
fi

exec "$@"