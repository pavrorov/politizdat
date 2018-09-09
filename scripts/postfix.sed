#!/bin/sed -f

# Читаем весь абзац до конца
: read
$ b main;
/\n$/ b main;
N; b read;

: main
# Комментарии в середине строки придётся удалить
/^[[:space:]]*%/ { P; D }
s/\([^\\]\)%[^\n]*\n/\1/g;

# Удаляем последний перевод строки
s/[[:space:]]\+$//;

# Удаляем любые пробелы перед сноской
s/\([[:space:]~]\+\|\\,\)\(\\[[:upper:][:lower:]]\+note\(mark\|\(text\)\?[[:space:]]*{\)\)/\2/g;

# Восстанавливаем ключи ссылок на литературу
s/\(\\[[:upper:][:lower:]]*cite[[:lower:]]*\)\([[:space:]]*\[[^]]*\]\)\?\([[:space:]]\+\)\?{\([^}]*\)-\+\([^}]*\)}/\1\2\3{\4-\5}/g;
s/\(\\[[:upper:][:lower:]]*cite[[:lower:]]*\)\([[:space:]]*\[[^]]*\]\)\?\([[:space:]]\+\)\?{\([^}]*\)\.~\([^}]*\)}/\1\2\3{\4.\5}/g;
s/\(\\[[:upper:][:lower:]]*cite[[:lower:]]*\)\([[:space:]]*\[[^]]*\]\)\?\([[:space:]]\+\)\?{\([^}]*\)\\,\([^}]*\)}/\1\2\3{\4\5}/g;
s/\(\\[[:upper:][:lower:]]*cite[[:lower:]]*\)\([[:space:]]*\[[^]]*\]\)\?\([[:space:]]\+\)\?{\([^}]*\)\\[[:lower:]]*hyp\([[:space:]]\+\|{}\)\([^}]*\)}/\1\2\3{\4-\6}/g;
s/\(\\[[:upper:][:lower:]]*cite[[:lower:]]*\)\([[:space:]]*\[[^]]*\]\)\?\([[:space:]]\+\)\?{\([^}]*\)\\mbox{\([^}]*\)}\([^}]*\)}/\1\2\3{\4\5\6}/g;
s/\(\\[[:upper:][:lower:]]*cite[[:lower:]]*\)\([[:space:]]*\[[^]]*\]\)\?\([[:space:]]\+\)\?{\([^}]*\)--\+\([^}]*\)}/\1\2\3{\4-\5}/g;

# Восстанавливаем метки
s/\(\\\(label\|startlabel\|ref\|pageref\|rangeref[[:lower:]]*\)\)\([[:space:]]*\[[^]]*\]\)\?\([[:space:]]\+\)\?{\([^}]*\)\\hyp[[:space:]]*\([^}]*\)}/\1\3\4{\5-\6}/g;

# Восстанавливаем ошибочно связанные команды
s/\(\\[[:lower:]]\+=[0-9]\+\)~/\1\n/g;

# Восстанавливаем тире после популярных названий
s/\(Интернационал\([ау]\|ом\|ах\)\)--\([[:upper:]][[:lower:]]\+\)/\1~--- \3/g;

# Восстанавливаем URL-адреса
:url
s/\(\\\(url\){[[:space:]]*[^}]\+\)\\\(\(no\)\?hyp\({}\)\?\)[[:space:]]*\([^}]\+[[:space:]]*}\)/\1-\6/g;
t url;

# Добавляем пустую строку после абзаца (кроме последней строки)
$! s/^.*$/&\n/;
