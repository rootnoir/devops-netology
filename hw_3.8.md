# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```
```shell
route-views>show ip route 109.xxx.xxx.xxx
Routing entry for 109.xxx.0.0/16
  Known via "bgp 6447", distance 20, metric 0
  Tag 8283, type external
  Last update from 94.142.247.3 1w2d ago
  Routing Descriptor Blocks:
  * 94.142.247.3, from 94.142.247.3, 1w2d ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 8283
      MPLS label: none

route-views>show bgp 109.xxx.xxx.xxx
BGP routing table entry for 109.xxx.0.0/16, version 1391417923
Paths: (23 available, best #17, table default)
  Not advertised to any peer
  Refresh Epoch 1
  57866 3356 8359 25513
    37.139.139.17 from 37.139.139.17 (37.139.139.17)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 0:151 3356:2 3356:22 3356:100 3356:123 3356:519 3356:903 3356:2094 8359:100 8359:5500 8359:55277
      path 7FE114A668D0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 8359 25513
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 0:151 3356:2 3356:22 3356:100 3356:123 3356:519 3356:903 3356:2094 3549:2581 3549:30840 8359:100 8359:5500 8359:55277
      path 7FE11A143EE0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
.......
```
2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
```shell
vagrant@vagrant:~$ sudo modprobe -v dummy numdummies=1
insmod /lib/modules/5.4.0-80-generic/kernel/drivers/net/dummy.ko numdummies=0 numdummies=1
vagrant@vagrant:~$ sudo lsmod | grep dummy
dummy                  16384  0
vagrant@vagrant:~$ ip -br link | grep dummy0
dummy0           DOWN           7e:4d:4e:cd:5b:b2 <BROADCAST,NOARP>
vagrant@vagrant:~$ sudo ip link set dummy0 up
vagrant@vagrant:~$ sudo ip r add 10.0.0.0/24 dev dummy0
vagrant@vagrant:~$ sudo ip r add 10.0.1.0/24 dev dummy0
vagrant@vagrant:~$ ip r | grep dummy0
10.0.0.0/24 dev dummy0 scope link
10.0.1.0/24 dev dummy0 scope link
```
3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
```shell
vagrant@vagrant:~$ sudo ss -nlpt
State    Recv-Q   Send-Q     Local Address:Port     Peer Address:Port  Process
LISTEN   0        4096             0.0.0.0:111           0.0.0.0:*      users:(("rpcbind",pid=550,fd=4),("systemd",pid=1,fd=35))
LISTEN   0        4096       127.0.0.53%lo:53            0.0.0.0:*      users:(("systemd-resolve",pid=551,fd=13))
LISTEN   0        128              0.0.0.0:22            0.0.0.0:*      users:(("sshd",pid=644,fd=3))
LISTEN   0        4096                [::]:111              [::]:*      users:(("rpcbind",pid=550,fd=6),("systemd",pid=1,fd=37))
LISTEN   0        128                 [::]:22               [::]:*      users:(("sshd",pid=644,fd=4))
```
 - 22 - SSH
 - 53 - DNS
 - 111 - SUNRPC (Sun Remote Procedure Call)
4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
```shell
vagrant@vagrant:~$ sudo ss -nlpu
State   Recv-Q   Send-Q      Local Address:Port     Peer Address:Port  Process
UNCONN  0        0           127.0.0.53%lo:53            0.0.0.0:*      users:(("systemd-resolve",pid=551,fd=12))
UNCONN  0        0          10.0.2.15%eth0:68            0.0.0.0:*      users:(("systemd-network",pid=385,fd=19))
UNCONN  0        0                 0.0.0.0:111           0.0.0.0:*      users:(("rpcbind",pid=550,fd=5),("systemd",pid=1,fd=36))
UNCONN  0        0                    [::]:111              [::]:*      users:(("rpcbind",pid=550,fd=7),("systemd",pid=1,fd=38))
```
 - 22 - SSH
 - 53 - DNS
 - 68 - DHCP
5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 
- домашняя сеть
- https://viewer.diagrams.net/?tags=%7B%7D&highlight=0000ff&edit=_blank&layers=1&nav=1#R7Vhtb9owEP41fBzKCyHh40rZJq2TOnVSt0%2FITY7Eq5OLbANhv34X4ryRltKqXVepgETuubPPvueeGDJy52nxWbI8%2BYYRiJFjRcXIPR85jj1xnFH5saJdhfi%2BAWLJIxPUAlf8DxjQMuiaR6B6gRpRaJ73wRCzDELdw5iUuO2HrVD0s%2BYshgFwFTIxRK95pJMKDRy%2Fxb8Aj5M6sz2dVZ6U1cFmJyphEW47kLsYuXOJqKurtJiDKItX16Ua9%2Bkeb7MwCZk%2BZUBRbNK5c%2FUjyrbB9XdnI7%2FOpx%2BmZm16V28YItq%2FMVHqBGPMmFi06JnEdRZBOatFVhtzgZgTaBP4G7TeGTLZWiNBiU6F8VY5y0T3bsVACtcyhCPrr1uCyRj0kTivKTh1KmAKWu5onATBNN%2F018FMy8RNXFtVujCFfUSRzbwbJtYm06Dq1Bx5eZkWcamjcchViGOqtAapxltOCwWllhVAJVS3oMPEUNApbY48o4jFhiqpDBYxlTR0rbgQcxQo93ldy50GM7%2BcUEu8hY5ntX81nrr5qYpnG5Cak0Qu2A2IS1Rcc8zId4NaY9oJ%2BCh4XDp02RhnzFghZNUmaDOCZ5S0lq7VNEc5AxTH22NIpxkwCYzkzD2nNretgP2ggpKOdn3%2FhfgPXkNkVCu5%2B2nG741fpTH2avO86DrPd13rEiSnvZcsdUh5FsU6JyrWfU3FOk9VbIhpvtfskmXRMqcy5glIJtQ4D99le1y2ttOXrTs9UbfWC3WB%2F8YPR%2FdEqd1Dy7%2BRmvtUqaktJy0BnY4ob2Oqe76soHedHdeZ4%2Fk9nTW%2FtTs6sy17KDTvpYQ2e%2BNCm7yFM23yfqa9gtaC%2F%2BxM807ogi6hd7HY%2FJO1Dint0N9nMcMMhpR7VvkmXBzQ1%2FDyIL93Enci6YftjqsVD2EcClxHqvp6ni6YzvpdMLMHTTCb3HG%2F9R7dBGS2TxT2vs5zGXfxFw%3D%3D