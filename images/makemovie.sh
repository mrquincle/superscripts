#!/bin/bash

output=$1

mencoder "mf://*.jpeg" -mf fps=10 -o "${output}.avi" -ovc lavc -lavcopts vcodec=msmpeg4v2:vbitrate=800
