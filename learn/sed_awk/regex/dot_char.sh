#!/bin/bash
#
# Creat Time :Mon 18 Nov 2013 03:16:50 AM GMT
# Autoor     : lili

tempfile=`mktemp sed_file.XXXX`
cat > $tempfile << "EOF"
This is the first line of this test.
Are you kidding me?
Aat??what's this?fuck!
atme...
11
2b
33
44
55
What do you want to do??
you wear a hat??
or you see a cat??
Do you mean I didn't lvoe u??
EOF

echo "___________cat $tempfile"
cat $tempfile
echo

# 匹配含有 xxxat 的单词
echo "___________sed -n '/.at/p' $tempfile"
sed -n '/.at/p' $tempfile
echo

# 现在指定匹配 cat  hat 
echo "___________sed -n '/[ch]at/p' $tempfile"
sed -n '/[ch]at/p' $tempfile
echo

# 可以这样使用
# 
echo "Yes" | sed -n '/[Yy]es/p'
echo
# 注意添加前后标记符号
# 来限定匹配的一定是yes,不会是什么yess之类.
echo "yes" | sed -n '/^[Yy][Ee][Ss]$/p'
echo


# 使用排除数组,添加一个脱字符
# 这样会排除 hat mat
echo "hat" | sed -n '/[^hm]at/p'
echo
echo "cat" | sed -n '/[^hm]at/p'
echo


# 也可以后面不指定，一样能匹配出来.
sed -n '/[01234][01234]/p' $tempfile
# 也可以这样使用区间.
# 区间可以不连续
# 这里第一位是 0-1 || 3-4
# 第二位是 0-3
sed -n '/[0-13-4][0-3]/p' $tempfile
# 区间一样适用于字母
# 第二位是 a-c || e-z
echo "ha12" | sed -n '/[a-z][a-ce-z][0-9]/p'

rm -fr $tempfile
