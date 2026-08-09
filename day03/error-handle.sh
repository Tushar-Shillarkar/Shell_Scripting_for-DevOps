#!/bin/bash

create_directory() {
	mkdir demo
}

if ! create_directory; then
	echo " code is being exited since the directory already existed"
	exit 1
fi	

echo "this should not work bcoz the  code is interpted"
