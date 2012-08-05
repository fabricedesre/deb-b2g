#!/bin/bash
/opt/b2g/launch.sh --screen=`xdpyinfo | grep dimensions | cut -f 7 -d ' '` 