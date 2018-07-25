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
s/\(^\|[[:space:]~…(]\|\\ldots{}\)\(\(\\[[:upper:][:lower:]]\+{\)*[АВИКОСУЯвкосуя]}*\)[[:space:]]\+/\1\2~/g;
s/\(^\|[[:space:]~…(]\|\\ldots{}\)\(\(\\[[:upper:][:lower:]]\+{\)*\([ВвДдКкСсТтПпН]о\|[Оо][бт]о\?\|[Ии]з\|[Нн][еи]\|[Дд]а\|T[оеу]\)}*\)[[:space:]]\+/\1\2~/g;

# Не окружаем "по" и "до" неразрывными пробелами, а связываем
# со следующим словом
s/~\([ДдПп]о\)~/ \1~/g;

# Связка "Как~то"
s/\(Как\)[[:space:]]\+\(то[~[:space:]]\+\)/\1~\2/g;

# А "ж" и "же" --- с предыдущим словом
s/[[:space:]]\+\(\(\\[[:upper:][:lower:]]\+{\)*\(же\?\)}*\)\([[:space:]~…(]\|\\ldots{}\|$\)/~\1\4/g;

# Связываем короткие слова (сокращения) с предыдущим словом
s/[[:space:]]\+\(\\[[:upper:][:lower:]]\+{\)*\([[:upper:][:lower:]]\{1,2\}\.}*\([}),;:[:space:]]\|~-\|\]\|\\[[:upper:][:lower:]]\|$\)\)/~\1\2/g;

# Слияние пробелов
s/~[[:space:]]\+/~/g;

# Добавляем пустую строку после абзаца (кроме последней строки)
$! s/^.*$/&\n/;
