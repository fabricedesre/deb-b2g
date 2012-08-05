#!/bin/bash
PROFILE=${HOME}/.mozilla/b2g/xsession.profile

if [ ! -d "${PROFILE}" ]; then
	echo "Creating new b2g profile"
    mkdir -p ${PROFILE}
    tar --directory ${PROFILE} -xjf /opt/b2g/profile.tar.bz2
fi

# Update the profile if a new gaia is available.
if [ "${PROFILE}" -ot "/opt/b2g/profile.tar.bz2" ]; then
	echo "Updating b2g profile"
	tar --directory ${PROFILE} -xjf /opt/b2g/profile.tar.bz2
fi

/opt/b2g/b2g/b2g -no-remote -profile ${PROFILE} $1
