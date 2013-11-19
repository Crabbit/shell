#!/bin/bash
#
# Creat Time :Mon 18 Nov 2013 08:30:24 PM GMT
# Autoor     : lili

echo "__________echo "abc" | sed -n '/[[:lower:]]/p'"
echo "abc" | sed -n '/[[:lower:]]/p'
echo

echo "__________echo "ABC" | sed -n '/[[:lower:]]/p'"
echo "ABC" | sed -n '/[[:lower:]]/p'
echo

echo "__________echo "ABC" | sed -n '/[[:upper:]]/p'"
echo "ABC" | sed -n '/[[:upper:]]/p'
echo

# *
# 说明该字符将会在匹配模式的文本中出现0次或多次
echo "__________echo "li" | sed -n '/l*i*/p'"
echo "li" | sed -n '/l*i*/p'

echo "__________echo "lli" | sed -n '/l*i*/p'"
echo "lli" | sed -n '/l*i*/p'

echo "__________echo "llii" | sed -n '/l*i*/p'"
echo "llii" | sed -n '/l*i*/p'

echo "__________echo "lili" | sed -n '/l*i*/p'"
echo "lili" | sed -n '/l*i*/p'

# 星号还可以用在字符组上
echo "_________echo "hat" | sed -n '/[hbc]*[au]t/p'"
echo "hat" | sed -n '/[hbc]*[au]t/p'

echo "_________echo "bat" | sed -n '/[hbc]*[au]t/p'"
echo "bat" | sed -n '/[hbc]*[au]t/p'

echo "_________echo "cat" | sed -n '/[hbc]*[au]t/p'"
echo "cat" | sed -n '/[hbc]*[au]t/p'

echo "_________echo "cut" | sed -n '/[hbc]*[au]t/p'"
echo "cut" | sed -n '/[hbc]*[au]t/p'

echo "_________echo "ccat" | sed -n '/[hbc]*[au]t/p'"
echo "ccat" | sed -n '/[hbc]*[au]t/p'

echo "_________echo "cccat" | sed -n '/[hbc]*[au]t/p'"
echo "cccat" | sed -n '/[hbc]*[au]t/p'

echo "_________echo "cuuuut" | sed -n '/[hbc][au]*t/p'"
echo "cuuuut" | sed -n '/[hbc][au]*t/p'

echo "_________echo "ccccut" | sed -n '/[hbc][au]*t/p'"
echo "cccsut" | sed -n '/[hbc][au]*t/p'

# .  点特殊字符
# 可以和星号特殊字符组合起来  .*
# 表示匹配任意多个任意字符 
echo "__________echo "lili love cici" | sed -n '/lili .* cici/p'"
echo "lili love cici" | sed -n '/lili .* cici/p'

echo "__________echo "cici love lili" | sed -n '/lili .* cici/p'"
echo "cici love lili" | sed -n '/lili .* cici/p'
