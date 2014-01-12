#!/bin/bash
#
# Creat Time :Sat 11 Jan 2014 10:33:44 PM GMT
# Autoor     : lili

# FS         Input field separator
# RS         Input date line separator
# OFS        Output field separator
# ORS        Output date line separator

# 

gawk 'BEGIN{FS=" "; OFS=" - "} {print $1,$2,$3}' data
