# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"

1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
- В ответе укажите полученный HTTP код, что он означает?
```shell
vagrant@vagrant:~$ telnet stackoverflow.com 80
Trying 151.101.1.69...
Connected to stackoverflow.com.
Escape character is '^]'.
GET /questions HTTP/1.0
HOST: stackoverflow.com

HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: fe55eb5b-486e-42c7-a4fa-31c5181b3707
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Thu, 09 Dec 2021 19:05:59 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-fra19174-FRA
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1639076760.506355,VS0,VE92
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=1c207bdc-7bde-d019-a9a5-40407464fdc3; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

Connection closed by foreign host.
```
- 301 - Moved Permanently
- location: https://stackoverflow.com/questions
2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код.
```
200
```
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
```
49 requests
53.3 kB transferred
1.9 MB resources
Finish: 940 ms
DOMContentLoaded: 760 ms
Load: 929 ms
```
дольше всех шла загрузка:
```
stackoverflow.com	200	document	stackoverflow.com/	52.6 kB	362 ms
```
- приложите скриншот консоли браузера в ответ.
```
Request URL: http://stackoverflow.com/
Request Method: GET
Status Code: 200 Temporary Redirect
Referrer Policy: strict-origin-when-cross-origin
accept-ranges: bytes
cache-control: private
content-encoding: gzip
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
content-type: text/html; charset=utf-8
date: Thu, 09 Dec 2021 19:37:46 GMT
feature-policy: microphone 'none'; speaker 'none'
strict-transport-security: max-age=15552000
vary: Accept-Encoding,Fastly-SSL
via: 1.1 varnish
x-cache: MISS
x-cache-hits: 0
x-dns-prefetch-control: off
x-frame-options: SAMEORIGIN
x-request-guid: 548320d1-3e92-4fcf-ba84-e5796e8e4288
x-served-by: cache-fra19120-FRA
x-timer: S1639078666.309572,VS0,VE95
:authority: stackoverflow.com
:method: GET
:path: /
:scheme: https
accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
accept-encoding: gzip, deflate, br
accept-language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7
cookie: _ym_d=1612638996; _ym_uid=1612638996893390060; prov=0d42dd6f-10d8-a756-f2d5-51dbb6e1c093; _ga=GA1.2.2003397536.1635880380
sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"
sec-ch-ua-mobile: ?0
sec-ch-ua-platform: "Windows"
sec-fetch-dest: document
sec-fetch-mode: navigate
sec-fetch-site: none
sec-fetch-user: ?1
upgrade-insecure-requests: 1
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.93 Safari/537.36
```
3. Какой IP адрес у вас в интернете?
```shell
vagrant@vagrant:~$ curl ipinfo.io/ip
```
4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`
```
descr:          Moscow Local Telephone Network (OAO MGTS)
descr:          Moscow, Russia
origin:         AS25513
mnt-by:         MGTS-USPD-MNT
```
5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`
```shell
vagrant@vagrant:~$ sudo traceroute -An 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  10.0.2.2 [*]  0.345 ms  0.401 ms  0.348 ms
 2  * * *
 3  * * *
 4  * * *
 5  * * *
 6  * * *
 7  * * *
 8  * * *
 9  * * *
10  * * *
11  * * *
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * *
23  * * *
24  * * *
25  * * *
26  * * *
27  * * *
28  * * *
29  * * *
30  * * *
```
- traceroute не смог определить AS из VM в Vagrant
6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?
```shell
                             My traceroute  [v0.93]
vagrant (10.0.2.15)                                        2021-12-09T20:20:20+0000
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                         Packets               Pings
 Host                                    Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. AS???    10.0.2.2                     0.0%   211    0.5   0.9   0.3  15.6   1.1
 2. AS???    192.168.2.1                  0.0%   211    1.7   2.2   1.4  68.3   4.8
 3. AS???    100.68.0.1                   0.0%   211   12.0   3.8   3.0  54.0   3.8
 4. AS8359   212.188.1.106                0.0%   211    4.0   5.1   3.5  60.8   4.7
 5. AS8359   212.188.1.105                0.0%   211    4.4   4.5   3.4  53.7   4.0
 6. AS8359   212.188.56.13               32.7%   211    7.8   7.3   5.0  74.7   6.3
 7. AS8359   195.34.50.74                 0.0%   211    5.8   5.9   4.7  72.7   5.1
 8. AS8359   212.188.29.82                0.0%   211    5.4   5.7   4.1  37.6   3.5
 9. AS15169  108.170.250.146              0.5%   211    5.3  10.0   4.2 104.8  11.9
10. AS15169  209.85.249.158              51.4%   211   20.8  22.3  19.6  75.2   7.0
11. AS15169  216.239.43.20                0.0%   211   22.9  26.2  22.6  74.6   8.4
12. AS15169  142.250.209.25               0.0%   211   23.5  24.4  23.1  67.6   3.3
13. (waiting for reply)
14. (waiting for reply)
15. (waiting for reply)
16. (waiting for reply)
17. (waiting for reply)
18. (waiting for reply)
19. AS15169  8.8.8.8                      94.7%   210   21.7  22.5  20.4  27.0   2.4
```
- участок 11 - наибольшая задержка (столбец Avg)
7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`
```shell
vagrant@vagrant:~$ dig +trace @8.8.8.8 dns.google

; <<>> DiG 9.16.1-Ubuntu <<>> +trace @8.8.8.8 dns.google
; (1 server found)
;; global options: +cmd
.                       57592   IN      NS      a.root-servers.net.
.                       57592   IN      NS      h.root-servers.net.
.                       57592   IN      NS      k.root-servers.net.
.                       57592   IN      NS      l.root-servers.net.
.                       57592   IN      NS      e.root-servers.net.
.                       57592   IN      NS      d.root-servers.net.
.                       57592   IN      NS      f.root-servers.net.
.                       57592   IN      NS      b.root-servers.net.
.                       57592   IN      NS      g.root-servers.net.
.                       57592   IN      NS      i.root-servers.net.
.                       57592   IN      NS      c.root-servers.net.
.                       57592   IN      NS      j.root-servers.net.
.                       57592   IN      NS      m.root-servers.net.
.                       57592   IN      RRSIG   NS 8 0 518400 20211221170000 20211208160000 14748 . STJFmMkv7xJN+HC4h4OkpfwBdBdF7ChqeSr7TNhxm7MpjwNAMd6I7z/+ PQwnHEx0GUSQBWGBgktxpVSRYXk2AiqAaEOqWbLxxE6TfNO1CCFZwYKU jY+8BSo5p1JCtwQunLdkFOFNWw6TbV+g3FKKdt+AhYYH7ptjAssPFOtb b52ze73wfrB8fjbVFoFhk5tKSY8WAq0+zCsU/KGe8I57oQGuHh+Gy1qG mh/+B0DBY5LDPtD0s1Mi2IzTy1k9TUqm3EoataW12k51Q2wPfaO4seO8 wfBVz/9q1ehxxNLsN2ylzfKwTx7FnTVxumZAD/pQNDD/EG9m2HIgusXS 7w0lag==
;; Received 525 bytes from 8.8.8.8#53(8.8.8.8) in 24 ms

google.                 172800  IN      NS      ns-tld1.charlestonroadregistry.com.
google.                 172800  IN      NS      ns-tld2.charlestonroadregistry.com.
google.                 172800  IN      NS      ns-tld3.charlestonroadregistry.com.
google.                 172800  IN      NS      ns-tld4.charlestonroadregistry.com.
google.                 172800  IN      NS      ns-tld5.charlestonroadregistry.com.
google.                 86400   IN      DS      6125 8 2 80F8B78D23107153578BAD3800E9543500474E5C30C29698B40A3DB2 3ED9DA9F
google.                 86400   IN      RRSIG   DS 8 1 86400 20211222170000 20211209160000 14748 . Vq2WFl17migaRH2L5l92yD3hdGmtTTKRu5oK23+hS9u1vBsIIOJfo3iK Ef2AkifVY9EFwDJuKVO0D/CAU1FmbDKBvpYcHoJKMT07cEQsoyyzdhXu PRhiJOIBCLOi2iZv4metzUKDuhtCVixlZjyNjbsd2SaO0j+vEe94feGz kJQ1I2BBoccLqJYvT+qF3q0seNyOWy2Jgra+B/npMLGFY1ekJY3ouZg7 ecs9nfAXHkWnqKqnjMLX5S3xYy5job7ThOYKJxnrBaZ+KuzYgcmgkigb DeHcyKzwUCiFSMpjPcmIT6zBAEL18+C0QyzxDG18JATwvYQ4oeklVu3Z 7qa2QQ==
;; Received 730 bytes from 192.203.230.10#53(e.root-servers.net) in 8 ms

dns.google.             10800   IN      NS      ns3.zdns.google.
dns.google.             10800   IN      NS      ns4.zdns.google.
dns.google.             10800   IN      NS      ns1.zdns.google.
dns.google.             10800   IN      NS      ns2.zdns.google.
dns.google.             3600    IN      DS      56044 8 2 1B0A7E90AA6B1AC65AA5B573EFC44ABF6CB2559444251B997103D2E4 0C351B08
dns.google.             3600    IN      RRSIG   DS 8 2 3600 20211229191018 20211207191018 44925 google. dIBP1HqZEqFu9MVTeX1By5oNiRH7Y294ewubQW6VTa9r4CamMzgVA7Py h1yfqtO47xw3VPclaleT1V5vxzzPMQQg2Q/BZvL6TnqWSUreNItCCuHU bSGklBDfTn3VdBkf5+0OJ2hs9Q515BSyRSAp0MJEB75EFmE9aWAZXdAh gnU=
;; Received 506 bytes from 216.239.36.105#53(ns-tld3.charlestonroadregistry.com) in 24 ms

dns.google.             900     IN      A       8.8.8.8
dns.google.             900     IN      A       8.8.4.4
dns.google.             900     IN      RRSIG   A 8 2 900 20211230174753 20211208174753 1773 dns.google. j5LsLau/WYQtaTQTfx+NrLGMS9xPRdSkCidlzpyODAhtax67wKmC/nWs MSVjvlPnkcPU+OwsACVQBfm877GM0WoJF6c5P5IFm+Z/YFsiAS/NKTwk bzFZ4iSSB2vVAwzfd+hSNqFaISg54c81sF2EBW0zchXw3lQ1pU0Dt3Wb ou4=
;; Received 241 bytes from 216.239.32.114#53(ns1.zdns.google) in 52 ms

```
- сервера, отвечающие за dns.google
  - ns1.zdns.google.
  - ns2.zdns.google.
  - ns3.zdns.google.
  - ns4.zdns.google.
- A записи:
  - 8.8.8.8
  - 8.8.4.4
8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`
```shell
vagrant@vagrant:~$ dig -x 8.8.8.8

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.8.8
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 57021
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;8.8.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.   7105    IN      PTR     dns.google.

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Thu Dec 09 20:37:59 UTC 2021
;; MSG SIZE  rcvd: 73

vagrant@vagrant:~$ dig -x 8.8.4.4

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.4.4
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 28252
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;4.4.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
4.4.8.8.in-addr.arpa.   7074    IN      PTR     dns.google.

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Thu Dec 09 20:38:06 UTC 2021
;; MSG SIZE  rcvd: 73

```
- dns.google

В качестве ответов на вопросы можно приложите лог выполнения команд в консоли или скриншот полученных результатов.
