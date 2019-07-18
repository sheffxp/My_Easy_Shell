#!/bin/bash
export PATH=$PATH:/usr/sbin

#-----------------
# задаем переменные
#-----------------
vers="For Debian"
ver="v0.0.2a"
title="My Easy Shell"
title_full="$title $ver"
filename='myeasyshell.sh'
updpath='https://raw.githubusercontent.com/sheffxp/My_Easy_Shell/master/' #релиз


#Задаём переменную с нужным количеством пробелов, чтобы меню не разъезжалось от смены версии
title_full_len=${#title_full}
title_len=${#title}
space=""
	space_len=$((41-$title_full_len))
	while [ "${#space}" -le $space_len ]
	do
	space=$space" "
	done
space2=""
	space2_len=$((30-$title_len))
	while [ "${#space2}" -le $space2_len ]
	do
	space2=$space2" "
	done

#для рабты с цветами
normal="\033[0m"
green="\033[32m"
red="\033[1;31m"
blue="\033[1;34m"
black="\033[40m"
textcolor=$green
bgcolor=$black

#Определяем данные процессора
cpu_clock=`cat /proc/cpuinfo | grep "cpu MHz" | awk {'print $4'} | sed q`
cpu_clock=$(printf %.0f $cpu_clock)
cpu_model=`cat /proc/cpuinfo | grep "model name" | sed q | sed -e "s/model name//" | sed -e "s/://" | sed -e 's/^[ \t]*//' | sed -e "s/(tm)/™/g" | sed -e "s/(C)/©/g" | sed -e "s/(R)/®/g"`
cpu_cores=`cat /proc/cpuinfo | grep "cpu cores" | awk {'print $4'}`

#определяем сколько RAM
mem_total=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`
swap_total=`cat /proc/meminfo | grep SwapTotal | awk '{print $2}'`
mem_mb=$(($mem_total / 1024))
swap_mb=$(($swap_total / 1024))

#Определяем ОС
osfamily=$( uname -a | awk {'print $6'})
osver2=`cat /etc/debian_version`

#Определяем разрядность ОС
arc=`arch` 
if [ "$arc" = "x86_64" ]; then arc=64 
#В теории возможно обозначение IA-64 и AMD64, но я невстречал 
else arc=32 #Чтобы не перебирать все возможные IA-32, x86, i686, i586 и т.д.
fi 

#определяем версию ядра Linux
kern=`uname -r | sed -e "s/-/ /" | awk {'print $1'}`

#Функция проверки установленного приложения, exist возвращает true если установлена и false, если нет.
installed(){
exist=`dpkg -s $1 | grep Status`
if [ -n "$exist" ] #проверяем что нашли строку со статусом (что строка не пуста)
then
   echo $1" installed" #выводим результат
   exist="true"
else
   echo $1" not installed"
   exist="false"
fi
}

#определяем внешний IP через запрос
whatismyipext()
{
installed wget
if [ $exist = "false" ]; then myinstall wget; fi
ipext=`wget --no-check-certificate -qO- https://2ip.ru/index.php | grep "Ваш IP адрес:" | sed s/.*button\"\>// | sed s_"<"_" "_ | awk {'print $1'}`
}

#вывод меню
menu() 
{ 
my_clear 
echo "$menu" 
echo "Выберите пункт меню:"
}

my_clear() 
{ 
echo -e "$textcolor$bgcolor" 
clear
}

#функция, которая запрашивает только цифру
myread_dig()
{
temp=""
counter=0
echo $temp
while [ "$temp" != "0" ] && [ "$temp" != "1" ] && [ "$temp" != "2" ] && [ "$temp" != "3" ] && [ "$temp" != "4" ] && [ "$temp" != "5" ] && [ "$temp" != "6" ] && [ "$temp" != "7" ] && [ "$temp" != "8" ] && [ "$temp" != "9" ]  #запрашиваем значение, пока не будет цифра
do
if [ $counter -ne 0 ]; then echo -n "Неправильный выбор. Ведите цифру: "; fi
counter=$(($counter+1))
read temp
echo
done
eval $1=$temp
}


#обновление скрипта
updatescript()
{
wget $updpath/$filename -r -N -nd --no-check-certificate
chmod 777 $filename
}


#----------------------------------------------------------------


menu=" 
┌─────────────────────────────────────────────┐ 
│  $title  $ver$space│ 
├───┬─────────────────────────────────────────┤ 
│ 1 │ Информация о системе                    │ 
├───┼─────────────────────────────────────────┤ 
│ 2 │ Работа с ОС                             │ 
├───┼─────────────────────────────────────────┤ 
│ 3 │ Установить панель управления хостингом  │ 
├───┼─────────────────────────────────────────┤ 
│ 4 │ Установка и настройка VPN-сервера       │ 
├───┼─────────────────────────────────────────┤ 
│ 5 │ Работа с Proxy                          │ 
├───┼─────────────────────────────────────────┤ 
│ 6 │ Работа с файлами и программами          │ 
├───┼─────────────────────────────────────────┤ 
│ 7 │ Очистка системы                         │ 
├───┼─────────────────────────────────────────┤ 
│ 8 │ Терминал                                │ 
├───┼─────────────────────────────────────────┤ 
│ 9 │ Обновить $title$space2│ 
├───┼─────────────────────────────────────────┤ 
│ 0 │ Выход                                   │
└───┴─────────────────────────────────────────┘
"
menu1="
● Информация о системе:
│
│ ┌───┬──────────────────────────────────────┐
├─┤ 1 │ Показать общую информацию о системе  │
│ ├───┼──────────────────────────────────────┤
├─┤ 2 │ Провести тест скорости CPU           │
│ ├───┼──────────────────────────────────────┤
├─┤ 3 │ Провести тест скорости диска         │
│ ├───┼──────────────────────────────────────┤
├─┤ 4 │ Описание теста производительности    │
│ ├───┼──────────────────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх               │
  └───┴──────────────────────────────────────┘
"



#-------------------------------------------------------------------

#информация  о системе
showinfo() { 
echo "┌──────────────────────────────────────────────────────────────┐" 
echo "│                    Информация о системе                      │"
echo "└──────────────────────────────────────────────────────────────┘"
echo "  CPU: $cpu_cores x $cpu_clock MHz ($cpu_model)"
if [ $swap_mb -eq 0 ]; then echo " RAM: $mem_mb Mb"; else
echo "                            RAM: $mem_mb Mb (Плюс swap $swap_mb Mb)"; fi
#Определяем диск (делаем это при каждом выводе, т.к. данные меняются)
hdd_total=`df | awk '(NR == 2)' | awk '{print $2}'`
hdd_total_mb=$(($hdd_total / 1024))
hdd_free=`df | awk '(NR == 2)' | awk '{print $4}'`
hdd_free_mb=$(($hdd_free / 1024))
#Определяем uptime системы (делаем это при каждом выводе)
uptime=$(uptime | sed -e "s/ * / /g") #сразу берем аптайм без двойных пробелов
uptime=$(echo "${uptime%,* user*}")
uptime=$(echo "${uptime#*up }")
echo "                            HDD: $hdd_total_mb Mb (свободно $hdd_free_mb Mb)"
echo "                             ОС: $osfamily $osver2"
echo "                 Разрядность ОС: $arc bit"
echo "              Версия ядра Linux: $kern"
echo "                 Аптайм системы: $uptime"

echo "Ваш внешний IP определяется как: $ipext"
}

br()
{
echo ""
}

#-----------------
# Интерфейс
#-----------------
repeat="true"
chosen=0

while [ $repeat = "true" ] #выводим меню, пока не надо выйти
do

#пошёл вывод
if [ $chosen -eq 0 ]; then #выводим меню, только если ещё никуда не заходили
menu
myread_dig pick
else
echo pick
pick=$chosen
fi

case "$pick" in


1) #Информация о системе
chosen=1
my_clear
echo "$title"
echo "$menu1"
myread_dig pick
case "$pick" in
	1) #Показать общую информацию о системе
		my_clear
		showinfo
		br
		echo "Вычисляем Ваш IP на интерфейсе..."
		
		my_clear
		showinfo
		br
		echo "Вычисляем Ваш внешний IP..."
		whatismyipext
		my_clear
		showinfo
		wait
	;;
	2) #Провести тест скорости CPU
		my_clear
	;;
	3) #Провести тест скорости диска
		my_clear
	;;
	4) #Описание теста производительности
		my_clear
		echo "Для теста производительности процессора используется утилита sysbench."
		echo "В ней используется 10000 проходов. Количество потоков устанавливается равным"
		echo "количеству ядер вашего процессора (если не удалось определить количество ядер,"
		echo "используется однопоточный режим), а конечный результат сравнивается с эталонным"
		echo "процессором. За эталонный процессор были взяты виртуальные ядра хостеров Vultr и"
		echo "Digital Ocean, работающие на частоте 2,4 Ghz"
		br
		echo "Для теста скорости диска мы пытаемся записать на диск кусок в 64Кб 16 тысяч раз"
		echo "(общий объём данных 1000 Мб). Тест прогоняем трижды, показываем каждый результат"
		echo "по отдельности, а также среднее значение. Заодно вы сможете оценить насколько"
		echo "сильно \"плавает\" это значение от одного прохода к другому."
		br
		wait
	;;
	0) #Выйти на уровень вверх
     chosen=0
    ;;
    esac


;;




9) #Обновить My Easy Shell
echo "обновляю..."
updatescript
repeat=false
sh $0
exit 0
;;

0)#выход
repeat="false"
;;

*)
echo "Неправильный выбор."
wait
;;
esac
done

echo "Скрипт ожидаемо завершил свою работу."
echo -e "$normal"
clear
