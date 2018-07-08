#!/bin/sh -efu

INPUT="$1"; shift
ret=0

# Проверка подозрительных последовательностей, не обязательно
# являющихся ошибочными, но требудщих ручного контроля.
# 
# 1) Проверка на отсутствие знака препинания перед сноской.
# 2) Проверка знаков !? после группы.
# 3) Проверка экранированных пробелов (\ ).
# 4) Проверка неразделённых чисел.
cat "$INPUT" | \
sed -e 's/\(\\[[:upper:][:lower:]]*cite[[:lower:]]*\)\([[:space:]]*\[[^]]*\]\)\?\([[:space:]]\+\)\?{\([^}]*\)}/\1\2\3{@@@@}/g' \
	-e 's/\(\\begin{minipage}\)\(\(\[[^]]*\]\)\+\)\?{\([^}]*\)}/\1\2{@@@@}/g' \
| grep -Hn --color --label="$INPUT" \
	 -e '\(~\+-*\|[.,;:]\+\)[[:space:]]*\\\(cite\|[[:lower:]]*note\)' \
	 -e '}[[:space:]]*[?!]' \
	 -e '\\[[:space:]]' \
	 -e '[0-9IVXLCM][,.;:][0-9IVXLCM]' \
|| ret=$?

[ $ret -ne 0 ]
