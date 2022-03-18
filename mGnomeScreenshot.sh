#!/bin/bash
 E='echo -e';    # -e включить поддержку вывода Escape последовательностей
 e='echo -en';   # -n не выводить перевод строки
 c="+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+"
 trap "R;exit" 2 #
    ESC=$( $e "\e")
   TPUT(){ $e "\e[${1};${2}H" ;}
  CLEAR(){ $e "\ec";}
# 25 возможно это
  CIVIS(){ $e "\e[?25l";}
# это цвет текста списка перед курсором при значении 0 в переменной  UNMARK(){ $e "\e[0m";}
MARK(){ $e "\e[1;45m";}
# 0 это цвет списка
 UNMARK(){ $e "\e[0m";}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Эти строки задают цвет фона ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  R(){ CLEAR ;stty sane;CLEAR;};                 # в этом варианте фон прозрачный
 HEAD(){ for (( a=2; a<=26; a++ ))
  do
 TPUT $a 1
        $E "\033[1;35m\xE2\x94\x82                                                                                       \xE2\x94\x82\033[0m";
  done
 TPUT 3 3
        $E "\033[1;36m*** gnome-screenshot ***\033[0m";
 TPUT 4 3
        $E "\033[90mЗапечатлеть экран, окно или определенную область пользователя\033[0m";
 TPUT 5 3
        $E "\033[90mи сохранить изображение снимка в файл.\033[0m";
 TPUT 6 1
        $E "\033[35m+---------------------------------------------------------------------------------------+\033[0m";
 TPUT 9 1
        $E "\033[35m+- Опции ----------------------------------------------- Options -----------------------+\033[0m";
 TPUT 22 1
        $E "\033[35m+ Up \xE2\x86\x91 \xE2\x86\x93 Down Select Enter -------------------------------------------------------------+\033[0m";
 MARK;TPUT 1 1
        $E "$c";UNMARK;}
   i=0; CLEAR; CIVIS;NULL=/dev/null
# 32 это расстояние сверху и 48 это расстояние слева
   FOOT(){ MARK;TPUT 26 1
        $E "$c";UNMARK;}
# это управляет кнопками ввер/хвниз
 i=0; CLEAR; CIVIS;NULL=/dev/null
#
 ARROW(){ IFS= read -s -n1 key 2>/dev/null >&2
           if [[ $key = $ESC ]];then
              read -s -n1 key 2>/dev/null >&2;
              if [[ $key = \[ ]]; then
                 read -s -n1 key 2>/dev/null >&2;
                 if [[ $key = A ]]; then echo up;fi
                 if [[ $key = B ]];then echo dn;fi
              fi
           fi
           if [[ "$key" == "$($e \\x0A)" ]];then echo enter;fi;}
  M0(){ TPUT  7 3; $e " Краткий обзор                                         \033[32mSynopsis                     \033[0m";}
  M1(){ TPUT  8 3; $e " Авторы                                                \033[32mAutor                        \033[0m";}
#
  M2(){ TPUT 10 3; $e " Отправьте захват непосредственно в буфер              \033[32m-c    --clipboard            \033[0m";}
  M3(){ TPUT 11 3; $e " Возьмите текущее активное окно вместо всего экрана    \033[32m-w    --window               \033[0m";}
  M4(){ TPUT 12 3; $e " Выбрать область захвата экрана вместо всего экрана    \033[32m-a    --area                 \033[0m";}
  M5(){ TPUT 13 3; $e " Включите оконную границу в скриншоте                  \033[32m-b    --include-border       \033[0m";}
  M6(){ TPUT 14 3; $e " Удалите оконную границу с скриншота                   \033[32m-B    --remove-border        \033[0m";}
  M7(){ TPUT 15 3; $e " Включите указатель с скриншотом                       \033[32m-p    --include-pointer      \033[0m";}
  M8(){ TPUT 16 3; $e " Сделайте скриншот после указанной задержки в секундах \033[32m-d    --delay=SECONDS        \033[0m";}
  M9(){ TPUT 17 3; $e " Добавьте эффект снаружи границы скриншота             \033[32m-e    --border-effect=EFFECT \033[0m";}
 M10(){ TPUT 18 3; $e " Интерактивно установите опции в диалоге               \033[32m-i    --interactive          \033[0m";}
 M11(){ TPUT 19 3; $e " Сохранить скриншот прямо в этот файл                  \033[32m-f    --file=FILENAME        \033[0m";}
 M12(){ TPUT 20 3; $e " X дисплей для использования                           \033[32m      --display=DISPLAY      \033[0m";}
 M13(){ TPUT 21 3; $e " Показать резюме доступных вариантов                   \033[32m-? -h --help                 \033[0m";}
#
 M14(){ TPUT 23 3; $e "\033[32m Grannik Git                                                                        \033[0m";}
 M15(){ TPUT 24 3; $e "\033[32m Exit                                                                               \033[0m";}
LM=15
   MENU(){ for each in $(seq 0 $LM);do M${each};done;}
    POS(){ if [[ $cur == up ]];then ((i--));fi
           if [[ $cur == dn ]];then ((i++));fi
           if [[ $i -lt 0   ]];then i=$LM;fi
           if [[ $i -gt $LM ]];then i=0;fi;}
REFRESH(){ after=$((i+1)); before=$((i-1))
           if [[ $before -lt 0  ]];then before=$LM;fi
           if [[ $after -gt $LM ]];then after=0;fi
           if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi
           if [[ $after -eq 0 ]] || [ $before -eq $LM ];then
           UNMARK; M$before; M$after;fi;j=$i;UNMARK;M$before;M$after;}
   INIT(){ R;HEAD;FOOT;MENU;}
     SC(){ REFRESH;MARK;$S;$b;cur=`ARROW`;}
# Функция возвращения в меню
     ES(){ MARK;$e " ENTER = main menu ";$b;read;INIT;};INIT
  while [[ "$O" != " " ]]; do case $i in
# Здесь необходимо следить за двумя перепенными 0) и S=M0 Они должны совпадать между собой и переменной списка M0().
  0) S=M0;SC;if [[ $cur == enter ]];then R;echo " gnome-screenshot [-c]  [-w]  [-a]  [-b]  [-B]  [-p]  [-d SECONDS]  [-e EFFECT]  [-i]  [-f FILENAME]  [--display DISPLAY]";ES;fi;;
  1) S=M1;SC;if [[ $cur == enter ]];then R;echo " Эта страница руководства была написана Кристианом Мариллатом: marillat@debian.org
 для системы Debian GNU/Linux (но может использоваться другими).
 Обновлено Theppitak Karoonboonyanan:                          thep@linux.thai.net
 Tom Feiner:                                                   feiner.tom@gmail.com
 Cosimo Cecchi:                                                cosimoc@gnome.org
 и другими.";ES;fi;;
  2) S=M2;SC;if [[ $cur == enter ]];then R;echo " Отправьте захват непосредственно в буфер.";ES;fi;;
  3) S=M3;SC;if [[ $cur == enter ]];then R;echo -e "
 Возьмите текущее активное окно вместо всего экрана. После выполнения данной команды создаётся снимок окна самого терминала:
\033[32m gnome-screenshot -w\033[0m
";ES;fi;;
  4) S=M4;SC;if [[ $cur == enter ]];then R;echo -e "
 Возьмите площадь экрана вместо всего экрана:
\033[32m gnome-screenshot -a\033[0m
";ES;fi;;
  5) S=M5;SC;if [[ $cur == enter ]];then R;echo -e "
 Включите оконную границу в скриншоте. Примечание. Эта опция устарела и оконная граница всегда включена:
\033[32m gnome-screenshot -w -b\033[0m
";ES;fi;;
  6) S=M6;SC;if [[ $cur == enter ]];then R;echo "
 Удалите оконную границу с скриншота. Примечание. Эта опция устарела и оконная граница всегда включена:
\033[32m gnome-screenshot -w -B\033[0m
";ES;fi;;
  7) S=M7;SC;if [[ $cur == enter ]];then R;echo " Включите указатель с скриншотом.";ES;fi;;
  8) S=M8;SC;if [[ $cur == enter ]];then R;echo -e "
 Сделайте скриншот после указанной задержки в секундах:
\033[32m gnome-screenshot -w -d 3\033[0m
";ES;fi;;
  9) S=M9;SC;if [[ $cur == enter ]];then R;echo "
    Добавьте эффект снаружи границы скриншота. ЭФФЕКТ может быть:
 'shadow' (добавление тени)
 'border' (добавлением прямоугольного пространства вокруг снимок экрана)
 'vintage' (слегка обесцветить снимок, подкрасить его и добавить прямоугольное пространство вокруг него)
 'none' (без эффекта).
 'none' По умолчанию
 Примечание: Эта опция устарела и считается 'none'
";ES;fi;;
 10) S=M10;SC;if [[ $cur == enter ]];then R;echo " Интерактивно установите опции в диалоге";ES;fi;;
 11) S=M11;SC;if [[ $cur == enter ]];then R;echo " Сохранить скриншот прямо в этот файл";ES;fi;;
 12) S=M12;SC;if [[ $cur == enter ]];then R;echo " X дисплей для использования";ES;fi;;
 13) S=M13;SC;if [[ $cur == enter ]];then R;echo " Показать резюме доступных вариантов. Кроме того, применяются обычные варианты командной строки GTK+. См. выход -помощь для деталей.";ES;fi;;
 14) S=M14;SC;if [[ $cur == enter ]];then R;cat mGnomeScreenshot.txt;ES;fi;;
#
 15) S=M15;SC;if [[ $cur == enter ]];then R;ls -l;exit 0;fi;;
 esac;POS;done
