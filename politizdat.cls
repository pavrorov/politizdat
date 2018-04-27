% politizdat.cls
% Copyright 2018 Pavel Avrorov <avrorov@priboy.online>
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
% 
% The Current Maintainer of this work is Pavel Avrorov.
%
% This work consists of one file: politizdat.cls.

%% Politizdat
%% ==========
%%
%% Пакет <<Политиздат>> предназначен для оформления книг, брошюр,
%% статей и листовок в соответствии с высокими требованиями,
%% предъявляемыми к изданиям научной политической литературы, таким
%% как труды классиков марксизма-ленинизма, научных работ и учебных
%% пособий в данной области. В зависимости от настроек, пакет способен
%% формировать текст как со сложной, так и с простой линейной
%% структурой, благодаря чему один и тот же исходный текст может быть
%% использован как для подготовки материала к типографской печати, так
%% и для электронной публикации (посредством `tex4ht`).

%%
%% Выходные данные пакета: `politizdat 2015/01/29`
\ProvidesClass{politizdat}[2015/01/29 Politizdat class]

%%
%% Для работы пакета требуется версия LaTeX не ниже LaTeX2e
%% 2005/12/01. Кроме базовой системы, требуется наличие пакета
%% `biblatex` для работы со ссылками на литературу и пакета
%% `xparse` для определения макрокоманд с расширенным синтаксисом.
%% Также подключается пакет `csquotes` для корректной обработки
%% кавычек, пакет `xpunctuate`. Базовым классом является пакет
%% `memoir`.

\NeedsTeXFormat{LaTeX2e}[2005/12/01] % ограничение на версию LaTeX

%%
%% Настройка пакета
%% ----------------

%%
%% ### Базовая настройка
%%
%% * **`book`** Книжное издание. Ссылки на литературу и примечания
%% оформляются в виде сносок внизу страницы. Нумерация сносок
%% возобновляется на каждой чётной странице (левой странице
%% разворота). По умолчанию выбирается стандартный размер книжного
%% блока 60x90/16 с нормальным размером полосы и базовым шрифтом
%% 10 пт.
\DeclareOption {book}
  {%
    \@inlinenotesfalse%
    \@inlinebibfalse%
    \@perpagetrue%
    \ExecuteOptions {60x90/16,10pt,onecolumn,headersoff}%
    \setlinespread{0.9}%
  }

%%
%% * **`journal`** Журнальное издание. Во всём аналогично книжному,
%% только по умолчанию выбирается больший формат книжного блока
%% 70x108/16 и перед названием главы не ставится префикс «Глава N».
%% Кроме того, вместо заголовка «Оглавление» выводится заголовок
%% «Содержание».
\newif\if@journal\@journalfalse
\DeclareOption {journal}
  {%
    \@journaltrue%
    \@inlinenotesfalse%
    \@inlinebibfalse%
    \@perpagetrue%
    \ExecuteOptions {70x108/16,10pt,headerson}%
    \setlinespread{0.9}%
  }

%%
%% * **`plain`** Издание с однородной структурой. Ссылки на литературу
%% и примечания оформляются в скобках в основном тексте издания.
\DeclareOption {plain}
  {%
    \@inlinenotestrue%
    \@inlinebibtrue%
    \@perpagefalse%
    \ExecuteOptions {a4,11pt,onecolumn}%
    \setlinespread{1.0}%
  }

%%
%% * **`9pt`** ... **`12pt`**, **`14pt`** Набор опций для выбора
%% размера базового шрифта.
\DeclareOption {9pt} {\PassOptionsToClass {9pt} {memoir}}
\DeclareOption {10pt} {\PassOptionsToClass {10pt} {memoir}}
\DeclareOption {11pt} {\PassOptionsToClass {11pt} {memoir}}
\DeclareOption {12pt} {\PassOptionsToClass {12pt} {memoir}}
\DeclareOption {14pt} {\PassOptionsToClass {14pt} {memoir}}

%%
%% * **`84x108/8`** Формат книжного блока 84x108/8. Размер
%% необрезанного блока --- 270 x 420 мм, обрезанного --- 265 x 410 мм.
\DeclareOption {84x108/8} {%
  \renewcommand{\pltzdt@bookformat}{84x108/8}%
}

%%
%% * **`60x84/8`** Формат книжного блока 60x84/8. Размер необрезанного
%% блока --- 210 x 300 мм, обрезанного --- 205 x 290 мм.
%% Используется по умолчанию для журнальных изданий (опция `journal`).
\DeclareOption {60x84/8} {%
  \renewcommand{\pltzdt@bookformat}{60x84/8}%
}

%%
%% * **`70x108/16`** Формат книжного блока 70x108/16. Размер
%% необрезанного блока --- 175 x 270 мм, обрезанного --- 170 x 260 мм.
\DeclareOption {70x108/16} {%
  \renewcommand{\pltzdt@bookformat}{70x108/16}%
}

%%
%% * **`60x90/16`** Формат книжного блока 60x90/16. Размер
%% необрезанного блока --- 150 x 225 мм, обрезанного --- 145 x 215 мм.
%% Используется по умолчанию для книжных изданий (опция `book`).
\newcommand{\pltzdt@bookformat}{60x90/16}
\DeclareOption {60x90/16} {%
  \renewcommand{\pltzdt@bookformat}{60x90/16}%
}

%%
%% * **`84x108/32`** Формат книжного блока 84x108/32. Размер
%% необрезанного блока --- 135 x 210 мм, обрезанного --- 130 x 200 мм.
\DeclareOption {84x108/32} {%
  \renewcommand{\pltzdt@bookformat}{84x108/32}%
}

%%
%% * **`75x90/32`** Формат книжного блока 75x90/32. Размер
%% необрезанного блока --- 112,5 x 187 мм, обрезанного ---
%% 107,5 x 177 мм.
\DeclareOption {75x90/32} {%
  \renewcommand{\pltzdt@bookformat}{75x90/32}%
}

%%
%% * **`70x90/32`** Формат книжного блока 70x90/32. Размер
%% необрезанного блока --- 112,5 x 175 мм, обрезанного ---
%% 107,5 x 165 мм.
\DeclareOption {70x90/32} {%
  \renewcommand{\pltzdt@bookformat}{70x90/32}%
}

%%
%% * **`a4`** Формат книжного блока A4/A4+. Размер необрезанного
%% блока --- 215 x 307 мм, обрезанного --- 210 x 297 мм.
%% Используется по умолчанию для изданий с однородной структурой
%% (опция `plain`).
\DeclareOption {a4} {%
  \renewcommand{\pltzdt@bookformat}{a4}%
}

%%
%% * **`a5`** Формат книжного блока A5/A5+. Размер необрезанного
%% блока --- 153,5 x 220 мм, обрезанного --- 148,5 x 210 мм.
\DeclareOption {a5} {%
  \renewcommand{\pltzdt@bookformat}{a5}%
}

%%
%% * **`6in`** Формат страницы с диагональю 6" (90x120
%% мм). Соответствует размеру страницы стандартной портативной
%% электронной книги.
\DeclareOption {6in} {%
  \renewcommand{\pltzdt@bookformat}{6in}%
}

%%
%% ### Настройка параметров страницы книжного блока

%%
%% * **`econom`** Экономный формат полосы. Размер полосы на 0,25 кв.
%% (12 пт) шире и на 0,25 кв. длиннее, чем в нормальном формате.
\newif\if@econombs\@econombsfalse
\DeclareOption {econom} {\@econombstrue\@normbsfalse\@imprvbsfalse}

%%
%% * **`normal`** Нормальный формат полосы. Размер полей является
%% компромиссом между удобством чтения и вместительностью полосы.
\newif\if@normbs\@normbstrue
\DeclareOption {normal} {\@econombsfalse\@normbstrue\@imprvbsfalse}

%%
%% * **`imprv`** Улучшенный формат полосы. Размер полосы на 0,25 кв.
%% (12 пт) уже и на 0,25 кв. короче, чем в нормальном формате.
\newif\if@imprvbs\@imprvbsfalse
\DeclareOption {imprv} {\@econombsfalse\@normbsfalse\@imprvbstrue}

%%
%% * **`trim`** Размер страницы электронной копии издания равняется
%% размеру *обрезанного* книжного блока выбранного формата.
%% Необходимое для обрезки бумажного блока увеличение полей страницы
%% должно быть выполнено отдельно, например, при компоновке (спуске)
%% полос на печатный лист. Обычно данный режим подходит для отправки
%% оригинал-макета в типографию, которая выполняет эту процедуру
%% самостоятельно. Также подходит и для самостоятельной печати издания
%% без последующего обрезания блока. Данный режим выбирается по
%% умолчанию.
\newif\if@trim\@trimtrue
\DeclareOption {trim} {\@trimtrue}

%%
%% * **`trimlater`** Размер страницы электронной копии издания
%% равняется размеру *необрезанного* книжного блока выбранного
%% формата. Для включения обрезных меток используйте макрос
%% `\showtrimson`.
\DeclareOption {trimlater} {\@trimfalse}

%%
%% * **`paperback`** Клеевое скрепление блока. Включает режим
%% четырёхсторонней обрезки книжного блока для разделения тетрадей на
%% отдельные страницы.
\newif\if@paperback\@paperbackfalse
\DeclareOption {paperback} {%
  \@paperbacktrue%
}

%%
%% * **`stab`** Скрепление блока втачку. Размер внутреннего поля
%% увеличивается (по умолчанию на 10 мм) для того, чтобы
%% скомпенсировать плохую раскрываемость книги при скреплении страниц
%% блока втачку.
\newif\if@stabbinding\@stabbindingfalse
\DeclareOption {stab} {\@stabbindingtrue}

%%
%% * **`twoside`** Режим двусторонней печати. Режим предназначе для
%% последующей брощюровки: размер левого и правого полей на чётных
%% и нечётных страницах различается. По умолчанию включён.
\newif\if@pltzdt@twoside\@pltzdt@twosidefalse
\DeclareOption {twoside} {%
  \@pltzdt@twosidetrue%
  \PassOptionsToClass {twoside} {memoir}%
}

%%
%% * **`openany`** Позволяет начинать новую главу как на нечётных (по
%% умолчанию), так и на *чётных*, т.е. левых страницах издания.
\DeclareOption {openany} {%
  \PassOptionsToClass {openany} {memoir}%
}

%%
%% * **`oneside`** Режим односторонней печати. Размер левого и правого
%% полей на всех страницах одинаков.
\DeclareOption {oneside} {%
  \@pltzdt@twosidefalse%
  \PassOptionsToClass {oneside} {memoir}%
}

%%
%% * **`onecolumn`** Одна колонка на полосе. Используется по умолчанию
%% для книжных изданий (опция `book`).
\DeclareOption {onecolumn} {%
  \PassOptionsToClass {onecolumn} {memoir}%
}

%%
%% * **`twocolumn`** Двухколонный набор.
\DeclareOption {twocolumn} {%
  % TODO: set column spread
  \PassOptionsToClass {twocolumn} {memoir}%
}

%%
%% * **`headerson`** Включает верхние колонтитулы. Используется по
%% умолчанию для журнальных изданий (опция `journal`).
\newif\if@headerson\@headersonfalse
\DeclareOption {headerson} {\@headersontrue}

%%
%% * **`headersoff`** Выключает верхние колонтитулы. Используется по
%% умолчанию для книжных изданий и изданий с однородной структурой
%% (опции `book` и `plain`).
\DeclareOption {headersoff} {\@headersonfalse}


%%
%% ### Избирательная настройка структуры текста

%%
%% * **`inlinenotes`** Включение примечаний в основной текст
%% (заключаются в круглые скобки).
\newif\if@inlinenotes\@inlinenotesfalse
\DeclareOption {inlinenotes}
  {%
    \@inlinenotestrue%
  }

%%
%% * **`footnotes`** Оформление примечаний в виде сносок внизу
%% страницы.
\DeclareOption {footnotes}
  {%
    \@inlinenotesfalse%
  }

%%
%% * **`inlinebib`** Включение ссылок на литературу в основной текст
%% (заключаются в круглые скобки).
\newif\if@inlinebib\@inlinebibfalse
\DeclareOption {inlinebib}
  {%
    \@inlinebibtrue%
  }

%%
%% * **`footbib`** Оформление ссылок на литературу в виде сносок внизу
%% страницы.
\DeclareOption {footbib}
  {%
    \@inlinebibfalse%
  }

%%
%% * **`perpage`** Режим постраничной нумерации сносок. Для режима
%% двусторонней печати (с брощюровкой), нумерация возобновляется с
%% левой страницы разворота.
\newif\if@perpage\@perpagefalse
\DeclareOption {perpage}
  {%
    \@perpagetrue%
  }

%%
%% * **`noperpage`** Режим сквозной нумерации сносок.
\DeclareOption {noperpage}
  {%
    \@perpagefalse%
  }

%%
%% * **`draft`** Режим черновика. В режиме черновика на полях издания
%% ставятся пометки об ошибках набора, а также выводятся *рабочие
%% заметки* (см. `\notice`, см. также `noticeoff`).
\newif\if@draftmode\@draftmodefalse
\DeclareOption {draft}
  {%
    \@draftmodetrue%
  }

%%
%% * **`noticeoff`** Отдельная опция, позволяющая отключить
%% печать рабочих заметок в режиме черновика.
\newif\if@noticeon\@noticeontrue
\DeclareOption {noticeoff}
  {%
    \@noticeonfalse%
  }

%%
%% * **`noibid`** Отключает подстановку меток <<Там же>> вместо
%% повторяющихся ссылок на литературу:
\newif\if@noibid\@noibidfalse
\DeclareOption {noibid}
  {%
    \@noibidtrue%
  }

%%
%% * **`citemore`** Включает расширенный режим цитирования. В этом
%% режиме указатель на источник *при первом цитировании* включает в
%% себя дополнительные данные, такие, как год издания.
\newif\if@citemore\@citemorefalse
\DeclareOption {citemore} {\@citemoretrue}

%%
%% * **`sectoc`** Включает режим, в котором номера страниц
%% в оглавлении указываются только для разделов, а названия
%% глав набираются по центру.
\newif\if@sectoc\@sectocfalse
\DeclareOption {sectoc} {\@sectoctrue}

%%
%% ### Прочие опции
%%
%% В режиме по умолчанию, попытка указать не определённую явно в
%% пакете опцию приводит к ошибке. Это сделано намеренно, для того,
%% чтобы избежать неоднозначных ситуаций. Однако, все опции, указанные
%% после специальной опции `forwardopts`, будут переданы базовому
%% классу `memoir` как есть, без лишних вопросов.
\newif\if@strictopts\@strictoptstrue
\DeclareOption{forwardopts}
  {%
  \@strictoptsfalse%
  }
\DeclareOption*
  {%
    \if@strictopts%
      \ClassError{politizdat}%
        {Unknown option: \CurrentOption}%
        {%
          This class is currently using the strict option processing
          model.\MessageBreak
          To pass all unknown options to the base class use
          'forwardopts' option
        }%
    \else%
      \PassOptionsToClass{\CurrentOption}{memoir}%
    \fi%
  }

%%
%% ### Параметры настройки по умолчанию
%%
%% Набор опций по умолчанию: `book`, `twoside`, `trim`. Стандартное
%% книжное издание (формата 60x90/16, с нормальным размером полосы и
%% базовым размером шрифта 10 пт), предназначенное для двусторонней
%% печати (с брощюровкой). Размер страницы электронной копии издания
%% соответствует формату уже обрезанного книжного блока.

\global\def\pltzdt@linespread{1.0}%
\newcommand{\setlinespread}[1]
  {%
    \global\def\pltzdt@linespread{#1}%
  }

% Применение опций по умолчанию
\ExecuteOptions {book,twoside,trim}


% Обработка опций
\ProcessOptions\relax


% Загрузка базового класса
\if@draftmode%
  % Устанавливается режим черновика
  \PassOptionsToClass{draft}{memoir}%
\fi
\LoadClass {memoir}


% Загрузка вспомогательных пакетов
\RequirePackage{xpunctuate}
\RequirePackage {xparse}
\RequirePackage{afterpackage}
\RequirePackage{etoolbox}
\RequirePackage{ifthen}

% Вспомогательная команда-условный оператор. Условие выполняется,
% если аргумент задан пустым, либо вообще не задан.
\newcommand{\IfEmpty}[3]{%
  \ifthenelse{\equal{\IfNoValueTF{#1}{}{#1}}{}}{#2}{#3}%
}

% Загрузка пакета biblatex
\global\def\pltzdt@biblatexopts{}
\global\def\pltzdt@biblatexauxopts{}
\NewDocumentCommand \initbiblatex { o }
{%
  \@ifpackageloaded{csquotes}{}{\usepackage{csquotes}}%
  %
  \@ifpackageloaded{biblatex}{}{%
    \if@noibid%
      \global\def\pltzdt@biblatexopts{style=verbose}%
    \else%
      \global\def\pltzdt@biblatexopts{style=verbose-ibid}%
    \fi%
    \IfEmpty{#1}{}{%
      \global\def\pltzdt@biblatexauxopts{,#1}%
    }%
    \usepackage[ \pltzdt@biblatexopts, bibstyle=numeric,%
                 hyperref=true, backref=true,%
                 sorting=nty, defernumbers=true,%
                 \pltzdt@biblatexauxopts ]
               {biblatex}%
  }%
}

% TODO: ibid -- reset on \chapter (option?)

\newif\if@switchfont\@switchfonttrue
\AtEndPreamble
{%
  \@ifpackageloaded{csquotes}{}{\usepackage{csquotes}}%
  \@ifpackageloaded{polyglossia}{\@switchfontfalse}{}%
  % Тире
  \ifdefined\cyrdash\let\cyrdash\textemdash\fi%
}

\RenewDocumentCommand \bibliography { o m }
{%
  \initbiblatex[#1]%
  \bibliography{#2}%
}

%%
%% ### Точная настройка параметров книжного блока и страницы

%%
%% В том случае, когда ни один из готовых форматов книжного блока
%% не подходит, пакет предоставляет инструменты для определения и
%% использования пользовательских форматов --- это команды
%% `\definebookformat` и `\usebookformat`.
%%
%% **`\definebookformat`**`{` *имя* `}{` *W* `}[` *dW* `]{` *H* `}
%% [` *dH* `]{` *w* `}{` *h* `}`
%% Определяет формат книжного блока с именем *имя*, шириной печатного
%% листа *W* и высотой *H*. Размер блока после фальцовки будет
%% равняться *W/dW* x *H/dH*. В том случае, если фальцовка по ширине
%% или высоте не предполагается, соответствующий аргумент в квадратных
%% скобках может быть опущен --- количество делений листа будет
%% равняться единице. Последние два аргумента команды определяют
%% нормальную ширину и высоту полосы для данного формата. Например,
%% конструкция
%%
%%     \definebookformat{60x84/16}
%%                      {60cm}[4]{84cm}[4]
%%                      {6.5\quadrat}{11.5\quadrat}
%%
%% определяет формат с именем `60x84/16`, соответствующими размерами
%% листа и количеством делений, с нормальным размером полосы 6,5 x
%% 11,5 типографских квадратов (1 кв. = 48 пт.).

% Определение команды \definebookformat
\NewDocumentCommand \definebookformat { m m o m o m m }
  {%
    % Ширина блока
    \expandafter%
      \newlength\csname pltzdt@stockwidth@#1\endcsname%
    \expandafter%
      \setlength\csname pltzdt@stockwidth@#1\endcsname {#2}%
    \IfEmpty{#3}{}
      {%
        \expandafter%
          \divide \csname pltzdt@stockwidth@#1\endcsname by #3%
      }%
    %
    % Высота блока
    \expandafter%
      \newlength\csname pltzdt@stockheight@#1\endcsname%
    \expandafter%
      \setlength\csname pltzdt@stockheight@#1\endcsname {#4}%
    \IfEmpty{#5}{}
      {%
        \expandafter%
          \divide \csname pltzdt@stockheight@#1\endcsname by #5%
      }%
    %
    % Нормальный размер полосы
    \expandafter%
      \newlength\csname pltzdt@blockwidth@#1\endcsname%
    \expandafter%
      \setlength\csname pltzdt@blockwidth@#1\endcsname {#6}%
    \expandafter%
      \newlength\csname pltzdt@blockheight@#1\endcsname%
    \expandafter%
      \setlength\csname pltzdt@blockheight@#1\endcsname {#7}%
  }

% Определение стандартных форматов книг

% Типографский квадрат (48 пт):
\newlength{\quadrat}
\setlength{\quadrat}{48.0pt}

% 84x108/8 ---  270 x 420 мм -> 265 x 410 мм (1.54716)
\definebookformat {84x108/8}
                  {1080mm}[4]{840mm}[2]
                  {12.75\quadrat}{20.50\quadrat}

% 60x84/8 ---   210 x 300 мм -> 205 x 290 мм (1.41463)
\definebookformat {60x84/8}
                  {840mm}[4]{600mm}[2]
                  {9.50\quadrat}{13.75\quadrat}

% 70x108/16 --- 175 x 270 мм -> 170 x 260 мм (1.52941)
\definebookformat {70x108/16}
                  {700mm}[4]{1080mm}[4]
                  {7.75\quadrat}{12.25\quadrat}

% 60x90/16 ---  150 x 225 мм -> 145 x 215 мм (1.48275)
\definebookformat {60x90/16}
                  {600mm}[4]{900mm}[4]
                  {6.7\quadrat}{10.50\quadrat}

% 84x108/32 --- 135 x 210 мм -> 130 x 200 мм (1.53846)
\definebookformat {84x108/32}
                  {1080mm}[8]{840mm}[4]
                  {5.75\quadrat}{9.50\quadrat}

% 75x90/32 ---  112.5 x 187 мм -> 107.5 x 177 мм (1.64651)
\definebookformat {75x90/32}
                  {900mm}[8]{750mm}[4]
                  {4.50\quadrat}{8.25\quadrat}

% 70x90/32 ---  112.5 x 175 мм -> 107.5 x 165 мм (1.53488)
\definebookformat {70x90/32}
                  {900mm}[8]{700mm}[4]
                  {4.50\quadrat}{7.50\quadrat}

% A4+ ---   215 x 307 мм -> 210 x 297 мм (1.41428)
\definebookformat {a4}
                  {215mm}{307mm}
                  {10.50\quadrat}{13.75\quadrat}

% A5+ ---   153.5 x 220 мм -> 148.5 x 210 мм (1.41414)
\definebookformat {a5}
                  {153.5mm}{220mm}
                  {6.50\quadrat}{10.25\quadrat}

% 6in (ebook) --- 95 x 120 мм -> 90 x 115 мм (1.27777)
\definebookformat {6in}
                  {95mm}{125mm}
                  {80mm}{90mm}

%%
%% Таким образом можно определить один или несколько форматов с
%% разными именами. Но формат не будет установлен для издания до тех
%% пор, пока он не будет явно выбран. Выбрать любой из определённых
%% ранее форматов и установить его для данного издания позволяет
%% команда `\usebookformat`.
%% 
%% **`\usebookformat`**`{` *имя* `}[` *trim* `][` *trimedge* `]
%% {` *adjW* `}{` *adjH* `}`
%% Устанавливает для издания формат с именем *имя*. В качестве
%% дополнительного, необязательного аргумента может быть указана
%% величина *trim*, на которую сокращается книжный блок при его
%% обрезке с трёх или со всех четырёх сторон, в зависимости от типа
%% обрезки (см. опцию `paperback`). Если величина обрезки блока с
%% переднего края (а в случае четырёхсторонней обрезки также со
%% стороны корешка) будет отличаться от величины обрезки снизу и
%% сверху, то этот размер может быть передан в качестве третьего
%% аргумента *trimedge*.
%%
%% Последние из двух указанных аргументов команды также являются
%% необязательными. Они определяют величины, на которые должна быть
%% увеличена или сокращена ширина и высота полосы по сравнению с
%% нормальными её размерами, определёнными командой
%% `\definebookformat`. По умолчанию, в режиме простых страниц без
%% колонтитулов, обе эти величины равны нулю. Однако если верхние
%% колонтилулы включены (опция `headerson`), то высота полосы
%% по умолчанию сокращается на 0,6 кв.

% Вспомогательные переменные для хранения размеров полей
\newlength{\trimbottom}
\newlength{\trimspine}

% Определение команды \usebookformat
\NewDocumentCommand \usebookformat { m o o g g }
  {%
    % Проверка на наличие определения формата
    \expandafter%
      \ifcsname pltzdt@stockheight@#1\endcsname%
      \else%
        % Ошибка компиляции в том случае, если формат не определён
        \ClassError{politizdat}{Book format #1 is not defined}
          {%
            You can define a non-statdard format with
            \protect\definebookformat\space.\MessageBreak
            If the format is standard then it is a BUG
          }%
      \fi%
    % Установка размеров книжного блока в соответствии с форматом
    \setstocksize{\csname pltzdt@stockheight@#1\endcsname}
                 {\csname pltzdt@stockwidth@#1\endcsname}%
    %
    % Вычисление величины обрезки
    \IfEmpty{#2}
      {%
        \setlength{\trimtop}{0.0mm}%
        \IfEmpty{#3}
          {%
            \setlength{\trimedge}{0.0mm}%
          }
          {%
            \setlength{\trimedge}{#3}%
          }%
      }
      {%
        \setlength{\trimtop}{#2}%
        \IfEmpty{#3}
          {%
            \setlength{\trimedge}{#2}%
          }
          {%
            \setlength{\trimedge}{#3}%
          }%
      }%
    %
    \if@trim%
      % <<Электронная>> обрезка
      \setlength{\trimbottom}{\pltzdt@ultrimratio\trimtop}%
      \setlength{\trimspine}{\pltzdt@lrtrimratio\trimedge}%
      \addtolength{\stockheight}{-1.0\trimtop}%
      \addtolength{\stockheight}{-1.0\trimbottom}%
      \addtolength{\stockwidth}{-1.0\trimedge}%
      \addtolength{\stockwidth}{-1.0\trimspine}%
      \setstocksize{\stockheight}{\stockwidth}%
      \settrimmedsize{\stockheight}{\stockwidth}{*}%
      \settrims{0.0mm}{0.0mm}%
      \setlength{\trimbottom}{0.0mm}%
      \setlength{\trimspine}{0.0mm}%
    \else%
      % Настоящая обрезка будет выполнена позднее
      \setlength{\paperheight}{\stockheight}%
      \addtolength{\paperheight}{-1.0\trimtop}%
      \addtolength{\paperheight}{-1.0\trimbottom}%
      \setlength{\paperwidth}{\stockwidth}%
      \addtolength{\paperwidth}{-1.0\trimedge}%
      \addtolength{\paperwidth}{-1.0\trimspine}%
      \settrimmedsize{\paperheight}{\paperwidth}{*}%
      \settrims{\trimtop}{\trimedge}%
    \fi%
    %
    % Установка размеров полосы в соответствии с форматом
    \expandafter%
      \settypeblocksize{\csname pltzdt@blockheight@#1\endcsname}
                       {\csname pltzdt@blockwidth@#1\endcsname}
                       {*}%
    %
    % Корректировка размеров полосы
    \IfEmpty{#4}
      {%
        \if@headerson%
          \addtolength{\textheight}{-0.6\quadrat}%
        \fi%
      }
      {%
        % Сокращение высоты полосы
        \addtolength{\textheight}{#4}%
      }%
    \IfEmpty{#5}
      {}
      {%
        % Сокращение ширины полосы
        \addtolength{\textwidth}{#5}%
      }%
    \settypeblocksize{\textheight}{\textwidth}{*}%
    %
    \if@stabbinding%
      % Дополнительный корешковый отступ при скреплении блока втачку
      \setbinding{\pltzdt@staboffset}%
    \else%
      % Без дополнительного отступа
      \setbinding{0.0mm}%
    \fi%
    %
    % Установка соотношения между размерами полей
    \setlrmargins{*}{*}{\pltzdt@lrmarginratio}%
    \setulmargins{*}{*}{\pltzdt@ulmarginratio}%
    %
    % Настройка положения и размера колонтитулов
    \if@headerson%
      \setheaderspaces{*}{5mm}{*}%
    \fi%
    %
    % Применение разметки
    \checkandfixthelayout[lines]%
  }

%%
%% Указанные в списке базовых опций стандартные форматы книжных
%% блоков также могут быть использованы в команде `\usebookformat`.
%% Данная команда отменяет действие соответствующих базовых опций.

%%
%% Если требуется ещё более точная настройка параметров книжного
%% блока и страницы, то для этой цели можно воспользоваться описанными
%% далее командами. **Внимание:** все эти команды должны быть записаны
%% *перед* командой `\usebookformat` и *не оказывают* влияния на
%% параметры книги, которые были выбраны с помощью базовых опций.

%%
%% **`\setmarginratio`**`{` *spineedge* `}{` *topbottom* `}`
%% Устанавливает соотношение между полями страницы. Множитель
%% *spineegde* определяет насколько внешнее (переднее) поле будет шире
%% корешкового. Множитель *topbottom* определяет аналогичное
%% соотношение для верхнего и нижнего полей. По умолчанию оба
%% множителя равны *1.6*. Следует помнить, что
%% для переднего и корешкового поля эта разница не столь существенна,
%% как для верхнего и нижнего полей: внешнее (переднее) поле каждой из
%% страниц будет при таком соотношении лишь немного шире, чем внутреннее,
%% образуемое *парой* корешковых полей (с опцией `twoside`).
\newcommand{\pltzdt@lrmarginratio}{1.6}
\newcommand{\pltzdt@ulmarginratio}{1.6}
\NewDocumentCommand \setmarginratio { m m }
  {%
    \renewcommand{\pltzdt@lrmarginratio}{#1}%
    \renewcommand{\pltzdt@ulmarginratio}{#2}%
  }

%% Однако, если включен режим страниц с верхними колонтитулами,
%% то верхнее и нижнее поля будут по умолчанию *одинаковыми*.
\if@headerson%
  \if@pltzdt@twoside%
    \setmarginratio{1.6}{1.08}% FIXME
  \else%
    \setmarginratio{1.0}{1.08}% FIXME
  \fi%
\else%
  \if@pltzdt@twoside%
    \setmarginratio{1.6}{1.6}%
  \else%
    \setmarginratio{1.0}{1.6}%
  \fi%
\fi%

%%
%% **`\settrimratio`**`{` *edgespine* `}{` *topbottom* `}`
%% Устанавливает соотношение между величинами обрезки книжного
%% блока. Множитель *edgespine* определяет соотношение между
%% величиной, на которую блок обрезается с переднего края и
%% величиной, на которую блок обрезается со стороны корешка. По
%% умолчанию, в режиме трёхсторонней обрезки, данный множитель равен
%% *0*, а в режиме четырёхсторонней обрезки --- *1.0*. Множитель
%% *topbottom* определяет соотношение между величинами обрезки блока
%% сверху и снизу, и по умолчанию равняется *1.0*. Данная команда
%% *отменяет действие* опции `paperback`.
\newcommand{\pltzdt@lrtrimratio}{0.0}
\newcommand{\pltzdt@ultrimratio}{1.0}
\NewDocumentCommand \settrimratio { m m }
  {%
    \renewcommand{\pltzdt@lrtrimratio}{#1}%
    \renewcommand{\pltzdt@ultrimratio}{#2}%
  }
\if@paperback%
  \settrimratio{1.0}{1.0}%
\else%
  \settrimratio{0.0}{1.0}%
\fi

%%
%% **`\setstaboffset`**`{` *offs* `}` Устанавливает величину
%% дополнительного корешкового отступа, который будет добавлен к
%% корешковому полю, если выбран режим скрепления блока втачку (опция
%% `stab`).
\newlength{\pltzdt@staboffset}
\NewDocumentCommand \setstaboffset { m }
  {%
    \setlength{\pltzdt@staboffset}{#1}%
  }
\setstaboffset{10.0mm}


% Установка формата издания в соответствии с выбранной опцией
\newlength{\pltzdt@defaulttrim}
\setlength{\pltzdt@defaulttrim}{5.0mm}
\newlength{\pltzdt@defaultadj}
\setlength{\pltzdt@defaultadj}{0.25\quadrat}

\newcommand{\applylayout}{%
  \if@econombs%
    % Режим экономной полосы
    \usebookformat{\pltzdt@bookformat}[1.0\pltzdt@defaulttrim]%
                  {1.0\pltzdt@defaultadj}{1.0\pltzdt@defaultadj}%
  \else%
    \if@imprvbs%
      % Режим улучшенной полосы
      \usebookformat{\pltzdt@bookformat}[1.0\pltzdt@defaulttrim]%
                    {-1.0\pltzdt@defaultadj}{-1.0\pltzdt@defaultadj}%
    \else%
      % Режим полосы нормального размера
      \usebookformat{\pltzdt@bookformat}[1.0\pltzdt@defaulttrim]%
    \fi%
  \fi%
}

\raggedbottom
\applylayout

% Настройка стиля оформления страниц

\AtBeginDocument{%
  \pagenumbering{arabic}
  \nouppercaseheads
}

\makeevenfoot{plain}{\small\thepage}{}{}
\makeoddfoot{plain}{}{}{\small\thepage}

\makeevenhead{headings}{\footnotesize\textit{\thepage}}
                       {\footnotesize\textit{\leftmark}}{}

\makeoddhead{headings}{}{\footnotesize\textit{\rightmark}}
                        {\footnotesize\textit{\thepage}}
\makeevenfoot{headings}{}{}{}
\makeoddfoot{headings}{}{}{}
\makeheadrule{headings}{\textwidth}{\normalrulethickness}

\makeevenhead{myheadings}{\footnotesize\textit{\thepage}}
                         {\footnotesize\textit{\leftmark}}{}
\makeoddhead{myheadings}{}{\footnotesize\textit{\rightmark}}
                          {\footnotesize\textit{\thepage}}
\makeevenfoot{myheadings}{}{}{}
\makeoddfoot{myheadings}{}{}{}
\makeheadrule{myheadings}{\textwidth}{\normalrulethickness}

\makepagestyle{plainruled}
\makeevenhead{plainruled}{\footnotesize\textit{\thepage}}{}{}
\makeoddhead{plainruled}{}{}{\footnotesize\textit{\thepage}}
\makeheadrule{plainruled}{\textwidth}{\normalrulethickness}

%%
%% **`\chapterauthor`**`{` *Имя автора главы* `}` Определяет
%% имя автора, которое выводится перед названием следующей главы
%% и в оглавлении.
%%
%% **`\nochapterauthor`**` Отменяет действие команды `\chapterauthor`.

\def\thechapterauthor{}
\newif\if@chapterauthorset\@chapterauthorsetfalse
\newcommand{\chapterauthor}[1]{%
  \global\def\thechapterauthor{#1}%
  \@chapterauthorsettrue
}
\newcommand{\nochapterauthor}{%
  \@chapterauthorsetfalse
  \global\def\thechapterauthor{}%
}
\newcommand{\printchapterauthor}{%
  \if@chapterauthorset%
    \begin{flushleft}%
      {\Large\textit{\thechapterauthor}\vspace*{-\baselineskip}}
    \end{flushleft}%
  \fi%
}

%% **`\setprechapter`**`{` *содержимое* `}` Определяет материал,
%% который будет выведен перед названием следующей главы.
%%
%% **`\setprechapter*`**`{` *содержимое* `}` Аналогична варианту
%% без звёздочки, однако специально отключает колонтитулы.
%%
%% **`\clearprechapter`** Отменяет действие команды `\setprechapter`.

\def\@prechapter{}
\newif\if@prechapterset\@prechaptersetfalse
\def\normalmainchapterpagestyle{%
  \if@headerson%
    \thispagestyle{empty}%
  \else%
    \thispagestyle{chapter}%
  \fi%
}
\def\normalotherchapterpagestyle{%
  \if@headerson%
    \thispagestyle{plainruled}%
  \else%
    \thispagestyle{chapter}%
  \fi%
}
\def\otherchapterpagestyle{\normalotherchapterpagestyle}
\def\mainchapterpagestyle{\normalmainchapterpagestyle}
\NewDocumentCommand \setprechapter { s m }
  {%
    \global\def\@prechapter{#2}%
    \@prechaptersettrue%
    \IfBooleanTF{#1}
      {%
        \global\def\otherchapterpagestyle{\thispagestyle{empty}}%
        \global\def\mainchapterpagestyle{\thispagestyle{empty}}%
      }
      {%
        \global\def\otherchapterpagestyle{\normalotherchapterpagestyle}%
        \global\def\mainchapterpagestyle{\normalmainchapterpagestyle}%
      }
  }
\newcommand{\clearprechapter}{%
  \@prechaptersetfalse%
  \global\def\otherchapterpagestyle{\normalotherchapterpagestyle}%
  \global\def\mainchapterpagestyle{\normalmainchapterpagestyle}%
  \global\def\@prechapter{}%
}
\newcommand{\printprechapter}{%
  \if@prechapterset%
    \@prechapter\par%
  \fi%
  \printchapterauthor%
}

\global\def\pltzdt@chapaddon{}%
\makechapterstyle{politizdat}{%
  \headstyles{politizdat}%
  \def\thechapter{\Roman{chapter}}%
  \def\chapterheadstart{%
    \printprechapter%
    \linespread{1.0}%
  }%
  \if@journal%
    \def\printchaptername{}%
    \def\chapternamenum{}%
    \def\printchapternum{}%
    \def\afterchapternum{}%
    \def\chaptermark##1{%
      \markboth{##1}{##1}%
    }%
  \else%
    \def\printchaptername{\centering\textit{\large\@chapapp}}%
    \def\chapternamenum{\space}%
    \def\printchapternum{\textit{\large\thechapter}}%
    \def\afterchapternum{\par\nobreak\vspace{0.25em}}%
    \def\chaptermark##1{%
      \markboth{%
        \if@mainmatter%
          \@chapapp\ \thechapter. \ %
        \fi
        ##1}{%
        \if@mainmatter%
          \@chapapp\ \thechapter. \ %
        \fi
        ##1}%
    }%
  \fi%
  \def\printchapternonum{}%
  \def\printchaptertitle##1{%
    \centering\normalfont\Large%
    \protect\bfseries%
    \protect\MakeTextUppercase{##1}%
    \pltzdt@chapaddon%
  }%
  \def\afterchaptertitle{%
    \par\nobreak\vskip%
    \afterchapskip%
    \linespread{\pltzdt@linespread}%
    \clearprechapter%
  }%
}

\let\pltzdt@memchapter\chapter
\newcommand{\dontaddcontentsline}[3]{}
\NewDocumentCommand \pltzdt@chaptercommon { s o o m g }
  {%
      \let\wasaddcontentsline\addcontentsline
      \let\addcontentsline\dontaddcontentsline%
      \IfEmpty{#5}
        {%
          \IfEmpty{#2}
            {%
              \IfEmpty{#3}
                {%
                  \IfBooleanTF{#1}
                  {\pltzdt@memchapter*{#4}}
                  {\pltzdt@memchapter{#4}}%
                }
                {%
                  \IfBooleanTF{#1}
                  {\pltzdt@memchapter*[#3]{#4}}
                  {\pltzdt@memchapter[#4][#3]{#4}}%
                }%
            }
            {%
              \IfEmpty{#3}
                {%
                  \IfBooleanTF{#1}
                  {\pltzdt@memchapter*[#2]{#4}}
                  {\pltzdt@memchapter[#2]{#4}}%
                }
                {%
                  \IfBooleanTF{#1}
                  {\pltzdt@memchapter*[#2][#3]{#4}}
                  {\pltzdt@memchapter[#2][#3]{#4}}%
                }%
            }%
        }
        {%
          \global\def\pltzdt@chapaddon{%
            \par\nobreak%
            \vspace{0.25em}%
            #5%
          }%
          \IfEmpty{#2}
            {%
              \IfEmpty{#3}
                {%
                  \IfBooleanTF{#1}
                  {\pltzdt@memchapter*{#4}}
                  {\pltzdt@memchapter{#4}}%
                }
                {%
                  \IfBooleanTF{#1}
                  {\pltzdt@memchapter*[#3]{#4}}
                  {\pltzdt@memchapter[#4][#3]{#4}}%
                }%
            }
            {%
              \IfEmpty{#3}
                {%
                  \IfBooleanTF{#1}
                  {\pltzdt@memchapter*[#2]{#4}}
                  {\pltzdt@memchapter[#2]{#4}}%
                }
                {%
                  \IfBooleanTF{#1}
                  {\pltzdt@memchapter*[#2][#3]{#4}}
                  {\pltzdt@memchapter[#2][#3]{#4}}%
                }%
            }%
          \global\def\pltzdt@chapaddon{}%
        }%
    \let\addcontentsline\wasaddcontentsline
    \mainchapterpagestyle%
    \ifdefined\citereset\citereset\fi%
  }

\NewDocumentCommand \mainchapter { s o o m g }
  {%
    \IfBooleanTF{#1}
      {\pltzdt@chaptercommon*[#2][#3]{#4}{#5}}
      {\pltzdt@chaptercommon[#2][#3]{#4}{#5}}%
    \IfBooleanF{#1}
      {%
        \if@sectoc%
        \addtocontents{toc}
          {%
            \protect\normalfont%
            \protect\vspace{1.5em}%
            \protect\centering%
          }%
        \if@journal%
          \if@chapterauthorset%
            \addtocontents{toc}
              {%
                \protect\textit{\thechapterauthor}%
                \protect\par\nobreak%
                \protect\vspace{0.25em}%
              }%
          \fi%
        \else%
          \addtocontents{toc}
            {%
              \protect\textit{\@chapapp\space\thechapter}%
              \protect\par\nobreak%
              \protect\vspace{0.25em}%
            }%
          \if@chapterauthorset%
            \addtocontents{toc}
              {%
                \protect\textit{(\thechapterauthor)}%
                \protect\vspace{0.25em}%
              }%
          \fi%
        \fi%
        \addtocontents{toc}
          {%  
            \protect\bfseries%
          }%
        \IfEmpty{#5}
          {%
            \addtocontents{toc}
              {%
                {\protect\small\protect\MakeTextUppercase{#4}}%
              }%
          }
          {%
            \addtocontents{toc}
              {%
                {\protect\small\protect\MakeTextUppercase{#4}}%
                \protect\par\nobreak%
                \protect\vspace{0.25em}%
                #5%
              }%
          }%
        \addtocontents{toc}
          {%      
            \protect\vspace{0.5em}%
          }
        \else% sectoc
        \IfEmpty{#5}
          {%
            \if@chapterauthorset%
              \addcontentsline{toc}{chapter}
                {%
                  {\protect\normalfont\protect\textit{\thechapterauthor}\unskip{}.~---}\space{}#4%
                }%
            \else%
              \addcontentsline{toc}{chapter}{#4}%
            \fi%
          }
          {%
            \if@chapterauthorset%
              \addcontentsline{toc}{chapter}
                {%
                  {\protect\normalfont\protect\textit{\thechapterauthor}\unskip{}.~---}\space{}#4\space{}#5%
                }%
            \else%
              \addcontentsline{toc}{chapter}{#4\space{}#5}%
            \fi%
          }%
        \fi% sectoc
      }%
      \nochapterauthor%
  }%

\NewDocumentCommand \frontchapter { s o o m g }
  {%
    \IfBooleanTF{#1}
      {\pltzdt@chaptercommon*[#2][#3]{#4}{#5}}
      {\pltzdt@chaptercommon[#2][#3]{#4}{#5}}%
    \IfBooleanF{#1}
      {%
        \IfEmpty{#5}
          {%
            \addcontentsline{toc}{chapter}{#4}%
          }
          {%
            \addcontentsline{toc}{chapter}{#4\space#5}%
          }
      }%
    \otherchapterpagestyle%
    \nochapterauthor%
  }%

\NewDocumentCommand \backchapter { s o o m g }
  {%
    \IfBooleanTF{#1}
      {\frontchapter*[#2][#3]{#4}{#5}}
      {\frontchapter[#2][#3]{#4}{#5}}%
  }

\renewcommand{\aftertoctitle}{%
  \otherchapterpagestyle%
  \afterchaptertitle%
}
  
\let\pltzdt@memfront\frontmatter
\newif\if@frontnormal\@frontnormaltrue
\RenewDocumentCommand \frontmatter { s }
  {%
    \IfBooleanTF{#1}%
      {\pltzdt@memfront*}%
      {%
        \pltzdt@memfront%
        \pagenumbering{Roman}%
        \@frontnormalfalse%
      }% 
    \chapterstyle{politizdat}%
    \def\chapterheadstart{\printprechapter\vspace*{\beforechapskip}}%
    \renewcommand{\chapter}{\frontchapter}%
  }

\let\pltzdt@memmain\mainmatter
\RenewDocumentCommand \mainmatter { s }  
  {%
    \IfBooleanTF{#1}%
      {\pltzdt@memmain*}%
      {%
        \if@frontnormal%
          \pltzdt@memmain*%
        \else%
          \pltzdt@memmain%
        \fi%
      }%
    \chapterstyle{politizdat}%
    \if@journal%
      \def\chapterheadstart{\printprechapter\vspace*{\beforechapskip}}%
      \renewcommand{\chapter}{\mainchapter}%
    \else%
      \renewcommand{\chapter}{\mainchapter}%
    \fi%
  }
  
\let\pltzdt@memback\backmatter
\renewcommand{\backmatter}{%
  \pltzdt@memback%
  \chapterstyle{politizdat}%
  \def\chapterheadstart{\printprechapter\vspace*{\beforechapskip}}%
  \renewcommand{\chapter}{\backchapter}%
}

\setlength{\parindent}{1.1em}
\linespread{\pltzdt@linespread}%
\setlength{\lineskiplimit}{-\maxdimen}
\RenewDocumentCommand \@makefnmark {}
  {%
    \hbox{\small\@textsuperscript {\normalfont \@thefnmark}}%
  }

\AtBeginDocument{%
  \footmarkstyle{\textsuperscript{#1}\space}
  \indentafterchapter
  \mainmatter
  \fussy

  \clubpenalty=10000
  \widowpenalty=10000
  \interfootnotelinepenalty=10000
  \brokenpenalty=0
  \linenottooshort[4em]
}

\renewcommand{\tocheadstart}{%
  \cleardoublepage%
  \chapterheadstart%
}

\newcommand{\sectionsecnumformat}{\thesection.\hspace{0.5em}}%
\newcommand{\subsectionsecnumformat}{\thesubsection)\hspace{0.5em}}%
\setsecnumformat{\csname #1secnumformat\endcsname}%

\makeheadstyles{politizdat}{%
  \headstyles{default}%
  \renewcommand*{\thesection}{\arabic{section}}%
  \setsecheadstyle{\flushleft\large\bfseries}%
  \renewcommand{\sectionsecnumformat}{\thesection.\hspace{0.5em}}%
  \renewcommand*{\thesubsection}{\asbuk{subsection}}%
  \renewcommand{\subsectionsecnumformat}{\thesubsection)\hspace{0.5em}}%
  \setsubsecheadstyle{\sloppy\centering\bfseries}%
  \setsecnumdepth{subsection}%
}

\makeheadstyles{politizdat@anonsec}{%
  \headstyles{default}%
  \renewcommand*{\thesection}{\Roman{section}}%
  \setsecheadstyle{\centering\large\bfseries}%
  \renewcommand{\sectionsecnumformat}{\thesection}%
  \renewcommand*{\thesubsection}{}%
  \renewcommand{\subsectionsecnumformat}{}%
  \setsubsecheadstyle{\sloppy\centering\bfseries}%
  \setsecnumdepth{subsection}%
}

\headstyles{politizdat}

%%
%% **`\nextsection`**  Начинает новый раздел (section) без названия,
%% порядковый номер которого набирается заглавной римской цифрой.
\newcommand{\nextsection}{%
  \def\tmp@rightmark{\rightmark}%
  \headstyles{politizdat@anonsec}%
  \section{}%
  \markright{\tmp@rightmark}%
}

\let\pltzdt@memsection\section
\RenewDocumentCommand \section { s o o m }
  {%
    \IfBooleanTF{#1}
      {%
        \IfEmpty{#3}
          {%
            \pltzdt@memsection*{#4}%
          }
          {%
            \pltzdt@memsection*[#3]{#4}%
          }%
      }
      {%
        \IfEmpty{#2}
          {%
            \IfEmpty{#3}
              {%
                \pltzdt@memsection{#4}%
              }
              {%
                \pltzdt@memsection[#4][#3]{#4}%
              }%
          }
          {%
            \IfEmpty{#3}
              {%
                \pltzdt@memsection[#2]{#4}%
              }
              {%
                \pltzdt@memsection[#2][#3]{#4}%
              }
          }%
      }%
    \@afterindenttrue%
    \@afterheading%
  }

\let\pltzdt@memsubsection\subsection
\RenewDocumentCommand \subsection { s o m }
  {%
    \IfBooleanTF{#1}
      {%
        \pltzdt@memsubsection*{#3}%
      }
      {%
        \IfEmpty{#2}
          {\pltzdt@memsubsection{#3}}
          {\pltzdt@memsubsection[#2]{#3}}%
      }%
    \@afterindenttrue%
    \@afterheading%
  }
  
\renewcommand{\cftchapterleader}{%
  \cftdotfill{\cftdotsep}%
}
\setlength{\cftparskip}{0.125em}
\let\pltzdt@numberline\numberline
\renewcommand{\numberline}[1]{\pltzdt@numberline{#1\xperiod}}

\if@sectoc%
  \cftsetindents{section}{0em}{1.5em}
\fi%
  
\cftsetindents{subsection}{2.5em}{1.5em}
\setpnumwidth{2.5em}
\setrmarg{2.75em}

\NewDocumentCommand \chapterend { g }
  {%
    \vspace*{-\beforesecskip}%
    \IfEmpty{#1}
      {%
        \fancybreak*{\printchaptertitle{***}}%
      }
      {%
        \fancybreak*{\printchaptertitle{#1}}%
        \addtocontents{toc}{\protect\par\protect\vspace*{0.25em}}%
        \addcontentsline{toc}{section}{\bfseries #1}%
      }%
    \vspace*{\aftersecskip}%
  }

\AtBeginDocument{%
  \if@headerson%
    \pagestyle{headings}%
  \else%
    \pagestyle{plain}%
  \fi%
}  

\let\pltzdt@footnote\footnote
\RenewDocumentCommand \footnote { s m }
  {%
    \unskip{}%
    \IfBooleanTF{#1}%
      {\pltzdt@footnote[#1]{#2}}%
      {\pltzdt@footnote{#2}}%
  }%

% Если включен режим постраничной нумерации сносок, то загружается
% пакет `perpage`:
\if@perpage%
  \RequirePackage {perpage}%
%
\newcount{\pltzdt@nextspread}
\pltzdt@nextspread=0
\def\pltzdt@thenextspread{\number\pltzdt@nextspread}
\newcount{\pltzdt@spread}
\pltzdt@spread=0
\def\pltzdt@thespread{\number\pltzdt@spread}
\def\c@pchk@#1{%
  \z@=\z@%
  \begingroup%
  \pp@fetchctr{#1}%
  \ifx\pp@page\@empty%
    \let\next\@empty%
  \else%
    \pltzdt@nextspread=\pp@page%
    \divide\pltzdt@nextspread by 2%
     \edef\next{\pltzdt@thenextspread}%
  \fi%
  \addtocounter{pp@a@#1}\@ne%
  \pp@fetchctr{#1}%
  \ifx\pp@page\@empty%
  \else%
    \pltzdt@spread=\pp@page%
    \divide\pltzdt@spread by 2%
     \edef\pp@page{\pltzdt@thespread}%
  \fi%
  \ifcase\ifx\next\pp@page\else\@ne\fi%
    \ifnum\value{#1}=\z@\@ne\fi\z@%
  \else%
    \setcounter{#1}{\value{pp@r@#1}}%
  \fi%
  \pp@writectr\pp@pagectr{#1}{\noexpand\theabspage}%
}%
%
  \MakePerPage {footnote}%
\fi

\def\labelitemi{--}
\renewcommand{\labelenumi}{\arabic{enumi})}

%%
%% Оформление титульной страницы
%% -----------------------------
%%
%% Для оформления титульной страницы с равными полями слева и
%% справа можно использовать окружение **`centertitlingpage`**.

\newenvironment{centertitlingpage}{%
  \begin{titlingpage*}%
    \newlength{\margindiff}%
    \addtolength{\margindiff}{\leftmargin}%
    \addtolength{\margindiff}{-\rightmargin}%
    \divide\margindiff by 2%
    \begin{adjustwidth}{\margindiff}{-\margindiff}%
}{%
  \end{adjustwidth}%
  \end{titlingpage*}%
}

%%
%% Текстовые константы
%% -------------------
%%
%% Часто используемые в тексте условные обозначения имеет смысл
%% обернуть в макрокоманды для обеспечения одинакового и безошибочного
%% набора.
%%
%% **`\authormark`** Выводит пометку-подпись <<--- *Авт.*>>. Обычно
%% указывается после комментария, данного автором или группой авторов
%% материала издания. Также определена краткая форма данной команды
%% --- `\amk`.
%%
\NewDocumentCommand \insertmark { m }
  {%
    \unskip{}~--- \textit{#1}\xspace%
  }

\NewDocumentCommand \definemark { m m }
  {%
    \expandafter \DeclareDocumentCommand%
      \csname#1\endcsname {}%
      {%
        \insertmark {#2}%
      }%
  }
\global\def\pltzdt@amk{Auth}%
\AtBeginDocument{%
  \ifluatex%
    \global\def\pltzdt@amk{Авт}%
  \else%
    \global\def\pltzdt@amk{\CYRA\cyrv\cyrt}%
  \fi%
}
\definemark {authormark} {\pltzdt@amk{}.}
\NewDocumentCommand \amk {} {\authormark}

%%
%% **`\editormark`** Выводит подпись-пометку <<--- *Ред.*>>. Обычно
%% указывается после комментария, данного редактором или группой
%% редакторов материала издания. Также определена краткая форма данной
%% команды --- `\emk`.
%%
\global\def\pltzdt@emk{Ed}%
\AtBeginDocument{%
  \ifluatex%
    \global\def\pltzdt@emk{Ред}%
  \else%
    \global\def\pltzdt@emk{\CYRR\cyre\cyrd}%
  \fi%
}
\definemark {editormark} {\pltzdt@emk{}.}
\NewDocumentCommand \emk {} {\editormark}

%%
%% Иногда вместо пометок *Авт.* или *Ред.* используют инициалы автора
%% или редактора. Если такой вариант оформления является
%% предпочтительным, то соответствующая команда может быть
%% переопределена посредством конструкции `\definemark`. 
%%
%% **`\definemark`**`{` *команда* `}{` *подпись* `}` Определяет (или
%% переопределяет) команду *команда* для вывода подписи-пометки.
%% Например, конструкция
%%
%%     \definemark{authormark}{В.",И.}
%%
%% переопределяет команду `\authormark` так, что теперь вместо
%% <<--- *Авт.*>> будет подставляться <<--- *В.И.*>>.
%% Последовательность <<`",`>>, данная выше в качестве разделителя
%% инициалов при определении команды не случайна: она служит для
%% набора краткого неразрывного пробела, специально предназначенного
%% для разделения инициалов (определена в пакете `babel` для русского
%% языка).
%%
%% С другой стороны, более наглядным может быть в этом случае
%% определение новой, именной пометки с последующим переопределением
%% команды примечания автора или редактора (о примечаниях см. в
%% следующем разделе). Например:
%%
%%     \definemark{stalin}{И.\,Ст.}
%%     \definenote{author}{inline}{\stalin}

%%
%% Все пометки, определённые посредством команды `\definemark`, равно
%% как и встроенные `\amk` и `\emk`, автоматически заменяют
%% впередистоящий пробел на неразрывный, или добавляют таковой, если
%% команда была набрана без пробела. Внутри пакета правильное
%% форматирование подписей-пометок выполняет команда `\insertmark`.

%%
%% **`\hia`** Выводит текст <<здесь и далее>>. Удобна для 
%% использования в рабочих черновых заметках (см. далее). В основном
%% тексте публикуемого материала, напротив, стоит избегать её
%% использования, поскольку это не добавляет наглядности исходному
%% тексту.
\global\def\pltzdt@hia{hereinafter}%
\AtBeginDocument{%
  \ifluatex%
    \global\def\pltzdt@hia{здесь и далее}%
  \else%
    \global\def\pltzdt@hia{\cyrz\cyrd\cyre\cyrs\cyrsftsn \cyri
      \cyrd\cyra\cyrl\cyre\cyre}%
  \fi%
}
\NewDocumentCommand \hia {} {\pltzdt@hia}

%%
%% **`\myem`** и **`\ourem`** Выводят текст <<Курсив мой.>> и <<Курсив
%% наш.>> соответственно. Посредством дополнительного аргумента в
%% фигурных скобках данным командам может быть передан текст для
%% вставки в среднюю часть предложения. Так, команда `\myem{везде}`
%% даст в результате <<Курсив везде мой.>>.
\NewDocumentCommand \definecomment { m m g }
  {%
    % Определение команды для вывода комментария
    \IfEmpty{#3}
      {%
        \expandafter \DeclareDocumentCommand%
        \csname#1\endcsname { g }%
          {%
            \unskip{} #2\IfEmpty{##1}{}{ ##1}\xperiod%
          }%
      }
      {%
        \expandafter \DeclareDocumentCommand%
        \csname#1\endcsname { g }%
          {%
            \unskip{} #2\IfEmpty{##1}{}{ ##1} #3\xperiod%
          }%
      }%
    % Определение команды для вывода комментария с обязательным
    % уточнением в запятых
    \IfEmpty{#3}
      {%
        \expandafter \DeclareDocumentCommand%
          \csname#1x\endcsname { m }%
          {%
            \unskip{} #2, ##1\xperiod%
          }%
      }
      {%
        \expandafter \DeclareDocumentCommand%
          \csname#1x\endcsname { m }%
          {%
            \unskip{} #2, ##1, #3\xperiod%
          }%
      }%
  }%
\global\def\pltzdt@myempre{Emphasized}%
\global\def\pltzdt@myempost{by me}%
\global\def\pltzdt@ourempre{Emphasized}%
\global\def\pltzdt@ourempost{by us}%
\AtBeginDocument{%
  \ifluatex%
    \global\def\pltzdt@myempre{Курсив}%
    \global\def\pltzdt@myempost{мой}%
    \global\def\pltzdt@ourempre{Курсив}%
    \global\def\pltzdt@ourempost{наш}%
  \else%
    \global\def\pltzdt@myempre{\CYRK\cyru\cyrr\cyrs\cyri\cyrv}%
    \global\def\pltzdt@myempost{\cyrm\cyro\cyri}%
    \global\def\pltzdt@ourempre{\CYRK\cyru\cyrr\cyrs\cyri\cyrv}%
    \global\def\pltzdt@ourempost{\cyrn\cyra\cyrsh}%
  \fi%
}
\definecomment{myem}{\pltzdt@myempre}{\pltzdt@myempost}
\definecomment{ourem}{\pltzdt@ourempre}{\pltzdt@ourempost}

\AfterPackage{babel}{%
  \AtBeginDocument{%
    \if@journal%
      \ifluatex%
        \global\def\contentsname{Содержание}
      \else%
        \global\def\contentsname{\CYRS\cyro\cyrd\cyre\cyrr\cyrzh\cyra\cyrn\cyri\cyre}
      \fi%
    \fi%
  }%
}

%%
%% **`\myemx`**`{` *уточнение* `}` и **`\ouremx`**`{` *уточнение* `}`
%% Сходны с предыдущими командами, но аргумент в фигурных скобках
%% является обязательным. Указанный текст будет добавлен в среднюю
%% часть предложения и взят в запятые. Так, команда `\ouremx{кроме
%% последнего}` даст в результате <<Курсив, кроме последнего, наш.>>.

%%
%% Как и в случае с командой `\hia`, перед использованием данных
%% макросов стоит задуматься о том, готовы ли вы снизить наглядность
%% исходного текста издания ради более структурированного набора.

%%
%% **`\definecomment`**`{` *команда* `}{` *перед* `}{` *после* `}`
%% Определяет пометку-комментарий, сходную по структуре с четырьмя
%% вышеприведёнными командами. Может быть использована для
%% переопределения данных команд. Это может потребоваться, например,
%% для того, чтобы их текст более соответствовал стилистике или
%% оформлению издания. Например, следующая конструкция переопределяет
%% текст пометки `\ourem` так, что вместо <<Курсив наш.>> будет
%% выводиться текст <<Подчеркнуто нами.>>:
%%
%%     \definecomment{ourem}{Подчеркнуто}{нами}
%%
%% Вместе с `\ourem` автоматически будет обновлено определение
%% `\ouremx`. Последний, третий аргумент команды является
%% необязательным.


%%
%% Оформление текста
%% -----------------
%%
%% **`\acc`**`{` *текст* `}` Дополняет стандартную макрокоманду
%% `\emph{текст}` для выделения частей текста. Данная команда
%% обеспечивает акцентированное выделение указанного фрагмента.
%% По умолчанию используется полужирное начертание. Если требуется
%% иной способ выделения текста --- переопределите данную команду
%% используя стандартные средства (`\renewcommand` или
%% `\RenewDocumentCommand`).
\NewDocumentCommand \acc { m } {\textbf{#1}}

%%
%% **`\qq`**`{` *текст* `}` Является обёрткой вокруг макрокоманды
%% `\enquote` из пакета `csquotes`. Указанный в команде текст будет
%% взят в кавычки. Важной особенностью команды является автоматическое
%% отслеживание глубины кавычек. По этой причине её очень удобно и
%% полезно использовать для набора цитат. Иногда случается так, что
%% цитируемый текст сам уже содержит отдельные слова или фрагменты в
%% кавычках. Но если вместо явного указания символов кавычек всюду
%% использовать команду `\qq`, то внутренние кавычки автоматически
%% будут набраны иначе чем внешние, и у читателя не возникнет
%% путаницы при чтении.
\newcommand{\qq}[1]{\enquote{#1}}

%%
%% **`quotation`** В пакете переопределяется стандартное
%% окружение для набора блочных цитат: отступ в них даётся только
%% с левой стороны. Кроме того, улучшена набор подписи для
%% блочных цитат команда --- `\sourceatright`.
\renewenvironment{quotation}{%
  \begin{adjustwidth}{2.5em}{0pt}%
    \hskip\parindent%
}{%
  \end{adjustwidth}%
}

%%
%% **`\sourceatright`**`{` *текст* `}` Эта команда предназначена для
%% набора подписи или источника в блочной цитате. Например:
%%
%%    \begin{quotation}
%%      \qq{\ldots{}не убаюкивать надо партию, --- а развивать в~ней
%%        бдительность, не усыплять ее, --- а держать в~состоянии
%%        боевой готовности, не разоружать, а вооружать, не
%%        демобилизовывать, --- а держать ее в~состоянии
%%        мобилизации\ldots{}}
%%      \sourceatright{\emph{И.\,Сталин.} Из доклада на XVII
%%        съезде ВКПб}
%%    \end{quotation}
%%
\let\sourceatrightcmd\sourceatright
\renewcommand{\sourceatright}[1]{%
  \sourceatrightcmd[2em]{\raisebox{-.4em}{\small #1}}%
  \bigskip%
}

%%
%% **`\signatright`**`{` *текст* `}` Набор простых подписей
%% и источников после абзаца. Подпись набирается курсивом.
\newcommand{\signatright}[1]{%
  \begin{flushright}%
    \smallskip%
    \emph{#1}%
  \end{flushright}%
  \goodbreak%
}

%%
%% **`\starbreak`** Отступ с разделением звёздочками.
\newcommand{\starbreak}{%
  \medskip
  \fancybreak*{ * * * }
  \medskip
}

%%
%% **`intro`** Аналогично окружению `quotation`, но полоса зауживается
%% с обоих сторон.
\newenvironment{intro}{%
  \begin{adjustwidth}{2.5em}{2.5em}%
    \hskip\parindent%
}{%
  \end{adjustwidth}%
  \medskip%
}

%%
%% Сноски и примечания
%% -------------------
%%
%% Определённые выше подписи-пометки `\amk` и `\emk` наиболее часто
%% используются в сносках, а также примечаниях других форм. Для более
%% удобного набора таких снабжённых подписью примечаний, пакет
%% предоставляет команды `\authornote` и `\editornote` соответственно.
%%
%% **`\authornote`**`{` *примечание* `}` Оформляет примечание
%% автора. Форма определяется настройками пакета. Команда имеет
%% краткую форму --- `\anote{Примечание.}`.
\NewDocumentCommand \definenote { m m o } {%
  \ifthenelse {\equal {#2} {inline}} {%
    \expandafter \DeclareDocumentCommand%
       \csname#1note\endcsname { m }%
       { (##1 \IfEmpty {#3} {\csname#1\endcsname} {#3})}%
  } {}%
  \ifthenelse {\equal {#2} {foot}} {%
    \expandafter \DeclareDocumentCommand%
       \csname#1note\endcsname { m }%
       {%
         \footnote%
           {%
             ##1 \IfEmpty {#3} {\csname#1\endcsname} {#3}%
           }%
       }%
  } {}%
  \ifthenelse {\equal {#2} {end}} {%
    \expandafter \DeclareDocumentCommand%
       \csname#1note\endcsname { m }%
       {%
         \endnote%
           {%
             ##1 \IfEmpty {#3} {\csname#1\endcsname} {#3}%
           }%
       }%
  } {}%
  \ifthenelse {\equal {#2} {side}} {%
    \expandafter \DeclareDocumentCommand%
       \csname#1note\endcsname { m }%
       {%
         \marginpar%
           {%
             \begin{sloppypar}%
               \footnotesize%
               ##1 \IfEmpty {#3} {\csname#1\endcsname} {#3}%
             \end{sloppypar}%
           }%
       }%
  } {}%
}

\if@inlinenotes%
  \definenote{author}{inline}[\authormark]%
\else%
  \definenote{author}{foot}[\authormark]%
\fi%
\NewDocumentCommand \anote { m } {\authornote {#1}}

%%
%% **`\editornote`**`{` *примечание* `}` Оформляет примечание
%% редактора. Форма определяется настройками пакета. Команда имеет
%% краткую форму --- `\enote{Примечание.}`.
\if@inlinenotes%
  \definenote {editor}{inline}[\editormark]%
\else%
  \definenote {editor}{foot}[\editormark]%
\fi
\NewDocumentCommand \enote { m } {\editornote {#1}}

%%
%% Согласно настройкам пакета примечания оформляются по разному. Для
%% книжных и журнальных изданий (опции `book` и `journal`) примечания
%% оформляются в виде сносок внизу страницы, а для издания с
%% однородной структурой (опция `plain`) заключаются в круглые скобки
%% и включаются в основной текст. В том случае, если вам требуется
%% другой вариант оформления примечаний, воспользуйтесь командой
%% `\definenote`.
%%
%% **`\definenote`**`{` *имя* `}{` *тип* `}[` *пометка* `]` Определяет
%% (или переопределяет) команду `\`*`имя`*`note` для оформления
%% примечаний типа *тип*. Третий, необязательный аргумент, задаёт
%% команду для автоматического вывода пометки в конце
%% примечания. Например, после команды
%%
%%     \definenote{editor}{side}{\emk}
%%
%% примечания редактора, данные посредством команды `\editormark`,
%% будут выводится в виде заметок на полях издания и снабжаться
%% пометкой <<--- *Ред.*>>.

%% Возможными значениями для аргумента *тип* являются:
%%
%% * `inline` для оформления примечаний в круглых скобках в основном
%% тексте издания;
%% * `foot` для оформления в виде сносок внизу страницы;
%% * `end` для оформления в виде концевых сносок (пакет `endnotes` в
%% этом случае должен быть загружен отдельно);
%% * `side` для заметок на полях.

%%
%% Все команды примечаний автоматически определяют, нужен ли для
%% правильного набора впередистоящий пробел, или же он является
%% лишним. Так, перед круглыми скобками (форма `inline`) пробел
%% автоматически вставляется, а перед знаком сноски (форма `foot`) он
%% будет убран. Таким образом все команды примечаний при вводе можно
%% как отбивать пробелами, так и не отбивать.


%%
%% Рабочие (черновые) заметки
%% --------------------------

%% Рабочие заметки на полях --- удобное средство обмена информацией
%% при коллективной работе над изданием. Вре́менные черновые заметки
%% помещаются на полях издания в косых скобках и только в режиме
%% черновика (опция `draft`). Для набора заметки используйте команду
%% `\notice`. Например, конструкция
%%
%%     \notice{Слишком многословно. \pavel}
%%
%% помещает рабочую заметку с указанным текстом и подписью. В отличие
%% от команд примечаний, автоматически добавляющих соответствующую
%% пометку-подпись к тексту, данная команда не делает этого: явное
%% включение подписи в текст пометки делает исходный текст издания
%% более наглядным.
\newcounter{pltzdt@notice}
\setcounter{pltzdt@notice}{1}
\NewDocumentCommand \notice { m }
  {%
    \unskip{}%
    \if@draftmode\if@noticeon%      
      \marginpar%
        {%
          \begin{sloppypar}%
            \footnotesize%
            /\thepltzdt@notice: #1/%
          \end{sloppypar}%
        }%
      \stepcounter{pltzdt@notice}%
      \xspace%
    \fi\fi%
  }

%%
%% Заметка будет размещена напротив того фрагмента текста, в который
%% входит команда, если такому размещению не препятствуют другие
%% заметки. В противном случае заметка будет сдвинута вниз на
%% свободное место.

%%
%% Полнее и продуктивнее использовать механизм заметок позволяют
%% текстовые константы, описанные в предыдущем разделе. Так, например,
%% макрокоманду `\hia` удобно использовать для добавления к тексту
%% заметки слов <<здесь и далее>>. Одна заметка с такой припиской
%% является хорошей альтернативой повторению одной и той же заметки в
%% нескольких местах.

\NewDocumentCommand \inlang { m m }
{%
  \IfEmpty{#1}
    {#2}
    {%
      \foreignlanguage{#1}
      {%
%        {%
          \if@switchfont%
            \expandafter\ifcsname#1font\endcsname%
              \csname#1font\endcsname%
%            \else%
%              \ifdefined\mainfont%
%              \mainfont
%              \else%
%                \ifdefined\fontspec%
%                  \fontspec{\rmdefault}%
%                \fi%
%              \fi%
            \fi%
          \fi%
          #2%
%        }%
      }%
    }%
}

%%
%% Ссылки на страницы
%%
%% В LaTeX доступна команда для набора номера страницы с меткой.
%% Она подходит для указания на определённое место в тексте. Однако
%% часто нужно указать не на одно место, а на целый *фрагмент* текста,
%% который может занимать несколько страниц или просто перейти с одной
%% страницы на другую. Для обозначения фрагментов и набора ссылок на
%% них в пакет добавлены специальные команды.
%%
%% **`\startlabel`**`{` *метка* `}
%% **`\endlabel`**
%%
%% Первая команда устанавливает метку начала фрагмента, вторая --- его
%% конец. Внутри команд, метки дополняются суффиксами `:start` и
%% `:end`, и, при необходимости, могут использоваться независимо друг
%% от друга.
%%
%% ** `\rangeref`**`{` *метка* `}
%% ** `\rangerefhic`**`{` *метка* `}
%%
%% Первая команда набирает `с.~N` или `с.~N--M` автоматически,
%% в зависимости от того, на одно или на разные страницы указывают
%% метки начала и конца фрагмента. Вторая команда дополняет вывод
%% словами «настоящего издания».

\NewDocumentCommand \startlabel { m }
  {%
    \unskip{}%
    \begingroup%
    \def\pltzdt@labelbase{#1}%
    \label{#1:start}%
  }
\NewDocumentCommand \endlabel {}
  {%
    \unskip{}\label{\pltzdt@labelbase:end}%
    \endgroup%
  }

\NewDocumentCommand \rangeref { m }
  {%
    с.~\ifthenelse {\equal {\pageref{#1:start}} {\pageref{#1:end}}}
      {\pageref{#1:start}}
      {\pageref{#1:start}--\pageref{#1:end}}%
  }

\NewDocumentCommand \rangerefhic { m }
  {%
    \rangeref{#1} настоящего издания%
  }

%%
%% Ссылки на литературу
%% --------------------
%%
%% Предоставление информации о цитируемых источниках литературы в
%% удобной для читателя форме является неотъемлемой частью научных
%% политических изданий. Нижеследующий набор макрокоманд позволяет в
%% простой форме точно управлять структурой и отображением ссылок на
%% литературу.

%%
%% Краткая форма команды для вставки ссылки на источник литературы
%% полностью совпадает с классической формой, принятой в LaTeX:
%%
%% **`\cite`**`{` *ключ* `}`, где *ключ* указывает на соответствующий
%% источник литературы в базе данных или списке источников.

%%
%% Дополнительно, в квадратных скобках может быть указано *уточнение*:
%% номер страницы, раздела, главы или какая-либо другая информация,
%% уточняющая ссылку:
%%
%% **`\cite`**`{` *ключ* `}[` *уточнение* `]` либо
%% **`\cite`**`[` *уточнение* `]{` *ключ* `}`

%%
%% Дополнительная информация будет указана непосредственно после
%% наименования источника литературы *через запятую*. В самом
%% распространённом случае, когда указывается номер страницы, диапазон
%% или перечисление номеров страниц, в квадратные скобки заключается
%% только числовая информация: один номер, диапазон номеров в виде
%% пары чисел, записанных через короткое тире (`--`), и/или несколько
%% единичных номеров и диапазонов, разделяемых запятыми. Во всех
%% перечисленных случаях указывать дополнительные пометки, такие как
%% <<с.>> или <<сс.>> не требуется.  В отличие от классической команды
%% `\cite`, дополнительный аргумент может записываться как до, так и
%% после ключа. Таким образом, конструкции `\cite[55]{Marx:Kapital:I}`
%% и `\cite{Marx:Kapital:I}[55]` дадут одинаковый результат -- ссылку
%% на 55 страницу книги К.Маркса <<Капитал>>.

%%
%% Полный синтаксис команды `\cite` выглядит следующим образом и
%% включает в себя ещё один важный дополнительный параметр ---
%% *примечание*:
%%
%% **`\cite`**`{` *ключ* `}[` *уточнение* `]{` *примечание* `}`
%%
%% В отличие от уточняющей информации, параметр *примечание*
%% предназначен для набора комментариев, имеющих отношение не к
%% источнику литературы, а к самой цитате, приводимой в тексте
%% издания. Наиболее распространённым примечанием такого рода является
%% указание на изменение курсивного или иного способа выделения слов
%% цитируемого текста, выполненного автором или редактором, такое как
%% <<Курсив мой>> или <<Подчёркнуто нами>>. Другим примером подобного
%% примечания может служить указание на различия между приведённой
%% цитатой и соответствующим местом в источнике литературы (например,
%% указание на другой перевод). Оформление подобного примечания в виде
%% отдельной сноски во многих случаях является избыточным.
%%
%% Пример команды `\cite` с дополнительными аргументами:
%%
%%     \cite{Marx:Kapital:I}[55]{Курсив везде наш. \amk}
%%
%% Опытные пользователи пакета также могут воспользоваться
%% макрокомандами для набора текстовых констант, записав
%% вышеприведённый фрагмент в более структурированном виде:
%%
%%     \cite{Marx:Kapital:I}[55]{\ourem{везде}\amk}


% Команда для проверки принадлежности источника к основной
% категории:
\NewDocumentCommand \ifmaincategory { m m }
  {%
    #2%
  }
\NewDocumentCommand \setmainkeywords { m }
  {%
    \RenewDocumentCommand \ifmaincategory { m m }
      {%
        \ifkeyword {#1} {##1} {##2}%
      }%
  }

\AfterPackage{biblatex}{%

\NewDocumentCommand \inbiblang { m }
{%
  \iffieldundef{langid}
    {#1}
    {\inlang{\thefield{langid}}{#1}}%
}

% Определение команд цитат


% Настройка отображения имён. [!Не работает в новой версии TexLive,
% нужно разбираться!]

% Отображение имени автора в библиографии и порядок сортировки имён:
% фамилия, имя (инициалы):
% \DeclareNameAlias{default}{last-first}
% \DeclareNameAlias{sortname}{last-first}
% \DeclareNameFormat{last-first}{%
%   \iffirstinits
%     {\inbiblang{\usebibmacro{name:last-first}{#1}{#4}{#5}{#7}}}
%     {\inbiblang{\usebibmacro{name:last-first}{#1}{#3}{#5}{#7}}}%
%   \usebibmacro{name:andothers}}


% Определение и переопределение форматов вывода различных
% библиографических полей и составных элементов.

% Формат вывода названия работы: в ссылке ---  обычным, в
% библиографии --- курсивом:
\DeclareFieldFormat*{title}{\inbiblang{#1}}
\DeclareFieldFormat*{firsttitle}{\inbiblang{\mkbibemph{#1}}}

% Дополнительное название выводится в скобках:
\DeclareFieldFormat*{titleaddon}{\inbiblang{\mkbibemph{\printtext[parens]{#1}}}}
\DeclareFieldFormat*{booktitleaddon}{\inbiblang{\mkbibemph{\printtext[parens]{#1}}}}

% Название книги-сборника (журнала) выводится обычным шрифтом:
\DeclareFieldFormat*{booktitle}{\inbiblang{#1}}
\DeclareFieldFormat*{maintitle}{\inbiblang{#1}}
\DeclareFieldFormat*{journaltitle}{\mkbibquote{\inbiblang{#1}}}

\DeclareListFormat{publisher}{%
  \usebibmacro{list:delim}{#1}%
  \inbiblang{#1}\isdot
  \usebibmacro{list:andothers}}

\DeclareListFormat{location}{%
  \usebibmacro{list:delimdash}%
  \ifthenelse {\equal {#1} {Москва}}
    {\inbiblang{М.}}{%
  \ifthenelse {\equal {#1} {Ленинград}}
    {\inbiblang{Л.}}{%
  \ifthenelse {\equal {#1} {Санкт-Петербург}}
    {\inbiblang{СПб.}}{%
  \ifthenelse {\equal {#1} {Санкт\hyp Петербург}}
    {\inbiblang{СПб.}}{%
  \inbiblang{#1}}}}}\isdot%
  \usebibmacro{list:andothers}%
}

\newbibmacro*{list:delimdash}{%
  \ifnumgreater{\value{listcount}}{\value{liststart}}
    {\unskip{}--}
    {}%
}

% Короткое тире для диапазонов
\DefineBibliographyExtras{russian}{%
  \protected\def\bibrangedash{%
    \textendash\penalty\hyphenpenalty}%
  \protected\def\bibdatedash{%
    \textendash\penalty\hyphenpenalty}%
}

% Специальный формат для набора названия непосредственно в основном
% тексте: название работы заключается в кавычки:
\DeclareFieldFormat*{citetitle}{\mkbibquote{\inbiblang{#1}}}

% Обратные ссылки на страницы --- курсивом, через тире:
\DeclareFieldFormat*{pageref}{\unskip{} ---~\mkbibemph{#1}}

% Форматы вывода номеров-ссылок на источник в списке библиографии.
% Для основной категории (см. ниже) номера выводятся полужирным
% шрифтом:
\DeclareFieldFormat*{labelnumber}{#1}%
\DeclareFieldFormat*{labelnumber:main}{\mkbibbold{#1}}%

% Формат вывода части книги (тома):
\DeclareFieldFormat{part}{\bibstring{part}~#1}

% \DeclareFieldFormat{booktitle}{%
%   \ifentrytype {incollection}
%     {\mkbibquote{\inbiblang{#1}}}
%     {#1}%
% }

% Переопределение макрокоманд для набора элементов библиографии
% и ссылок на литературу. В определениях широко используются
% определённые выше форматы вывода.

% Переопределение макроса для набора заголовка работы в
% библиографии: используется формат `firsttitle`.
\renewbibmacro* {title} {%
  \printfield[firsttitle]{title}%
  \setunit*{\subtitlepunct}%
  \printfield[firsttitle]{subtitle}%
  \setunit*{\addspace}%
  \printfield{titleaddon}%
}

% Макрос для набора номера-ссылки на источник в библиографии. Номер
% выводится в квадратных скобках. Для основной категории номера
% выводятся в одном формате (полужирным шрифтом), а для дополнительной
% --- в другом (курсивом):
\newbibmacro* {labelnumber} {%
  \iffieldundef {labelnumber}
    {}
    {%
      \setunit{\addspace}%
      [%
        \printtext[bibhyperref]
          {%
            \ifmaincategory
              {%
                \printfield[labelnumber:main]{labelnumber}%
              }
              {%
                \printfield[labelnumber]{labelnumber}%
              }%
          }%
      ]%
    }%
}

\global\cslet{pltzdt@parentseen}\@empty
\newcommand {\ifparentseen}[2] {%
  \iffieldundef{crossref}
    {#2}
    {\xifinlistcs{\thefield{crossref}}{pltzdt@parentseen}{#1}{#2}}%
}
\newcommand {\markparentseen} {%
  \iffieldundef{crossref}
    {}
    {%
      \xifinlistcs{\thefield{crossref}}{pltzdt@parentseen}
        {}
        {%
          \listcsxadd{pltzdt@parentseen}{\thefield{crossref}}%
        }%
    }%
}

\let\pltzdt@blx@citereset\citereset
\renewcommand{\citereset}{%
  \pltzdt@blx@citereset%
  \global\cslet{pltzdt@parentseen}\@empty%
}

\newcommand {\ifperiodical}[2] {%
  \ifthenelse {%
    \ifentrytype {periodical} \OR
    \ifentrytype {journal}%
  }{#1}{#2}%
}

\newcommand {\ifinperiodical}[2] {%
  \ifthenelse {%
    \ifentrytype {periodical} \OR
    \ifentrytype {article} \OR
    \ifentrytype {journal}%
  }{#1}{#2}%
}

\newbibmacro* {citemore} {%
  \if@citemore%
    \ifinperiodical
      {}
      {%
        \usebibmacro{publisher+location+date}%
      }%
    \markparentseen%
  \fi%
}

\renewbibmacro*{maintitle+booktitle}{%
  \iffieldundef{maintitle}
    {}
    {\usebibmacro{maintitle}%
     \newunit\newblock
     \iffieldundef{volume}
       {}
       {\printfield{volume}%
        \newunit\printfield{part}%
        \setunit{\addcolon\space}}}%
  \usebibmacro{booktitle}%
  \newunit}

% Макрос для набора уточняющей информации о книге, сборнике или
% журнале. Сюда входит информация о номере издания, тома,
% части, выпуска, главы, страницы или диапазона страниц. Номер главы
% выводится только в том случае, если для цитаты не была указана
% отдельно другая уточняющая информация (возможно, что это не совсем
% верно).
\newbibmacro* {details} {%
  \newunit\printfield{edition}%
  \iffieldundef{number}
    {\newunit}
    {%
      \newunit\bibsstring{number}%
      \setunit{\,}\printfield{number}%
    }%
  \iffieldundef {shortseries}
  {%
    \iffieldundef {maintitle}
      {%
        \printfield{volume}%
        \newunit\printfield{part}%
      }
      {}%
  }
  {%
    \printfield{volume}%
    \newunit\printfield{part}%
  }%
  \ifinperiodical
    {%
      \newunit\usebibmacro{issue+date}%
    }
    {}% 
  \newunit\printfield{volumes}%
  \ifciteseen
    {}
    {%
      \ifparentseen
        {}
        {%  
          \newunit%
          \usebibmacro{citemore}%
        }%
    }%
  \iffieldundef {postnote}
    {%
      \newunit\usebibmacro{chapter+pages}%
    }%
    {}%
}

\renewbibmacro* {issue+date} {%
  \iffieldundef{issue}
    {\usebibmacro{date}\,г\adddot}
    {%
      \printtext[parens]{\printfield{issue}}%
      \setunit{\addspace}%
      \usebibmacro{date}\,г\adddot%
    }%
}

\renewbibmacro* {journal+issuetitle} {%
  \usebibmacro{journal}%
  \iffieldundef{series}
    {}
    {%
      \setunit{\addspace}%
      \printfield{series}%
    }%
}

\renewbibmacro* {publisher+location+date} {%
  \printlist{location}\setunit*{\addcolon~}%
  \printlist{publisher}%
  \newunit\usebibmacro{date}%
}

% В ссылках на литературу указывать только имена авторов,
% но не редакторов и пр.
\DeclareLabelname{%
  \field{shortauthor}
  \field{author}
}

% Переопределение макроса для набора ссылки на библиографический
% источник в краткой форме. В конце ссылки в квадратных скобках
% выводится номер соответствующего источника в библиографии. При этом,
% если источник не принадлежит к дополнительной категории, то номер
% выводится полужирным шрифтом, иначе --- курсивом. Если для источника
% дана краткая форма названия сборника, серии или журнала в поле
% `shortseries` (например, <<Соч.>> или <<ПСС>>), то в краткой ссылке
% оно будет использовано вместо полного названия.
\renewbibmacro* {cite:short} {%
  \printfield{label}%
  \inbiblang{\mkbibemph{\printnames{labelname}}}%
  \newblock%
  \ifperiodical
    {\printfield[citetitle]{labeltitle}}
    {\printfield[title]{labeltitle}}%
  \newunit%
  \iffieldundef {shortseries}
    {%
      \iffieldundef {booktitle}
        {}
        {%
          \usebibmacro {maintitle+booktitle}%
        }%
      \iffieldundef {journaltitle}
        {}
        {%
          \usebibmacro {journal+issuetitle}%
        }%
    }
    {%
      \ifinperiodical
        {\printfield [citetitle] {shortseries}}
        {\printfield {shortseries}}%
    }%
  \midsentence%
  \usebibmacro {details}%
  \usebibmacro {labelnumber}%
}

% Полная форма библиографической ссылки включает в себя больше
% информации по сравнению с краткой формой. Используется для впервые
% печатаемых ссылок в режиме `citemore`.
\renewbibmacro* {cite:full} {%
  \usebibmacro {cite:short}%
}

% Переопределение макроса для набора краткой ссылки на источник,
% цитированный в прошлый раз. Оформляется словами <<Там же>>. В
% отличие от стандартного определения макроса, данный текст не
% оформляется как гиперссылка.
\renewbibmacro* {cite:ibid} {%
  \bibstring[\mkibid]{ibidem}%
  \ifloccit
    {\global\toggletrue{cbx:loccit}}
    {}%
}

% Переопределение макроса для вывода обратной ссылки на страницы, где
% были даны цитаты. Используется формат вывода `pageref`.
\renewbibmacro* {pageref} {%
  \iflistundef{pageref}
    {}
    {%
      \adddot\addspace%
      \printtext[pageref]{%
        \printlist[pageref][-\value{listtotal}]{pageref}%
      }%
    }%
}

% Привязка стандартной команды `\cite` к имени `\printbibcite`.
\let\printbibcite\cite

% Определение команды для набора текста библиографической ссылки.
\NewDocumentCommand \printcite { o m o g }
  {%
    \IfEmpty{#1}
      {%
        \IfEmpty{#3}
          {% Передан только ключ #2
            \printbibcite{#2}%
          }%
          {% Передан ключ #2 и уточнение #3
            \printbibcite[#3]{#2}%
          }%
      }%
      {% Передан ключ #2 и уточнение #1
        \printbibcite[#1]{#2}%
      }%
    \IfEmpty{#4}
      {}
      {%
        \addperiod%
        \addspace%
        {\citetrackerfalse{}#4\nopunct{}\citetrackertrue}%
      }%
  }

% Переопределение команды для оформления текста библиографической
% ссылки. Согласно настройкам пакета ссылка оформляется виде сноски
% или непосредственно в основном тексте в скобках.
\DeclareDocumentCommand \cite { o m o g } {%
  \if@inlinebib%
    \space\mkbibparens{\printcite[#1]{#2}[#3]{#4}\unskip{}}%
  \else%
    \iftoggle{blx@footnote}% FIXME: Зависимость от флага biblatex
      {\space\mkbibparens{\printcite[#1]{#2}[#3]{#4}\unskip{}}}%
      {\mkbibfootnote{\printcite[#1]{#2}[#3]{#4}}}%
  \fi%
}

%%
%% Форма оформления ссылок на литературу определяется опциями
%% пакета. Опция `footbib` включает оформление ссылок в виде сносок
%% внизу страницы и используется по умолчанию для книжных изданий
%% (опция `book`). Альтернативным вариантом оформления ссылок является
%% вывод краткой информации об источнике в скобках, непосредственно в
%% основном тексте издания. Такой вариант оформления выбирает опция
%% `inlinebib` --- он используется по умолчанию для изданий с
%% однородной структурой (опция `plain`).

%%
%% Специально для случая, когда ссылку на литературу необходимо
%% вставить в текст непосредственно, в пакете определена команда
%% `\printcite`. Синтаксис её аналогичен команде `\cite`, но
%% набранная таким образом ссылка не будет оформлена никаким из
%% вышеуказанных способов. Команда `\printcite` удобна для набора
%% примечаний со ссылками на литературу, подобных
%%
%%     \enote{См. также: \printcite{Marx:Kapital:I}[55]}

%%
%% Ещё более краткий вариант оформления ссылки, предназначенный для
%% упоминания названий работ в тексте, предоставляет команда
%% `\citetitle{ключ}`. Она вставляет в текст название работы, взятое
%% в кавычки, а следом --- номер-ссылку на информацию о
%% соответствующей публикации в списке источников литературы.
%% Пример:
%%
%%     Впервые эта мысль была высказана Лениным в статье
%%     \citetitle{Ленин:С чего начать?}.
%%
\DeclareCiteCommand{\citetitle}
  {%
    \boolfalse{citetracker}%
    \boolfalse{pagetracker}%
    \usebibmacro{prenote}%
  }
  {%
    \ifciteindex
      {%
        \indexfield{indextitle}%
      }
      {%
      }%
    \printfield[citetitle]{labeltitle}%
    \usebibmacro {labelnumber}%
  }
  {%
    \multicitedelim
  }
  {%
    \usebibmacro{postnote}%
  }

\renewcommand*{\newblockpunct}{\addperiod\addspace}
\renewcommand*{\newunitpunct}{\addcomma\addspace}
\renewcommand*{\subtitlepunct}{\addperiod\addspace}
  
} %\AfterPackage{biblatex}

% Конец.
\endinput
