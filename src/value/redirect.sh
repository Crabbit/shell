#!/bin/bash
#
# distinguish the error information
# and normal information in the scripts.
# >&2   >&1
echo "Error!!!!!!" >&2
echo "Right~~~~~~" >&1

# u can execution like this:
# sh redirect.sh 2> test1
# sh redirect.sh 1> test2
# sh redirect.sh
# u can find out the differenct of it.

# Redirect for all the time.
# u can do it like this:
# but,first you should save the 1 2 by 3 4
exec 3>&1
exec 4>&2

exec 1>status.log
echo "Error!!!!!!" >&2
echo "Right~~~~~~" >&1

# attention, 1> is also effective.
# so,no output in the comand line.
exec 2>error.log
echo "Error!!!!!!" >&2
echo "Right~~~~~~" >&1

# at last,reduction the 1 2
exec 1>&3
exec 2>&4
