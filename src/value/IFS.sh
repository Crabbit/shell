#!/bin/bash
# lili
# date : 2013.8.7 21:09

# 测试IFS将多个符号组合成一个分割符号

OLD_IFS=$IFS
IFS=$'\n'
# 注意，以回车作为分割符，IFS必须为$'\n'

# 查看IFS值
# 默认按照 040空格，011Tab，012换行.来拆解读入变量，然后对字符进行处理，
# 最后将重新组合赋值给变量.
echo $IFS | od -b

IFS=";"
#这里注意要将分号引起来，不然会
test=";;;a;;b;;c"
(echo $test)
{ echo "$test";}
echo $test
echo "$test"
# 如果不用冒号将变量引起来，则表示这个变量不用IFS替换.
# 否则输出时，则根据IFS的值来分割后并输出
# 这里写了2种写法，可以参考file+date.sh那个文件中所提及到的注意事项

# 运行的时候，可以添加参数,例如：
# sh IFS.sh 1 2 3
# 可以观察下面的输出结果有何不同
# 如果用引号引起来，则会自动在变量中添加IFS分割符号
echo $*
echo "$*"
echo $@
echo $#

for value in `echo "haha::#gaga::#aa::#bb"`
do
	echo "!:The value is $value"
done
# 这个例子中，系统会将IFS

# IFS对空格的处理和其他字符不一样，左右两半的纯空白会被忽略，多个连续的空格当成一个IFS处理
IFS=$' '
for value in `echo "haha  gaga  aa      bb"`
do
	echo "  The value is $value"
done
IFS=$ODL_IFS

# '' "" 
A="1
2
"

echo "echo \$A"
echo $A

echo "echo '\$A'"
echo '$A'
echo "$A"
echo '"$A"'
echo "'$A'"

#
echo "A=B A=C"
A=B A=C
echo "echo \$A"
echo $A

A="B C" echo $A
echo $A

