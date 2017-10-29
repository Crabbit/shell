#!/bin/bash
#
# Creat Time :Tue 05 Nov 2013 07:50:34 PM GMT
# Autoor     : lili

cat > redirect.txt << "EOF"
This is the 1st line.
This is the 2nd line.123456789..123456789
This is the 3rd line.
EOF


exec 3<> redirect.txt
read line <&3
echo "Read : $line"
# Attention.
# the next input will cover the content.
# because of the file point.

echo "This is a test line." >&3

# turn off the 3 file description
exec 3>&-

cat redirect.txt
rm -fr direct.txt
