#!/bin/sh
# THe Spacial variable
# Usage : sh spacial.sh $1 $2 ...

echo '$# is :' $#

#拓展为 一个 包含每个参数的单词
echo '$* is :' $*
#每个参数都拓展为一个单词
echo '$@ is :' $@

echo '$? is :' $?
echo '$$ is :' $$
echo '$0 is :' $0
echo '$1 is :' $1
#
#
cd /
#HOME
echo '~  is :' ~
#PWD
echo '~+ is :' ~+
#OLDPWD
echo '~- is :' ~-
