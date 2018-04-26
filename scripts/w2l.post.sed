# Читаем весь абзац до конца
: read
$ b main;
/\n$/ b main;
N; b read;

: main

# Убираем конечный \endinput
s/\(^\|\n\)\\endinput\(\n\|$\)/\1\2/g;

# Оформляем сноски
s/[[:space:]]*\(\\\(textbf\|textit\|emph\){\)[[:space:]]*\[\(}\\\(textbf\|textit\|emph\){\)\+[[:space:]]*\([^]]*\)[[:space:]]*\(}\\\(textbf\|textit\|emph\){\)\+\(\.*\)\]}/\\footnote{\5\8}/g;
s/[[:space:]]*\(\\\(textbf\|textit\|emph\){\)[[:space:]]*\[\(}\\\(textbf\|textit\|emph\){\)\+[[:space:]]*\([^]]*\)[[:space:]]*\]}/\\footnote{\5}/g;
s/[[:space:]]*\(\\\(textbf\|textit\|emph\){\)[[:space:]]*\[[[:space:]]*\([^]]*\)[[:space:]]*\(}\\\(textbf\|textit\|emph\){\)\+\(\.*\)\]}/\\footnote{\3\6}/g;
s/[[:space:]]*\(\\\(textbf\|textit\|emph\){\)[[:space:]]*\[[[:space:]]*\([^]]*\)[[:space:]]*\]}/\\footnote{\3}/g;
s/[[:space:]]*\[[[:space:]]*\([^]]*\)[[:space:]]*\]/\\footnote{\1}/g;

# Убираем переносы
s/\\-//g;

# Добавляем пустую строку после абзаца (кроме последней строки)
$! s/^.*$/&\n/;
