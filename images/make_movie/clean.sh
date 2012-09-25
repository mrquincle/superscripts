#!/bin/bash

if [ $# -lt 1 ]
then
  echo "Animation name is e.g. festo"
  echo "Please, enter: "
  read input
else
  input=$1
fi

echo "Remove all temporary and output files"

rm ../extract/${input}/*.jpg

rm ../animate/${input}/*.eps


