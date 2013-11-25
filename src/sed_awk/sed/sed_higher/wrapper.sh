#!/bin/bash
#
# Creat Time :Sun 24 Nov 2013 11:56:43 PM GMT
# Autoor     : lili

sed -n '{
1!G
h
$p
}' $1
