# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

- установка:
- https://github.com/prometheus/node_exporter/tree/master/examples/systemd
```shell
vagrant@vagrant:~$ cd /usr/local/src
vagrant@vagrant:/usr/local/src$ sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_expo
rter-1.3.1.linux-amd64.tar.gz
vagrant@vagrant:/usr/local/src$ sudo tar -xf node_exporter-1.3.1.linux-amd64.tar.gz
vagrant@vagrant:/usr/local/src$ sudo mv node_exporter-1.3.1.linux-amd64/node_exporter /usr/sbin/
vagrant@vagrant:/usr/local/src$ sudo rm -rf ./*
vagrant@vagrant:/usr/local/src$ sudo mkdir -p /etc/sysconfig/
vagrant@vagrant:/usr/local/src$ echo 'OPTIONS="--collector.textfile.directory /var/lib/node_exporter/textfile_collector"' | sudo tee /etc/sysconfig/node_exporter
vagrant@vagrant:/usr/local/src$ cat << EOF | sudo tee /etc/systemd/system/node-exporter.service
[Unit]
Description=Node Exporter

[Service]
User=node_exporter
EnvironmentFile=/etc/sysconfig/node_exporter
ExecStart=/usr/sbin/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target

EOF
vagrant@vagrant:/usr/local/src$ sudo useradd node_exporter -s /sbin/nologin
vagrant@vagrant:/usr/local/src$ sudo chown node_exporter. /etc/sysconfig/node_exporter
vagrant@vagrant:/usr/local/src$ sudo systemctl daemon-reload
vagrant@vagrant:/usr/local/src$ sudo systemctl enable --now node-exporter
vagrant@vagrant:/usr/local/src$ sudo systemctl status node-exporter
? node-exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node-exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2021-12-07 19:57:37 UTC; 2s ago
   Main PID: 1254 (node_exporter)
      Tasks: 5 (limit: 1071)
     Memory: 2.3M
     CGroup: /system.slice/node-exporter.service
             └─1254 /usr/sbin/node_exporter

Dec 07 19:57:37 vagrant node_exporter[1254]: ts=2021-12-07T19:57:37.407Z caller=node_exporter.go:115 level=info collect>
Dec 07 19:57:37 vagrant node_exporter[1254]: ts=2021-12-07T19:57:37.407Z caller=node_exporter.go:115 level=info collect>
Dec 07 19:57:37 vagrant node_exporter[1254]: ts=2021-12-07T19:57:37.407Z caller=node_exporter.go:115 level=info collect>
Dec 07 19:57:37 vagrant node_exporter[1254]: ts=2021-12-07T19:57:37.407Z caller=node_exporter.go:115 level=info collect>
Dec 07 19:57:37 vagrant node_exporter[1254]: ts=2021-12-07T19:57:37.407Z caller=node_exporter.go:115 level=info collect>
Dec 07 19:57:37 vagrant node_exporter[1254]: ts=2021-12-07T19:57:37.407Z caller=node_exporter.go:115 level=info collect>
Dec 07 19:57:37 vagrant node_exporter[1254]: ts=2021-12-07T19:57:37.407Z caller=node_exporter.go:115 level=info collect>
Dec 07 19:57:37 vagrant node_exporter[1254]: ts=2021-12-07T19:57:37.408Z caller=node_exporter.go:115 level=info collect>
Dec 07 19:57:37 vagrant node_exporter[1254]: ts=2021-12-07T19:57:37.408Z caller=node_exporter.go:199 level=info msg="Li>
Dec 07 19:57:37 vagrant node_exporter[1254]: ts=2021-12-07T19:57:37.408Z caller=tls_config.go:195 level=info msg="TLS i>
```
- проверка:
- localhost с Windows
```commandline
PS C:\> Invoke-WebRequest -Uri http://localhost:9100/metrics


StatusCode        : 200
StatusDescription : OK
Content           : # HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles.
                    # TYPE go_gc_duration_seconds summary
                    go_gc_duration_seconds{quantile="0"} 0.002223275
                    go_gc_duration_second...
RawContent        : HTTP/1.1 200 OK
                    Transfer-Encoding: chunked
                    Content-Type: text/plain; version=0.0.4; charset=utf-8
                    Date: Tue, 07 Dec 2021 19:36:23 GMT

                    # HELP go_gc_duration_seconds A summary of the pause duratio...
Forms             : {}
Headers           : {[Transfer-Encoding, chunked], [Content-Type, text/plain; version=0.0.4; charset=utf-8], [Date, Tue, 07 Dec 2021 19:36:23 GMT]}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : System.__ComObject
RawContentLength  : 58978


PS C:\> (Invoke-WebRequest -Uri http://localhost:9100/metrics).Content
# HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 4.4832e-05
go_gc_duration_seconds{quantile="0.25"} 4.4832e-05
go_gc_duration_seconds{quantile="0.5"} 0.002223275
go_gc_duration_seconds{quantile="0.75"} 0.002223275
go_gc_duration_seconds{quantile="1"} 0.002223275
go_gc_duration_seconds_sum 0.002268107
go_gc_duration_seconds_count 2
# HELP go_goroutines Number of goroutines that currently exist.
# TYPE go_goroutines gauge
go_goroutines 10
# HELP go_info Information about the Go environment.
# TYPE go_info gauge
go_info{version="go1.17.3"} 1
# HELP go_memstats_alloc_bytes Number of bytes allocated and still in use.
# TYPE go_memstats_alloc_bytes gauge
go_memstats_alloc_bytes 1.704688e+06
# HELP go_memstats_alloc_bytes_total Total number of bytes allocated, even if freed.
# TYPE go_memstats_alloc_bytes_total counter
go_memstats_alloc_bytes_total 4.934872e+06
# HELP go_memstats_buck_hash_sys_bytes Number of bytes used by the profiling bucket hash table.
# TYPE go_memstats_buck_hash_sys_bytes gauge
go_memstats_buck_hash_sys_bytes 1.447199e+06
# HELP go_memstats_frees_total Total number of frees.
# TYPE go_memstats_frees_total counter
go_memstats_frees_total 34632
# HELP go_memstats_gc_cpu_fraction The fraction of this program's available CPU time used by the GC since the program started.
# TYPE go_memstats_gc_cpu_fraction gauge
go_memstats_gc_cpu_fraction 1.5528753295353698e-05
# HELP go_memstats_gc_sys_bytes Number of bytes used for garbage collection system metadata.
# TYPE go_memstats_gc_sys_bytes gauge
go_memstats_gc_sys_bytes 5.05128e+06
# HELP go_memstats_heap_alloc_bytes Number of heap bytes allocated and still in use.
# TYPE go_memstats_heap_alloc_bytes gauge
go_memstats_heap_alloc_bytes 1.704688e+06
# HELP go_memstats_heap_idle_bytes Number of heap bytes waiting to be used.
# TYPE go_memstats_heap_idle_bytes gauge
go_memstats_heap_idle_bytes 4.800512e+06
# HELP go_memstats_heap_inuse_bytes Number of heap bytes that are in use.
# TYPE go_memstats_heap_inuse_bytes gauge
go_memstats_heap_inuse_bytes 3.129344e+06
# HELP go_memstats_heap_objects Number of allocated objects.
# TYPE go_memstats_heap_objects gauge
go_memstats_heap_objects 4357
# HELP go_memstats_heap_released_bytes Number of heap bytes released to OS.
# TYPE go_memstats_heap_released_bytes gauge
go_memstats_heap_released_bytes 3.473408e+06
```
1. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
```shell
vagrant@vagrant:~$ curl http://localhost:9100/metrics | grep '^node_memory_Mem'
node_memory_MemAvailable_bytes 7.58366208e+08
node_memory_MemFree_bytes 3.97586432e+08
node_memory_MemTotal_bytes 1.028694016e+09

vagrant@vagrant:~$ curl http://localhost:9100/metrics | grep '^node_cpu_seconds_total'
node_cpu_seconds_total{cpu="0",mode="idle"} 2379.5
node_cpu_seconds_total{cpu="0",mode="iowait"} 4.96
node_cpu_seconds_total{cpu="0",mode="irq"} 0
node_cpu_seconds_total{cpu="0",mode="nice"} 0
node_cpu_seconds_total{cpu="0",mode="softirq"} 2.58
node_cpu_seconds_total{cpu="0",mode="steal"} 0
node_cpu_seconds_total{cpu="0",mode="system"} 8.77
node_cpu_seconds_total{cpu="0",mode="user"} 4.42
node_cpu_seconds_total{cpu="1",mode="idle"} 2375.11
node_cpu_seconds_total{cpu="1",mode="iowait"} 0.88
node_cpu_seconds_total{cpu="1",mode="irq"} 0
node_cpu_seconds_total{cpu="1",mode="nice"} 0
node_cpu_seconds_total{cpu="1",mode="softirq"} 2.53
node_cpu_seconds_total{cpu="1",mode="steal"} 0
node_cpu_seconds_total{cpu="1",mode="system"} 11.31
node_cpu_seconds_total{cpu="1",mode="user"} 2.1

vagrant@vagrant:~$ curl http://localhost:9100/metrics | grep '^node_disk' | grep sda
node_disk_discard_time_seconds_total{device="sda"} 0
node_disk_discarded_sectors_total{device="sda"} 0
node_disk_discards_completed_total{device="sda"} 0
node_disk_discards_merged_total{device="sda"} 0
node_disk_info{device="sda",major="8",minor="0"} 1
node_disk_io_now{device="sda"} 0
node_disk_io_time_seconds_total{device="sda"} 19.484
node_disk_io_time_weighted_seconds_total{device="sda"} 1.276
node_disk_read_bytes_total{device="sda"} 4.65585152e+08
node_disk_read_time_seconds_total{device="sda"} 14.539
node_disk_reads_completed_total{device="sda"} 15198
node_disk_reads_merged_total{device="sda"} 3111
node_disk_write_time_seconds_total{device="sda"} 5.2090000000000005
node_disk_writes_completed_total{device="sda"} 2372
node_disk_writes_merged_total{device="sda"} 1057
node_disk_written_bytes_total{device="sda"} 5.5325696e+07

vagrant@vagrant:~$ curl http://localhost:9100/metrics | grep -P '^node_network(.*)_total'
node_network_carrier_changes_total{device="eth0"} 2
node_network_carrier_changes_total{device="lo"} 0
node_network_carrier_down_changes_total{device="eth0"} 1
node_network_carrier_down_changes_total{device="lo"} 0
node_network_carrier_up_changes_total{device="eth0"} 1
node_network_carrier_up_changes_total{device="lo"} 0
node_network_receive_bytes_total{device="eth0"} 9.635067e+06
node_network_receive_bytes_total{device="lo"} 373738
node_network_receive_compressed_total{device="eth0"} 0
node_network_receive_compressed_total{device="lo"} 0
node_network_receive_drop_total{device="eth0"} 0
node_network_receive_drop_total{device="lo"} 0
node_network_receive_errs_total{device="eth0"} 0
node_network_receive_errs_total{device="lo"} 0
node_network_receive_fifo_total{device="eth0"} 0
node_network_receive_fifo_total{device="lo"} 0
node_network_receive_frame_total{device="eth0"} 0
node_network_receive_frame_total{device="lo"} 0
node_network_receive_multicast_total{device="eth0"} 0
node_network_receive_multicast_total{device="lo"} 0
node_network_receive_packets_total{device="eth0"} 8755
node_network_receive_packets_total{device="lo"} 229
node_network_transmit_bytes_total{device="eth0"} 384920
node_network_transmit_bytes_total{device="lo"} 373738
node_network_transmit_carrier_total{device="eth0"} 0
node_network_transmit_carrier_total{device="lo"} 0
node_network_transmit_colls_total{device="eth0"} 0
node_network_transmit_colls_total{device="lo"} 0
node_network_transmit_compressed_total{device="eth0"} 0
node_network_transmit_compressed_total{device="lo"} 0
node_network_transmit_drop_total{device="eth0"} 0
node_network_transmit_drop_total{device="lo"} 0
node_network_transmit_errs_total{device="eth0"} 0
node_network_transmit_errs_total{device="lo"} 0
node_network_transmit_fifo_total{device="eth0"} 0
node_network_transmit_fifo_total{device="lo"} 0
node_network_transmit_packets_total{device="eth0"} 2841
node_network_transmit_packets_total{device="lo"} 229
```
2. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
```shell
vagrant@vagrant:~$ sudo apt install -y netdata
vagrant@vagrant:~$ sudo systemctl enable --now netdata
vagrant@vagrant:~$ sudo lsof -i :19999
COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
netdata 1726 netdata    4u  IPv4  30463      0t0  TCP localhost:19999 (LISTEN)
vagrant@vagrant:~$ sudo sed -i 's/127.0.0.1/0.0.0.0/' /etc/netdata/netdata.conf
vagrant@vagrant:~$ sudo systemctl restart netdata
vagrant@vagrant:~$ sudo lsof -i :19999
COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
netdata 2371 netdata    4u  IPv4  35234      0t0  TCP *:19999 (LISTEN)
```
- http://localhost:19999 успешно открывается
3. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
```shell
vagrant@vagrant:~$ dmesg | grep virt
[    0.004973] CPU MTRRs all blank - virtualized system.
[    0.053853] Booting paravirtualized kernel on KVM
[    9.912992] systemd[1]: Detected virtualization oracle.
```
- можно
4. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?
```shell
vagrant@vagrant:~$ /sbin/sysctl -n fs.nr_open
1048576
```
- fs.nr_open - максимальное число файловых дескрипторов, которое процесс может выделить
- ulimit:
  - ulimit -Sn  --  мягкое ограничение максимального числа дескрипторов открытых файлов
  - ulimit -Hn  --   жесткое ограничение максимального числа дескрипторов открытых файлов
5. Запустите любой долгоживущийпроцесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.
```shell
vagrant@vagrant:~$ sudo su -
root@vagrant:~# unshare --mount-proc --fork --pid sleep 1h &
[1] 1171
root@vagrant:~# ps aux | grep sleep
root        1171  0.0  0.0   8080   596 pts/0    S    20:46   0:00 unshare --mount-proc --fork --pid sleep 1h
root        1172  0.0  0.0   8076   588 pts/0    S    20:46   0:00 sleep 1h
root        1174  0.0  0.0   8900   672 pts/0    S+   20:46   0:00 grep --color=auto sleep
root@vagrant:~# nsenter --target 1172 --pid --mount
root@vagrant:/# ps aux | grep sleep
root           1  0.0  0.0   8076   588 pts/0    S    20:46   0:00 sleep 1h
root          12  0.0  0.0   8900   736 pts/0    S+   20:46   0:00 grep --color=auto sleep
```
6. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
- fork bomb: https://www.cyberciti.biz/faq/understanding-bash-fork-bomb/
- dmesg:
```
[  215.747236] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-1.scope
```
- всех спас механизм `cgroup`
- изменить число процессов (в дополнение вариантам по ссылке ранее)
```shell
vagrant@vagrant:~$ echo 3 | sudo tee /sys/fs/cgroup/pids/user.slice/user-1000.slice/session-1.scope/pids.max
3
vagrant@vagrant:~$ :(){ :|:& };:
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: Resource temporarily unavailable
vagrant@vagrant:~$
```
 