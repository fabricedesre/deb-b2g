#!/bin/bash
PROFILE=${HOME}/.mozilla/b2g/xsession.profile

# TODO: update the profile when a new version of gaia is available.
if [ ! -d "${PROFILE}" ]; then
	echo "Creating new b2g profile"
    mkdir -p ${PROFILE}
    tar --directory ${PROFILE} -xjf /opt/b2g/profile.tar.bz2
fi

/opt/b2g/b2g/b2g -no-remote -profile ${PROFILE} $1