# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис
```json
{
    "info":"Sample JSON output from our service\t",
    "elements":[
        {
            "name":"first",
            "type":"server",
            "ip":"71.78.71.75"
        },
        {
            "name":"second",
            "type":"proxy",
            "ip":"71.78.22.43"
        }
    ]
}
```
## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import requests
import socket
import json
import yaml
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
    with open('svcchk.json', 'w') as j:
        for key, val in prev_chk.items():
            j.write(json.dumps({key: val})+'\n')

    with open('svcchk.yaml', 'w') as y:
        tmp_list = list()
        for key, val in prev_chk.items():
            tmp_list.append({key: val})
        y.write(yaml.dump(tmp_list))

    sleep(3)
```

### Вывод скрипта при запуске при тестировании:
```
drive.google.com - 173.194.222.194
mail.google.com - 64.233.165.83
google.com - 74.125.131.101
<...>
drive.google.com - 173.194.222.194
[ERROR] mail.google.com IP mismatch: 64.233.165.83 64.233.165.17
google.com - 74.125.131.101
drive.google.com - 173.194.222.194
mail.google.com - 64.233.165.17
google.com - 74.125.131.101
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"drive.google.com": "173.194.222.194"}
{"mail.google.com": "64.233.165.17"}
{"google.com": "74.125.131.101"}

```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
- drive.google.com: 173.194.222.194
- mail.google.com: 64.233.165.17
- google.com: 74.125.131.101

```
