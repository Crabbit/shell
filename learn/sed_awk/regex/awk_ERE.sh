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

# 这个例子中，o只能出现 1次
echo "_________echo "al" | awk --re-interval '/ao{1}l/{print \$0}'"
echo "al" | awk --re-interval '/ao{1}l/{print $0}'
echo

# 这里，o可以出现1或2次
echo "_________echo "aol" | awk --re-interval '/ao{1,2}l/{print \$0}'"
echo "aol" | awk --re-interval '/ao{1,2}l/{print $0}'
echo

echo "_________echo "aool" | awk --re-interval '/ao{1,2}l/{print \$0}'"
echo "aool" | awk --re-interval '/ao{1,2}l/{print $0}'
echo

echo "_________echo "azol" | awk --re-interval '/ao{1,2}l/{print \$0}'"
echo "azol" | awk --re-interval '/a[zo]{1,2}l/{print $0}'
echo

echo "_________echo "aozol" | awk --re-interval '/a[zo]{1,2}l/{print \$0}'"
echo "aozol" | awk --re-interval '/a[zo]{1,2}l/{print $0}'
echo

# 使用了逻辑 or 方式，指定正则表达式引擎要用的两个或多个模式
# 注意一点，正则表达式和管道符号之间不能有空格
# 否则它们也会加到正则表达式模式中.
echo "_________echo "cat" | awk '/cat|cut/{print \$0}'"
echo "cat" | awk '/cat|cut/{print $0}'
echo

echo "_________echo "cut" | awk '/cat|cut/{print \$0}'"
echo "cut" | awk '/cat|cut/{print $0}'
echo

# () 聚合表达式
# 正则表达式模式也可以圆括号聚合起来
# 当聚合正则表达式时，改组就会被当成标准字符.

echo "__________echo "cat" | awk '/(c|b)a(b|t)/{print \$0}'"
echo "cat" | awk '/(c|b)a(b|t)/{print $0}'
echo

echo "__________echo "cab" | awk '/(c|b)a(b|t)/{print \$0}'"
echo "cab" | awk '/(c|b)a(b|t)/{print $0}'
echo

echo "__________echo "bat" | awk '/(c|b)a(b|t)/{print \$0}'"
echo "bat" | awk '/(c|b)a(b|t)/{print $0}'
echo

echo "__________echo "cab" | awk '/(c|b)a(b|t)/{print \$0}'"
echo "cab" | awk '/(c|b)a(b|t)/{print $0}'
echo

echo "__________echo "tat" | awk '/(c|b)a(b|t)/{print \$0}'"
echo "tat" | awk '/(c|b)a(b|t)/{print $0}'
echo

echo "__________echo "cac" | awk '/(c|b)a(b|t)/{print \$0}'"
echo "cac" | awk '/(c|b)a(b|t)/{print $0}'
echo

