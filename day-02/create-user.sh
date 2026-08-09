#!/bin/bash
NAME="Itachi"

echo "I'm  $NAME and date is$(date)"

read -p " Enter username: " username

echo "$username "


sudo useradd -m $username

echo "new user added"


echo " the enemies of $NAME :  $1 $2"
