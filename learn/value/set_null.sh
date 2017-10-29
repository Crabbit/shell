#!/bin/bash
#
# Creat Time :Mon 11 Nov 2013 11:42:16 PM GMT
# Autoor     : lili
showvar11()
{
	var=${str=expr}
	echo -n -e str=expr  --  \$str is $str .
	echo -e str=expr  --  \$var is $var .
}

showvar12()
{
	var=${str:=expr}
	echo -n -e str:=expr  --  \$str is $str .
	echo -e str:=expr  --  \$var is $var .
}

showvar21()
{
	var=${str-expr}
	echo -n -e str-expr  --  \$str is $str .
	echo -e str-expr  --  \$var is $var .
}

showvar22()
{
	var=${str:-expr}
	echo -n -e str:-expr  --  \$str is $str .
	echo -e str:-expr  --  \$var is $var .
}

showvar31()
{
	var=${str+expr}
	echo -n -e str+expr  --  \$str is $str .
	echo -e str+expr  --  \$var is $var .
}

showvar32()
{
	var=${str:+expr}
	echo -n -e str:+expr  --  \$str is $str .
	echo -e str:+expr  --  \$var is $var .
}
unset str
showvar11
showvar12
showvar21
showvar22
showvar31
showvar32
echo "_________________________"
str=
showvar11
showvar12
showvar21
showvar22
showvar31
showvar32
echo "_________________________"
str=xyz
showvar11
showvar12
showvar21
showvar22
showvar31
showvar32
echo "_________________________"
