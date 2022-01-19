### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-01-bash/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

---


# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательная задача 1

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная | Значение | Обоснование                                                                                                                         |
|------------|----------|-------------------------------------------------------------------------------------------------------------------------------------|
| `c`        | a+b      | т.к. присвоено строковое значение 'a+b'                                                                                             |
| `d`        | 1+2      | т.к. скобочек нет, то все значения будут неявно типизированы в строки.. итог: строка '1' следом символ '+' затем строка '2'         |
| `e`        | 3        | т.к. скобочки - наше всё. переменные $a и $b будут типизированы как числа, а значением $e станет результат арифметической операции. |


## Обязательная задача 2
На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```bash
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
```

### Решение:
```bash
#!/usr/bin/env bash

while ((1==1))
do
	curl https://localhost:4757
	if (($? != 0))
	then
	    date > curl.log
	else 
	    break
	fi
done
```
Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:
```bash
#!/usr/bin/env bash

ips=(192.168.0.1 173.194.222.113 87.250.250.242)

''>result.log
for ip in ${ips[@]}
do
  i=0
  while (($i < 5))
  do
    nc -zvw3 $ip 80 >> result.log 2>&1
    let 'i+=1'
  done
done 
```
####result.log
```
nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 87.250.250.242 80 port [tcp/http] succeeded!
Connection to 87.250.250.242 80 port [tcp/http] succeeded!
Connection to 87.250.250.242 80 port [tcp/http] succeeded!
Connection to 87.250.250.242 80 port [tcp/http] succeeded!
Connection to 87.250.250.242 80 port [tcp/http] succeeded!
```

## Обязательная задача 3
Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:
```bash
#!/usr/bin/env bash

ips=(173.194.222.113 192.168.0.1 87.250.250.242)

:>result.log
while ((1==1))
do
    for ip in ${ips[@]}
    do
      i=0
      while (($i < 5))
      do
        nc -zvw3 $ip 80 >> result.log 2>&1
        [[ $? -eq 1 ]] && echo $ip > error.log && exit 1
        let 'i+=1'
      done
    done
done 
```

####result.log
```
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
Connection to 173.194.222.113 80 port [tcp/http] succeeded!
nc: connect to 192.168.0.1 port 80 (tcp) timed out: Operation now in progress
```
####error.log
```
192.168.0.1
```