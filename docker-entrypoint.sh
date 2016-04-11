#!/bin/bash

set -e   # (errexit) Exit if any subcommand or pipeline returns a non-zero status
set -u   # (nounset) Exit on any attempt to use an uninitialised variable

# Allow Dockerfile to override default scripts directory
: ${SCRIPTS_DIR:=/scripts}
if [ "$SCRIPTS_DIR" != "/" ]; then
	SCRIPTS_DIR=${SCRIPTS_DIR%/}        # Trim trailing slash
fi

entrypoint_scripts_dir=${SCRIPTS_DIR}/entrypoint.d

#
# Run any executable files found in the entrypoint scripts directory
#
# The directory to search is defined by the entrypoint_scripts_dir environment variable.
#
function run_entrypoint_scripts() {
	echo "Checking for entrypoint scripts directory (${entrypoint_scripts_dir})..."
	if [ -d ${entrypoint_scripts_dir} ]; then
		echo "Running entrypoint scripts..."
		local script=
		for script in ${entrypoint_scripts_dir}/*
		do
			if [ -f $script ]; then
				if [ -x $script ]; then
					echo "Running ${script}..."
					$script
				else
					echo "Skipping ${script} as it is not executable."
				fi
			fi
		done
	fi
}

run_entrypoint_scripts

# Pass through arguments to exec
if [ $# -ge 1 ]; then
	exec "$@"
fi
