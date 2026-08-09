#!/bin/bash

<< disclaimer
this is for infortainment purpose
disclaimer

function is_loyal()
{
read -p "$1 ne mudke kise dekha: " bandi
read -p "$1 ka pyar % " pyaar
if [[ $bandi == "lakshu" ]]
then
	echo " $1 is loyal"
elif [[ $pyaar -ge 100 ]];
then	
	echo "$1 also loves vahini"
else
	echo "$1 is bhadva"
fi
}
is_loyal "manoj"
