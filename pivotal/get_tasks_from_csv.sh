#!/bin/sh

usage="Usage: $0 <csv file>J"

ifile=${1:? "$usage"}

mkdir -p ~/tmp

csvtool namedcol 'Title,Labels,Iteration,Estimate,Current State' $ifile > ~/tmp/pivotal.csv

csvsql --query 'SELECT * FROM pivotal WHERE Iteration > 109 and Iteration < 127 and Estimate >= 2 and "Current State" = "accepted"' ~/tmp/pivotal.csv > ~/tmp/output0.csv

csvtool namedcol 'Title,Labels,Iteration,Estimate' ~/tmp/output0.csv > ~/tmp/output.csv

cat ~/tmp/output.csv

echo
echo "Find this output in ~/tmp/output.csv"
