#!/bin/bash
<<task
1 is folder name
2 is start name
3 is end range
task

for ((i=$2; i<=$3; i++))
do
	mkdir "$1$i"
done	
