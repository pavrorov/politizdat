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

# Соединяем короткие слова (предлоги) со следующим словом
s/\(^\|[[:space:]~…(]\|\\ldots{}\)\(\(\\[[:upper:][:lower:]]\+{\)\?[АВИКОСУЯвкосуя]}*\)[[:space:]]\+/\1\2~/g;
s/\(^\|[[:space:]~…(]\|\\ldots{}\)\(\(\\[[:upper:][:lower:]]\+{\)\?\([Вв]о\|[Кк]о\|[Сс]о\|[Тт]о\|[Оо]б\)}*\)[[:space:]]\+/\1\2~/g;

# Связываем короткие слова (сокращения) с предыдущим словом
s/[[:space:]]\+\(\\[[:upper:][:lower:]]\+{\)\?\([[:upper:][:lower:]]\{1,2\}\.}*\([})[:space:]]\|~-\|$\)\)/~\1\2/g;

# Слияние пробелов
s/~[[:space:]]\+/~/g;

# Добавляем пустую строку после абзаца (кроме последней строки)
$! s/^.*$/&\n/;
