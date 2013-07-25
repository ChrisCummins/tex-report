#!/bin/bash

main=main.tex
target_wordcount=10000
dir=.
i=0

for input in $(cat $dir/$main | grep '\input{' | sed -r 's/[ ]*\\input\{(.*)\}/\1/' |
	grep -v '^title$' |
	grep -v '^abstract$' |
	grep -v '^appendices$' |
	grep -v '^ref$' |
	grep -v '^wc$')
do
	file=$dir/$input.tex

	if [[ $(wc $file | awk '{print $1}') > 0 ]]; then
		wc=$(texcount $dir/$file 2>/dev/null | grep 'Words in text' | tail -n1 | awk '{ print $4 }')
		p=$(echo "( $wc / $target_wordcount ) * 100" | bc -l | xargs printf "%.0f")
		echo -e "$wc\t$p%\t$input"
		i=$((i+wc))
	else
		echo -e "0\t0%\t$input"
	fi
done

echo -e "$i\t$(echo "( $i / $target_wordcount ) * 100" | bc -l | xargs printf "%.0f")%"
