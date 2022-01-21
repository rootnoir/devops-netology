# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ                                                         |
| ------------- |---------------------------------------------------------------|
| Какое значение будет присвоено переменной `c`?  | TypeError: unsupported operand type(s) for +: 'int' and 'str' |
| Как получить для переменной `c` значение 12?  | c = str(a) + b                                                |
| Как получить для переменной `c` значение 3?  | c = a + int(b)                                                |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

mypath = os.path.expanduser("~/netology/sysadm-homeworks")
bash_command = [ ' '.join(["cd", mypath]), "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(os.path.join(mypath, prepare_result))

```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ ./script.py
/home/vagrant/netology/sysadm-homeworks/01-intro-01/README.md
/home/vagrant/netology/sysadm-homeworks/04-script-02-py/README.md
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

path_arg = sys.argv[1]
if path_arg:
    if path_arg[:2] == '~/':
        mypath = os.path.expanduser(path_arg)
    else:
        mypath = os.path.abspath(path_arg)
    if os.path.isdir(mypath):
        bash_command = [ ' '.join(["cd", mypath]), "git status 2>&1"]
        result_os = os.popen(' && '.join(bash_command)).read()
        if 'not a git repository' not in result_os:
            for result in result_os.split('\n'):
                if result.find('modified') != -1:
                    prepare_result = result.replace('\tmodified:   ', '')
                    print(os.path.join(mypath, prepare_result))
        else:
            print('not a git repository')
    else:
        print('not a directory or invalid path')
else:
    print("empty directory parameter")

```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ ./script_agrs.py '~/netology/sysadm-homeworks'
/home/noir/netology/sysadm-homeworks/01-intro-01/README.md
/home/noir/netology/sysadm-homeworks/04-script-02-py/README.md
vagrant@vagrant:~$ ./script_agrs.py 'netology/sysadm-homeworks'
/home/noir/netology/sysadm-homeworks/01-intro-01/README.md
/home/noir/netology/sysadm-homeworks/04-script-02-py/README.md
vagrant@vagrant:~$ ./script_agrs.py './netology/sysadm-homeworks'
/home/noir/netology/sysadm-homeworks/01-intro-01/README.md
/home/noir/netology/sysadm-homeworks/04-script-02-py/README.md
vagrant@vagrant:~$ ./script_agrs.py '/netology/sysadm-homeworks'
not a directory or invalid path
vagrant@vagrant:~$ ./script_agrs.py '~/netology'
not a git repository
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import requests
import socket
from time import sleep

services = ('drive.google.com', 'mail.google.com', 'google.com')
prev_chk = dict()

while True:
    for service in services:
        response = requests.get('http://'+service, verify=True, timeout=3)
        if response.status_code == 200:
            ip = socket.gethostbyname(service)
            if prev_chk.get(service) is None:
                prev_chk.update({service: ip})
                print(' '.join([service, '-', ip]))
            elif prev_chk.get(service) == ip:
                print(' '.join([service, '-', ip]))
            else:
                print('[ERROR] {service} IP mismatch: {prev_ip} {ip}'.format(
                                                                  service=service,
                                                                  prev_ip=prev_chk.get(service),
                                                                  ip=ip)
                    )
                prev_chk.update({service: ip})
    sleep(3)

```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ ./chk_svcs.py
drive.google.com - 173.194.221.194
mail.google.com - 173.194.222.83
google.com - 108.177.14.138
<...>
drive.google.com - 173.194.221.194
mail.google.com - 173.194.222.83
google.com - 108.177.14.138
drive.google.com - 173.194.221.194
mail.google.com - 173.194.222.83
google.com - 108.177.14.138
drive.google.com - 173.194.221.194
[ERROR] mail.google.com IP mismatch: 173.194.222.83 173.194.222.18
google.com - 108.177.14.138
drive.google.com - 173.194.221.194
mail.google.com - 173.194.222.18
[ERROR] google.com IP mismatch: 108.177.14.138 64.233.162.138
drive.google.com - 173.194.221.194
mail.google.com - 173.194.222.18
google.com - 64.233.162.138
^CTraceback (most recent call last):
  File "./chk_svcs.py", line 26, in <module>
    sleep(3)
KeyboardInterrupt
```
