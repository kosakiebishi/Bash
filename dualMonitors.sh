#!/bin/bash

	list=`xrandr -q |fmt -1 |grep -B 1 -E '^connected' |sed 's/connected//g' |sed 's/--//g' |tr -s "\n" " "`

	i=0;for item in $list;do
		array[$i]=$item
		i=$(( $i + 1 ))
	done

	if [ "${array[1]}" = "" ];then
		echo "There is only one source"
		zenity --warning --height=20 --text="There is only one source of video signal \n - $array"
	else
		zenity --warning --height=20 --text="Sources:  \n $list"
 
		while [ 1 = 1 ]; do
			choose=`zenity --height=250 --width=400  \
			--list \
				--text="What do you want to do? \n\n" \
			--radiolist \
				--title='Selection' \
				--column=Boxes \
				--column=Selections TRUE "DualView" FALSE "Monitor-2-Off" FALSE "Monitor-2-On"  \
				--separator=':'`
			
			if [ "$choose" = "DualView" ];then
				xrandr --auto --output ${array[0]} --left-of ${array[1]}
			elif [ "$choose" = "Monitor-2-Off" ];then
				xrandr --output ${array[1]} --off
			elif [ "$choose" = "Monitor-2-On" ];then
				xrandr --output ${array[1]} --auto
			else
				echo "exit"
				exit
			fi
		done
	fi
