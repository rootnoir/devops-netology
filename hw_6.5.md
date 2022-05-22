# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

```shell
[elastics@42d86ca1f07a elasticsearch]$ grep -vP '^\s*(#|$)' /opt/elasticsearch/config/elasticsearch.yml
cluster.name: elasticsearch-netology
node.name: netology_test
path.data: /var/lib/elasticsearch/data
path.logs: /var/lib/elasticsearch/logs
xpack.security.enabled: true
xpack.security.enrollment.enabled: true
xpack.security.http.ssl:
  enabled: true
  keystore.path: certs/http.p12
xpack.security.transport.ssl:
  enabled: true
  verification_mode: certificate
  keystore.path: certs/transport.p12
  truststore.path: certs/transport.p12
cluster.initial_master_nodes: ["netology_test"]
http.host: [_local_, _site_]

```
В ответе приведите:
- текст Dockerfile манифеста
```docker
FROM centos:7

MAINTAINER rootnoir <github.com/rootnoir>

EXPOSE 9200
EXPOSE 9300

ENV ES_HOME=/opt/elasticsearch \
    ES_PATH_CONF=/opt/elasticsearch/config

RUN yum install -y --setopt=tsflags=nodocs perl-Digest-SHA wget \
    && hia_proxy=173.249.57.9:443 \
    && export http_proxy=http://${hia_proxy} \
    && export https_proxy=https://${hia_proxy} \
    && wget --no-check-certificate https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.3-linux-x86_64.tar.gz \
    && wget --no-check-certificate https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.3-linux-x86_64.tar.gz.sha512 \
    && export http_proxy='' \
    && export https_proxy='' \
    && shasum -a 512 -c elasticsearch-8.1.3-linux-x86_64.tar.gz.sha512 \
    && tar -xzf elasticsearch-8.1.3-linux-x86_64.tar.gz \
    && mv ./elasticsearch-8.1.3 ${ES_HOME} \
    && rm -f elasticsearch-8.1.3-linux-x86_64.tar.gz.sha512 \
    && rm -f elasticsearch-8.1.3-linux-x86_64.tar.gz \
    && mkdir -p /var/log/elasticsearch \
    && mkdir -p /opt/el-data

RUN adduser -u 1000 elastics \
    && chown -R elastics:elastics ${ES_HOME} \
    && mkdir -p /var/lib/elasticsearch/data \
    && mkdir -p /var/lib/elasticsearch/logs \
    && chown -R elastics:elastics /var/lib/elasticsearch/data \
    && chown -R elastics:elastics /var/lib/elasticsearch/logs

WORKDIR ${ES_HOME}
USER 1000
CMD ["sh", "-c", "${ES_HOME}/bin/elasticsearch"]


```
- ссылку на образ в репозитории dockerhub
https://hub.docker.com/layers/netology/rootnoir/netology/elasticsearch-8.1.3-centos7/images/sha256-33c487dac53481ecc5237335668dc216b9a0b927853523cf02518055f89b84af?context=repo&tab=layers


- ответ `elasticsearch` на запрос пути `/` в json виде
```
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch-netology",
  "cluster_uuid" : "Jww8TqGTSgO46yeVGjaJsA",
  "version" : {
    "number" : "8.1.3",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "39afaa3c0fe7db4869a161985e240bd7182d7a07",
    "build_date" : "2022-04-19T08:13:25.444693396Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}

```
Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X PUT "https://localhost:9200/ind-1" -H 'Content-Type: application/json' -d'{"settings": {"number_of_shards": 1, "number_of_replicas": 0}}'
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X PUT "https://localhost:9200/ind-2" -H 'Content-Type: application/json' -d'{"settings": {"number_of_shards": 2, "number_of_replicas": 1}}'
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X PUT "https://localhost:9200/ind-3" -H 'Content-Type: application/json' -d'{"settings": {"number_of_shards": 4, "number_of_replicas": 2}}'

```
Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
```
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X GET "https://localhost:9200/_cat/indices?&pretty"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 tsU7RCD8QqicxE68rfUDrA   1   0          0            0       225b           225b
yellow open   ind-3 R1p43ElvR4-UyKwFbCLJTQ   4   2          0            0       900b           900b
yellow open   ind-2 GQYawtzfRLmR8NAUg7Enjg   2   1          0            0       450b           450b

```
Получите состояние кластера `elasticsearch`, используя API.
```
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X GET "https://localhost:9200/_cluster/health?&pretty"
{
  "cluster_name" : "elasticsearch-netology",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 9,
  "active_shards" : 9,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 47.368421052631575
}

```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

- т.к. все шарды доступны, а реплики не все.

Удалите все индексы.
```
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X DELETE "https://localhost:9200/ind-1"                                                                  
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X DELETE "https://localhost:9200/ind-2"
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X DELETE "https://localhost:9200/ind-3"
```

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.
```shell
mkdir -p /opt/elasticsearch/snapshots
```
Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

- запрос:
  - предварительно прописать в конфиг значение для `path.repo`
```shell
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X PUT "https://localhost:9200/_snapshot/netology_backup" -H 'Content-Type: application/json' -d'{"type": "fs", "settings": {"location": "/opt/elasticsearch/snapshots/"}}'

```
- ответ:
```
{"acknowledged":true}
```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```shell
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X GET "https://localhost:9200/_cat/indices?&pretty"
green open test uiEEA12OTDq1a3UMf8gFzg 1 0 0 0 225b 225b
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

- request:
```shell
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X PUT "https://localhost:9200/_snapshot/netology_backup/my-snapshot"                                   

```
- responce:
```
{"accepted":true}
```

**Приведите в ответе** список файлов в директории со `snapshot`ами.
```shell
ls -laR /opt/elasticsearch/snapshots/
/opt/elasticsearch/snapshots/:
total 48
drwxrwxr-x 3 elastics elastics  4096 May 22 13:02 .
drwxr-xr-x 1 elastics elastics  4096 May 22 12:27 ..
-rw-r--r-- 1 elastics elastics  1096 May 22 13:02 index-2
-rw-r--r-- 1 elastics elastics     8 May 22 13:02 index.latest
drwxr-xr-x 5 elastics elastics  4096 May 22 13:02 indices
-rw-r--r-- 1 elastics elastics 18281 May 22 13:02 meta-DocKm2FVRa2oKYRxTEQbtA.dat
-rw-r--r-- 1 elastics elastics   388 May 22 13:02 snap-DocKm2FVRa2oKYRxTEQbtA.dat

/opt/elasticsearch/snapshots/indices:
total 20
drwxr-xr-x 3 elastics elastics 4096 May 22 13:02 -yGXr9f-Rc-qEQBGaGutGQ
drwxr-xr-x 5 elastics elastics 4096 May 22 13:02 .
drwxrwxr-x 3 elastics elastics 4096 May 22 13:02 ..
drwxr-xr-x 3 elastics elastics 4096 May 22 13:02 PBgZSnJ2QLybldPgAKrF1g
drwxr-xr-x 3 elastics elastics 4096 May 22 13:02 drdZpL35RharNX-tSUHuOA

/opt/elasticsearch/snapshots/indices/-yGXr9f-Rc-qEQBGaGutGQ:
total 16
drwxr-xr-x 3 elastics elastics 4096 May 22 13:02 .
drwxr-xr-x 5 elastics elastics 4096 May 22 13:02 ..
drwxr-xr-x 2 elastics elastics 4096 May 22 13:02 0
-rw-r--r-- 1 elastics elastics 1240 May 22 13:02 meta-a7Xc64ABxOM63Ay5k9Q-.dat

/opt/elasticsearch/snapshots/indices/-yGXr9f-Rc-qEQBGaGutGQ/0:
total 24
drwxr-xr-x 2 elastics elastics 4096 May 22 13:02 .
drwxr-xr-x 3 elastics elastics 4096 May 22 13:02 ..
-rw-r--r-- 1 elastics elastics 2937 May 22 13:02 __-CUEnOWpQ-eXrhfWv6UNzA
-rw-r--r-- 1 elastics elastics  405 May 22 13:02 __C3zuLe3USY-UD4siPzVd0A
-rw-r--r-- 1 elastics elastics  831 May 22 13:02 index-9a74i8dySjyehg0b6H-wIQ
-rw-r--r-- 1 elastics elastics  850 May 22 13:02 snap-DocKm2FVRa2oKYRxTEQbtA.dat

/opt/elasticsearch/snapshots/indices/PBgZSnJ2QLybldPgAKrF1g:
total 16
drwxr-xr-x 3 elastics elastics 4096 May 22 13:02 .
drwxr-xr-x 5 elastics elastics 4096 May 22 13:02 ..
drwxr-xr-x 2 elastics elastics 4096 May 22 13:02 0
-rw-r--r-- 1 elastics elastics  400 May 22 13:02 meta-arXc64ABxOM63Ay5k9Q3.dat

/opt/elasticsearch/snapshots/indices/PBgZSnJ2QLybldPgAKrF1g/0:
total 16
drwxr-xr-x 2 elastics elastics 4096 May 22 13:02 .
drwxr-xr-x 3 elastics elastics 4096 May 22 13:02 ..
-rw-r--r-- 1 elastics elastics  443 May 22 13:02 index-q0BZZAQHRYW9u4d80OLcKQ
-rw-r--r-- 1 elastics elastics  460 May 22 13:02 snap-DocKm2FVRa2oKYRxTEQbtA.dat

/opt/elasticsearch/snapshots/indices/drdZpL35RharNX-tSUHuOA:
total 16
drwxr-xr-x 3 elastics elastics 4096 May 22 13:02 .
drwxr-xr-x 5 elastics elastics 4096 May 22 13:02 ..
drwxr-xr-x 2 elastics elastics 4096 May 22 13:02 0
-rw-r--r-- 1 elastics elastics  516 May 22 13:02 meta-bLXc64ABxOM63Ay5k9RJ.dat

/opt/elasticsearch/snapshots/indices/drdZpL35RharNX-tSUHuOA/0:
total 39948
drwxr-xr-x 2 elastics elastics    4096 May 22 13:02 .
drwxr-xr-x 3 elastics elastics    4096 May 22 13:02 ..
-rw-r--r-- 1 elastics elastics  460776 May 22 13:02 __5dYiiCPkQLiYVzJjODFJRg
-rw-r--r-- 1 elastics elastics     405 May 22 13:02 __9EsgU8f_SZ-EOzfc2gSDAw
-rw-r--r-- 1 elastics elastics 8429417 May 22 13:02 __9kLVHUoIT2mCbnIs-HKTLw
-rw-r--r-- 1 elastics elastics     405 May 22 13:02 __Ak7QKhwdQyCgatQMS2YaNw
-rw-r--r-- 1 elastics elastics 7342854 May 22 13:02 __BS0-NWGZTX-N48tPP59idQ
-rw-r--r-- 1 elastics elastics  635767 May 22 13:02 __BmPhl0QSSPiDhvtT7ynxuw
-rw-r--r-- 1 elastics elastics     405 May 22 13:02 __D9XLaNEeRnW6iu7aT68vNg
-rw-r--r-- 1 elastics elastics 3149414 May 22 13:02 __T8-sObjdS_WhR2GrjN20ww
-rw-r--r-- 1 elastics elastics     405 May 22 13:02 __U77o3BbgQ4u0SS9FXq7brQ
-rw-r--r-- 1 elastics elastics     405 May 22 13:02 __UF3WoDjJSS6zRTKarS-PlA
-rw-r--r-- 1 elastics elastics     405 May 22 13:02 __UNak2OK9QoW5q-J1fB2flA
-rw-r--r-- 1 elastics elastics     405 May 22 13:02 __Vfc3mqi4Tmihg0esNRi0HQ
-rw-r--r-- 1 elastics elastics     405 May 22 13:02 __XOd7RO1dTEC5e7WIfZvCHg
-rw-r--r-- 1 elastics elastics     405 May 22 13:02 __Y3n6JpBHQHu-G98LqUoQ0A
-rw-r--r-- 1 elastics elastics 5238858 May 22 13:02 ___P8uX12kT3qQj_N5FqEQDQ
-rw-r--r-- 1 elastics elastics     405 May 22 13:02 ___WHY8gSuQ6KLtJmIyrsZLQ
-rw-r--r-- 1 elastics elastics 2145484 May 22 13:02 __cz-SoKmQSreblAh4KmEyfg
-rw-r--r-- 1 elastics elastics 2108866 May 22 13:02 __rrLCq4GmRYy0VibHsdTzyA
-rw-r--r-- 1 elastics elastics 2033641 May 22 13:02 __vU-9RRozSXm5JofqNUTAWg
-rw-r--r-- 1 elastics elastics 8230201 May 22 13:02 __xVAKo8WwSMiU3J9tSwXXkg
-rw-r--r-- 1 elastics elastics 1051150 May 22 13:02 __xrMnKMTnSVKPap0N2nvuBA
-rw-r--r-- 1 elastics elastics     405 May 22 13:02 __yhgrgq7ZQbekWwm8VUK0_Q
-rw-r--r-- 1 elastics elastics    2492 May 22 13:02 index-G1EVC7B_RcCmN2N11GhcdQ
-rw-r--r-- 1 elastics elastics    2406 May 22 13:02 snap-DocKm2FVRa2oKYRxTEQbtA.dat

```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.
```shell
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X DELETE "https://localhost:9200/test"
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X PUT "https://localhost:9200/test-2" -H 'Content-Type: application/json' -d'{"settings": {"number_of_shards": 1, "number_of_replicas": 0}}'

curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X GET "https://localhost:9200/_cat/indices?&pretty"
green open test-2 tLR06ySoRGu1NOjSizi0Ow 1 0 0 0 225b 225b

```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.
- request:
```shell
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X POST "https://localhost:9200/_snapshot/netology_backup/my-snapshot/_restore"
```
- responce:
```
{"accepted":true}
```

```shell
curl --cacert /opt/elasticsearch/config/certs/http_ca.crt -u elastic:8bBul3rjDeSIsOLD1C1x -X GET "https://localhost:9200/_cat/indices?&pretty"
green open test-2 tLR06ySoRGu1NOjSizi0Ow 1 0 0 0 225b 225b
green open test   CJpgkV3nTeOy92j994VPRw 1 0 0 0 225b 225b

```

---
