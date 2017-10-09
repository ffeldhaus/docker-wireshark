#!/bin/bash

set -e

# first arg is `-f` or `--some-option`
if [ "${1:0:1}" = '-' ]; then
	set -- xpra start "$@"
fi

exec "$@"
