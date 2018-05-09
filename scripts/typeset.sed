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

# Сливаем пробелы в один, удаляем последний перевод строки
s/\([^[:space:]]\)\\\?[ \t]\+/\1 /g;
s/[[:space:]]\+$//;

# Исправляем отбитые знаки препинания
s/\([[:upper:][:lower:]]\)\([[:space:]]\+\)\([.,;]\)\([^.]\|$\)/\1\3\2\4/g;

# Выносим пробелы из групп (курсив, жирный и пр.)
s/\([[:upper:][:lower:].,;]\)\(\\[[:upper:][:lower:]]\+\){[ \t]\+/\1 \2{/g;
s/\([.,;]*\)[ \t]\+}\([[:upper:][:lower:]]\|$\)/}\1 \2/g;

# Заменяем некоторые shortcuts
s/"--~/--/g;

# Нормализуем кавычки
s/"\([^"]*\)"/\\qq{\1}/g;
s/[«„]/\\qq{/g; s/[»”“]/}/g;

# Сноски без отрыва
s/[[:space:]~]\+\(\\\(cite\|[[:lower:]]*note\)[[{]\)/\1/g;
s/\(~-*\|[,;:-]\+\)\(\\\(cite\)\(\[[^]]*\]\)\?\({[^}]*}\)\)/\2\1/g;
s/\([})]\)\.\(\\\(cite\)\(\[[^]]*\]\)\?\({[^}]*}\)\)/\1\2./g;

# Неразрывный набор дат
s/\([0-9]\{1,2\}\)[[:space:]]\+\(\([Яя]нв\|[Фф]ев\|[Мм]ар\|[Аа]пр\|[Мм]ая\|[Ии]юн\|[Ии]юл\|[Аа]вг\|[Сс]ен\|[Оо]кт\|[Нн]оя\|[Дд]ек\)[[:lower:].]*\)/\1~\2/g;
s/\(^\|[[:space:]~]\)\(\([Яя]нв\|[Фф]ев\|[Мм]ар\|[Аа]пр\|[Мм]ая\|[Ии]юн\|[Ии]юл\|[Аа]вг\|[Сс]ен\|[Оо]кт\|[Нн]оя\|[Дд]ек\)[[:lower:].]*\)[[:space:]]\+\([0-9]\{4\}\)/\1\2~\4/g;

# Неразрывный набор времени
s/\([0-9]\{1,2\}\)[[:space:]]\+\(час\.\)[[:space:]]\+\([0-9]\{1,2\}\)/\1~\2~\3/g;
s/\([0-9]\{1,2\}\)[[:space:]]\+\(час\.\|мин\.\)\([;,[:space:]]\|$\)/\1~\2\3/g;

# Сокращения после чисел через неразрывный пробел
s/\([0-9IVXLCM]\+\)[[:space:]]\+\(\([Оо]б\)\.\)/\1~\2/g;

# Короткий неразрывный пробел для годов и единиц измерения
s/\([0-9IVXLCM]\+\)[[:space:]~]*\(\(\\[[:upper:][:lower:]]\+{\)\?\([БВГДЖЗКЛМНПРСТФХЦЧШЩбвгджзклмнпрстфхцчшщ]\+]\|тыс\|млн\|млрд\|трлн\)\.}*\)/\1~\2/g;
s/\([0-9IVXLCM]\+\)\(~\(\\[[:upper:][:lower:]]\+{\)\?\([БВГДЖЗКЛМНПРСТФХЦЧШЩбвгджзклмнпрстфхцчшщ]\+]\|тыс\|млн\|млрд\|трлн\)\.}*\)*[[:space:]~]*\(\(\\[[:upper:][:lower:]]\+{\)\?[БВГДЖЗКЛМНПРСТФХЦЧШЩбвгджзклмнпрстфхцчшщ]\+}*[\/.]\)/\1\2\\,\5/g;
s/\([0-9IVXLCM]\+\)\(~\(\\[[:upper:][:lower:]]\+{\)\?\([БВГДЖЗКЛМНПРСТФХЦЧШЩбвгджзклмнпрстфхцчшщ]\+]\|тыс\|млн\|млрд\|трлн\)\.}*\)*[[:space:]~]*\(\(\\[[:upper:][:lower:]]\+{\)\?[кМГмн]\?\([млгНВА]\|Вт\|Дж\|Па\)\(}*[\/.,;[:space:]]\|$\)\)/\1\2\\,\5/g;
s/\([0-9]\+\([\/,.][0-9]\)\?\)[[:space:]]*\\%/\1\\,\\%/g;

# Сокращения перед числами через неразрывный пробел
s/\(^\|[[:space:]]\+\|~\|[{[]\)\([Ии]зд\|[Сс]\|[Сс]тр\|[Тт]\|[Кк]н\|[Пп]п\?\|[Лл]\.[[:space:]]*д\)\.[[:space:]]\+\(\(\\[[:upper:][:lower:]]\+{\)\?[0-9IVXLCM]\+\)/\1\2.~\3/g;

# Номера и параграфы через короткий неразрывный пробел
s/№[[:space:]]*\([0-9[:upper:][:lower:]]\)/\\textnumero\\,\1/g;
s/§[[:space:]]*\([0-9[:upper:][:lower:]]\)/\\S\\,\1/g;

# Короткое тире в диапазонах
s/\(^\|[[:space:].,{~-]\)\([0-9IVXLCM]\+\(-[[:lower:]]\+\)\?\)[[:space:]]*[-–—][[:space:]]*\([0-9IVXLCM]\+\(-[[:lower:]]\+\)\?\)\([~[:space:]}.,-]\|\\,\|$\)/\1\2\--\4\6/g;
s/\(^\|[[:space:].,{~-]\)\([0-9IVXLCM]\+\(-[[:lower:]]\+\)\?\)\([[:space:]]\+[-–—]\+[[:space:]]*\|[[:space:]]*[-–—]\+[[:space:]]\+\)\([0-9IVXLCM]\+\(-[[:lower:]]\+\)\?\)\([~[:space:]}.,-]\|\\,\|$\)/\1\2\--\5\7/g;

# Тире
s/\(^\|[[:space:]]\+\)[-–—]\+\([[:space:]]\+\|$\)/\1---\2/g;
s/[[:space:]]\+--/~--/g;
s/\([0-9IVXLCM]\+\(-[[:lower:]]\{1,3\}\)\?}*\)~---/\1~--/g;

# Не отрываем число от следующего за ним слова
s/\(^\|[[:space:](.,{~-]\|\\S\\,\|\\textnumero\\,\)\([0-9IVXLCM]\+\(-[[:lower:]]\{1,3\}\)\?}\?\)[[:space:]]\+\([^[:space:]]\|$\)/\1\2~\4/g;
# Сразу же восстанавливаем ошибочно связанные ссылки
s/\(\\[[:upper:][:lower:]]*cite\)\([[:space:]]*\[[^]]*\]\)\?\([[:space:]]\+\)\?{\([^}]*[0-9IVXLCM]\+\)}~/\1\2\3{\4} /g;

# Восстанавливаем тире после ссылок
s/\(\\[[:lower:]]*cite\(\[[^]]\+\]\)\?{[^}]\+[0-9IVXLCM]\+}\)[[:space:]]*--\([[:space:]]\+\|$\)/\1~---\3/g;

# Не отрываем нумерацию
s/\(^\|[[:space:]{]\|\\ldots{}\|…\|\.\.\.\)\([0-9IVXLCM]\+\(-[[:lower:]]\+\)\?[).]}\?\)[[:space:]]\+/\1\2~/g;
#s/\(^\|[[:space:]]\|\\ldots{}\|…\|\.\.\.\)\(\\[[:upper:][:lower:]]\+\)\?{\([0-9IVXLCM]\+\(-[[:lower:]]\+\)\?[).]\)}[[:space:]]\+/\1\2{\3}~/g;

# Наращение диапазона помещаем в \mbox{}
s/--\([0-9IVXLCM]\+\)-\([[:upper:][:lower:]]\{1,3\}\)\([[:space:]~.,;:)}?!-]\|\\,\|$\)/--\\mbox{\1-\2}\3/g;

# Словесно-цифровую форму разделяем неразрывным дефисом
s/\([0-9IVXLCM]\+\)-\([[:upper:][:lower:]]\{6,\}-*\)/\1\\nohyp{}\2/g;

# Обращения через короткий неразрывный пробел
s/\(^\|[[:space:](]\+\|{\)\(т\|тов\|г\)\.[[:space:]]\+\(\(\\[[:upper:][:lower:]]\+{\)\?[[:upper:]]\(\.\|[[:lower:]]\+\)}\?\)/\1\2.\\,\3/g;

# Сокращения через обычный неразрывный пробел
s/\(^\|[[:space:](]\+\|{\)\(\([Сс]м\|[Пп]л\|[Уу]л\|Тов\|[Тт]т\|[Тт]\.т\|Гос\|[Гг]г\|[Гг]\.г\|[Мм]м\|[Мм]\.м\|[Оо]бв\|[Сс]р\|[Пп]роф\|[Аа]кад\|[Ии]нж\)\.}\?\)[[:space:]]\+/\1\2~/g;
s/\([[:upper:][:lower:]]\+\.\)\([0-9IVXLCM]\+\)/\1~\2/g;

# Разрывное короткое тире в сочетаниях фамилий
# (дефис оставлен для составных фамилий)
s/\([[:upper:]][[:lower:]]\+\)[[:space:]]*[–—][[:space:]]*\([[:upper:]][[:lower:]]\+\)/\1--\2/g;
s/\([[:upper:]][[:lower:]]\+\)[[:space:]~]\+[-]\+[[:space:]]\+\([[:upper:]][[:lower:]]\+\)/\1--\2/g;

# Разрывный дефис для длинных составных слов
s/\([[:upper:][:lower:]]\{5,\}\)[[:space:]]*-[[:space:]]*\([[:upper:][:lower:]]\{6,\}\)/\1\\hyp \2/g;
s/\([[:upper:][:lower:]]\{6,\}\)[[:space:]]*-[[:space:]]*\([[:upper:][:lower:]]\{5,\}\)/\1\\hyp \2/g;
s/\\hyp[[:space:]]*\(нибудь\)/-\1/g;

# Выделения в тексте
s/\\textit{/\\emph{/g; s/\\textbf{/\\acc{/g;

# Прижимаем многоточие влево
s/\(^\|[^:]\)[[:space:]]\+\(…\|\.\.\.\|\\ldots{}\)\([[:space:])}]\)/\1\2\3/g;

# Убираем пробел после многоточия вначале предложения
s/\(^[ \t]*\|\n[ \t]*\|{\)\(…\|\.\.\.\|\\ldots\({}\)\?\)[[:space:]]\+/\1\\ldots{}/g;

# Заменяем остальные многоточия на \ldots{}
s/\(…\|\.\.\.\)/\\ldots{}/g;

# Инициалы после фамилий через обычный неразрывный пробел пробел
s/\([[:upper:]][[:lower:]]\{2,\}}\?\)[[:space:]]\+\([[:upper:]]\.\)/\1~\2/g;
s/\([[:upper:]][[:lower:]]\{2,\}}\?\)[[:space:]]\+\(\(Вл\|Мих\|Дж\|Эд\)\.\)/\1~\2/g;

# Группа инициалов через короткий неразрывный пробел
s/\(^\|[[:space:]~({]\+\)\(\(\\[[:upper:][:lower:]]\+{\)\?[[:upper:]]\.\)[[:space:]]*\([[:upper:]]\.}*\)/\1\2\\,\4/g;
s/\(^\|[[:space:]~(]\+\)\(\(\\[[:upper:][:lower:]]\+{\)\?\(Вл\|Мих\|Дж\|Эд\)\.\)[[:space:]]*\([[:upper:]]\.}*\)/\1\2\\,\5/g;

# Инициалы перед фамилией через короткий неразрывный пробел
s/\(^\|[[:space:]({]\+\|\(^\|[[:space:]]\)[[:upper:]]\?[[:lower:]]\{,3\}\.\?~\)\(\(\(т\|тт\|г\|гг\|Г\|Т\|Тов\)\.[[:space:]~]*{*\)\?\(\\[[:upper:][:lower:]]\+{\)\?\([[:upper:]][[:lower:]]*\.\\,\)*[[:upper:]][[:lower:]]\{,2\}\.}*\)[[:space:]]*\(\(\\[[:upper:][:lower:]]\+{\)\?[[:upper:]][[:lower:]]\{2,\}\)/\1\3\\,\8/g;
# Восстанавливаем некоторые известные короткие имена и сокращения,
# связанные как инициалы
s/\(Юм[ау]\)\.\\,/\1. /g;
s/\(P\.\\,S\.\)\\,\([А-Я]\)/\1~\2/g;

# Популярные сокращения через короткий неразрывный пробел
s/\(^\|[[:space:]]\)\([Тт]\)\.[[:space:]~]*д\([.…]\|\\ldots\)/\1\2.\\,д\3/g;
s/\(^\|[[:space:]]\)\([Тт]\)\.[[:space:]~]*п\([.…]\|\\ldots\)/\1\2.\\,п\3/g;
s/\(^\|[[:space:]]\)\([Тт]\)\.[[:space:]~]*е\./\1\2.\\,е./g;
s/\(^\|[[:space:]]\)\([Тт]\)\.[[:space:]~]*к\./\1\2.\\,к./g;
s/[[:space:]]\+с\.[[:space:]~]*г\./~с.\\,г./g;
s/\(^\|[[:space:]]\)\([Сс]\)\.[[:space:]~]*г\./\1\2.\\,г./g;
s/\(^\|[[:space:]]\|~\)\([Лл]\)\.[[:space:]~]*д\./\1\2.\\,д./g;

# Связываем аббривеатуры
s/\(^\|[[:space:]~]\+\)\(\(\\[[:upper:][:lower:]]\+{\)\?[А-Я]\{2,\}}*\)[[:space:]]\+\(\(\\[[:upper:][:lower:]]\+{\)\?[А-Я]\{2,\}\)/\1\2~\4/g;

# Добавляем пустую строку после абзаца (кроме последней строки)
$! s/^.*$/&\n/;
