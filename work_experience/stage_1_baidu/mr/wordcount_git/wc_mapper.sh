#!/bin/bash

awk '{
    for( i = 1; i <= NF; i++ ){
        #print "---debug---"
        #print "i="i
        #print "NF="NF
        #print "---end---"

        print $i"\t"1
    }
}'
