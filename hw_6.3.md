# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
```yaml 
---
version: '3.4'
services:
  mysql:
    image: mysql:8
    volumes:
      - ./data:/var/lib/mysql:z,rw
      - ./backup:/opt/backup:z,rw
    environment:
      MYSQL_ROOT_PASSWORD: mypassword

```
Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.
```shell
root@vagrant:~/hw_6.3# docker exec -ti hw_63_mysql_1 /bin/bash
root@9614f25c19c4:/# mysql -pmypassword -e 'CREATE DATABASE test_db;'
root@9614f25c19c4:/# mysql -pmypassword test_db < /opt/backup/test_dump.sql 
```
Перейдите в управляющую консоль `mysql` внутри контейнера.
```shell
root@9614f25c19c4:/# mysql -pmypassword
```
Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.
```shell
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		13
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.28 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			23 min 11 sec

Threads: 2  Questions: 51  Slow queries: 0  Opens: 138  Flush tables: 3  Open tables: 56  Queries per second avg: 0.036
--------------

```
Подключитесь к восстановленной БД и получите список таблиц из этой БД.
```sql
mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.01 sec)

```
**Приведите в ответе** количество записей с `price` > 300.
```sql
mysql> select * from orders where price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)

```
В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"
```sql
mysql> CREATE USER test IDENTIFIED WITH mysql_native_password BY 'test-pass' WITH MAX_QUERIES_PER_HOUR 100 PASSWORD EXPIRE INTERVAL 180 DAY FAILED_LOGIN_ATTEMPTS 3 ATTRIBUTE '{"fnaame":"James","lname":"Pretty"}';
```
Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
```sql
mysql> GRANT SELECT ON test_db.* TO 'test'@'%';
```    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.
```shell
mysql> select user, host, plugin, password_lifetime, max_questions, user_attributes from mysql.user where user = 'test';
+------+------+-----------------------+-------------------+---------------+-------------------------------------------------------------------------------------------------------------------------------------+
| user | host | plugin                | password_lifetime | max_questions | user_attributes                                                                                                                     |
+------+------+-----------------------+-------------------+---------------+-------------------------------------------------------------------------------------------------------------------------------------+
| test | %    | mysql_native_password |               180 |           100 | {"metadata": {"fname": "James", "lname": "Pretty"}, "Password_locking": {"failed_login_attempts": 3, "password_lock_time_days": 0}} |
+------+------+-----------------------+-------------------+---------------+-------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)


mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user = 'test';
+------+------+---------------------------------------+
| USER | HOST | ATTRIBUTE                             |
+------+------+---------------------------------------+
| test | %    | {"fname": "James", "lname": "Pretty"} |
+------+------+---------------------------------------+
1 row in set (0.00 sec)

mysql> show grants for 'test'@'%';
+-------------------------------------------+
| Grants for test@%                         |
+-------------------------------------------+
| GRANT USAGE ON *.* TO `test`@`%`          |
| GRANT SELECT ON `test_db`.* TO `test`@`%` |
+-------------------------------------------+
2 rows in set (0.00 sec)

```
## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

```shell
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SHOW PROFILES;
Empty set, 1 warning (0.00 sec)

mysql> select table_name, engine from information_schema.tables where table_schema = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)

mysql> update orders set price = 501 where id = 2;
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> alter table orders engine = MyISAM;
Query OK, 5 rows affected (0.11 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> update orders set price = 502 where id = 2;
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> alter table orders engine = InnoDB;
Query OK, 5 rows affected (0.10 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> update orders set price = 500 where id = 2;
Query OK, 1 row affected (0.02 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+-----------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                   |
+----------+------------+-----------------------------------------------------------------------------------------+
|        1 | 0.00281100 | select table_name, engine from information_schema.tables where table_schema = 'test_db' |
|        2 | 0.01354425 | update orders set price = 501 where id = 2                                              |
|        3 | 0.11708250 | alter table orders engine = MyISAM                                                      |
|        4 | 0.00883025 | update orders set price = 502 where id = 2                                              |
|        5 | 0.10380850 | alter table orders engine = InnoDB                                                      |
|        6 | 0.01312225 | update orders set price = 500 where id = 2                                              |
+----------+------------+-----------------------------------------------------------------------------------------+
6 rows in set, 1 warning (0.00 sec)

```
## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

```
root@9614f25c19c4:/# cat /etc/mysql/my.cnf
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

innodb_flush_method            = 1
innodb_flush_log_at_trx_commit = 2
innodb_log_file_size           = 104857600
innodb_log_buffer_size         = 1048576
innodb_buffer_pool_size        = 2576980377

# Custom config should go here
!includedir /etc/mysql/conf.d/

```