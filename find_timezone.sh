#!/bin/bash

cd /usr/share/zoneinfo
find * -not -type d | grep -v -e right -e posix | grep -i $1
