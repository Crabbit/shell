#!/bin/bash
#
# Creat Time :Tue 12 Nov 2013 12:37:38 AM GMT
# Autoor     : lili

DEFAULT="Define the default value."
NODEF="If the value no define,"
NODEF_NULL="The value is no define or the value is null."
ALDEF="If the value is alread define."
ERR_MSG="Print error message."

${var-NODEF}
echo -n "1 {var-}  "
echo $var

unset var
var=
${var:-NODEF_NULL}
echo -n "2 {var:-}  "
echo $var

unset var
${var=NODEF}
echo -n "3 {var:=}  "
echo $var

unset var
${var:=NODEF_NULL}
echo -n "4 {var:=}  "
echo $var

unset var
${var+ALDEF}
echo -n "5 {var:+}  "
echo $var

unset var
${var:+ALDEF}
echo -n "6 {var:+}  "
echo $var

unset var
$var="I'm alread set."
{var:+ALDEF}
echo -n "7 *{var:+}  "
echo $var

unset var
${var?ERR_MSG}
echo -n "8 {var?}"
echo $var

unset var
var=
${var?ERR_MSG}
echo -n "9 *{var?}"
echo $var

unset var
${var?:ERR_MSG}
echo -n "10 {var:?}"
echo $var

unset var
var=
${var:?ERR_MSG}
echo -n "11 *{var:?}"
echo $var
