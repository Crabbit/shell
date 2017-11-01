#!/bin/bash

awk '{
    word = $1;
    count = $2;
    #print "---- debug ----"
    #print "word="word
    #print "last="last
    #print "sum="sum
    #print "---- end ----"
    if ( word != last ){
        if ( sum > 0 ){
            print last"\t"sum;
        }
        last = word;
        sum = count;
    }
    else{
        sum += count;
    }
}
    END{
        if ( word == last ){
                print last"\t"sum;
        }
}'
