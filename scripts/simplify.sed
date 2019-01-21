#!/bin/sed -f

# Читаем весь абзац до конца
: read
$ b main;
/\n$/ b main;
N; b read;

: main
s/\\acc{/\\textbf{/g;
s/\\qq{/\\enquote{/g;
s/\\sourceatright{/\\textit{/g;
s/\\mbox{/{/g;
s/\\hyp[[:space:]]*/-/g;
s/\\,/ /g;

# Добавляем пустую строку после абзаца (кроме последней строки)
$! s/^.*$/&\n/;
