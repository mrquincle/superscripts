#!/bin/bash

mask=$1

rename 's/\d+/sprintf("%05d",$&)/e' $mask*

