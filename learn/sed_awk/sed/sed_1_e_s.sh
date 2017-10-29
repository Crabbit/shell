#!/bin/bash
#
# Creat Time :Wed 13 Nov 2013 12:56:08 AM GMT
# Autoor     : lili

echo "The origin file :"
cat ./file_1_2_e_s.txt
echo "_____________________________"

echo "The sed output :"
# 注意命令之间必须用分号分隔
# 并且在命令末尾和分号之间不能有空格.
cat ./file_1_2_e_s.txt | sed -e 's/brown/yellow/; s/dog/cat/'
echo "_____________________________"

cat ./file_1_2_e_s.txt | sed -e 's/brown/black/' -e ' s/dog/rabbit/'
echo "_____________________________"

# 必须要注意，要在封尾引号所在的行结束命令
# bash shell 一旦发现了封尾的引号，就会执行命令
sed -e "
s/brown/green/
s/dog/python/
s/fox/elephant/
" file_1_2_e_s.txt
echo "_____________________________"

# 还可以用花括号将多条命令组合在一起。
sed '3,${
s/brown/xxxxx/
s/dog/xxx/
s/fox/xxx/
}' file_1_2_e_s.txt
echo "_____________________________"


# 如果有大量要处理的sed命令，将他们放在一个文件中会方便点
sed -f sed_e_f.script file_1_2_e_s.txt
echo "_____________________________"
