#!/bin/bash
#
# Creat Time :Mon 18 Nov 2013 09:38:41 PM GMT
# Autoor     : lili

# ? 问号表明前面的字符可以出现0次或1次
# 但只限于此，不会匹配多次出现的该字符

echo "_________echo "al" | awk '/ao?l/{print \$0}'"
echo "al" | awk '/ao?l/{print $0}'
echo

echo "_________echo "aol" | awk '/ao?l/{print \$0}'"
echo "aol" | awk '/ao?l/{print $0}'
echo

echo "_________echo "aool" | awk '/ao?l/{print \$0}'"
echo "aool" | awk '/ao?l/{print $0}'
echo

# + 加号表明前面的字符可以出现1次货多次.
# 但必须至少出现1次.

echo "_________echo "al" | awk '/ao+l/{print \$0}'"
echo "al" | awk '/ao+l/{print $0}'
echo

echo "_________echo "aol" | awk '/ao+l/{print \$0}'"
echo "aol" | awk '/ao+l/{print $0}'
echo

echo "_________echo "aool" | awk '/ao+l/{print \$0}'"
echo "aool" | awk '/ao+l/{print $0}'
echo


# 默认情况下,awk程序不会识别正则表达式区间.必须指定
# awk --re-interval
# 区间限定了该字符在匹配模式的字符串中出现的次数
# 这个例子中，o可以出现 1或2次

echo "_________echo "al" | awk --re-interval '/ao{1,2}l/{print \$0}'"
echo "al" | awk --re-interval '/ao+l/{print $0}'
echo

echo "_________echo "aol" | awk --re-interval '/ao{1,2}l/{print \$0}'"
echo "aol" | awk --re-interval '/ao+l/{print $0}'
echo

echo "_________echo "aool" | awk --re-interval '/ao+l/{print \$0}'"
echo "aool" | awk --re-interval '/ao+l/{print $0}'
echo
