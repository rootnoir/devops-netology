# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

```shell
root@vagrant:~/hw_6.2# cat docker-compose.yml
```
```yaml
---
version: '3.4'
services:
  postgres:
    image: postgres:12-alpine
    env_file: env/postgres.env
    volumes:
      - ./data:/var/lib/postgresql/data:z,rw
      - ./backup:/var/lib/postgresql/backup:z,rw

```
```shell
root@vagrant:~/hw_6.2# cat env/postgres.env
```
```
POSTGRES_PASSWORD=P@SsW0rd
POSTGRES_USER=netology

```

## Задача 2

В БД из задачи 1:
```shell
root@vagrant:~/hw_6.2# docker exec -ti hw_62_postgres_1 /bin/bash
bash-5.1# psql -U netology
psql (12.10)
Type "help" for help.

netology=#
```

- создайте пользователя test-admin-user и БД test_db
```sql
CREATE USER "test-admin-user" WITH ENCRYPTED PASSWORD 'mypassword';
CREATE DATABASE test_db;
```
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
```sql
\c test_db

CREATE TABLE orders(
  id SERIAL PRIMARY KEY,
  наименование TEXT,
  цена INTEGER
);

CREATE TABLE clients(
  id SERIAL PRIMARY KEY,
  фамилия TEXT,
  "страна проживания" TEXT,
  заказ INTEGER,
  CONSTRAINT fk_orders
    FOREIGN KEY(заказ)
      REFERENCES orders(id)
);

CREATE INDEX clients_country_idx ON clients ("страна проживания");
```
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
```sql
GRANT ALL PRIVILEGES ON orders TO "test-admin-user";
GRANT ALL PRIVILEGES ON clients TO "test-admin-user";
```
- создайте пользователя test-simple-user
```sql
CREATE USER "test-simple-user" WITH ENCRYPTED PASSWORD 'userpassword';
```
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON orders TO "test-simple-user";
GRANT SELECT, INSERT, UPDATE, DELETE ON clients TO "test-simple-user";
```

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
```
test_db=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 netology  | netology | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres  | netology | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | netology | UTF8     | en_US.utf8 | en_US.utf8 | =c/netology          +
           |          |          |            |            | netology=CTc/netology
 template1 | netology | UTF8     | en_US.utf8 | en_US.utf8 | =c/netology          +
           |          |          |            |            | netology=CTc/netology
 test_db   | netology | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/netology         +
           |          |          |            |            | netology=CTc/netology
(5 rows)

```

- описание таблиц (describe)
```
test_db=# \d orders
                               Table "public.orders"
    Column    |  Type   | Collation | Nullable |              Default               
--------------+---------+-----------+----------+------------------------------------
 id           | integer |           | not null | nextval('orders_id_seq'::regclass)
 наименование | text    |           |          | 
 цена         | integer |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "fk_orders" FOREIGN KEY ("заказ") REFERENCES orders(id)


test_db=# \d clients
                                  Table "public.clients"
      Column       |  Type   | Collation | Nullable |               Default               
-------------------+---------+-----------+----------+-------------------------------------
 id                | integer |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | text    |           |          | 
 страна проживания | text    |           |          | 
 заказ             | integer |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_country_idx" btree ("страна проживания")
Foreign-key constraints:
    "fk_orders" FOREIGN KEY ("заказ") REFERENCES orders(id)


```

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```
SELECT * FROM information_schema.table_privileges WHERE table_name = 'orders' OR table_name = 'clients';   
```
```
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 netology | netology         | test_db       | public       | orders     | INSERT         | YES          | NO
 netology | netology         | test_db       | public       | orders     | SELECT         | YES          | YES
 netology | netology         | test_db       | public       | orders     | UPDATE         | YES          | NO
 netology | netology         | test_db       | public       | orders     | DELETE         | YES          | NO
 netology | netology         | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 netology | netology         | test_db       | public       | orders     | REFERENCES     | YES          | NO
 netology | netology         | test_db       | public       | orders     | TRIGGER        | YES          | NO
 netology | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 netology | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 netology | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 netology | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 netology | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 netology | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 netology | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 netology | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 netology | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 netology | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 netology | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 netology | netology         | test_db       | public       | clients    | INSERT         | YES          | NO
 netology | netology         | test_db       | public       | clients    | SELECT         | YES          | YES
 netology | netology         | test_db       | public       | clients    | UPDATE         | YES          | NO
 netology | netology         | test_db       | public       | clients    | DELETE         | YES          | NO
 netology | netology         | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 netology | netology         | test_db       | public       | clients    | REFERENCES     | YES          | NO
 netology | netology         | test_db       | public       | clients    | TRIGGER        | YES          | NO
 netology | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 netology | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 netology | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 netology | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
 netology | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 netology | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 netology | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 netology | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 netology | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 netology | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 netology | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
(36 rows)

```

- список пользователей с правами над таблицами test_db
```
test_db=# \dp
                                             Access privileges
 Schema |       Name        |   Type   |         Access privileges          | Column privileges | Policies 
--------+-------------------+----------+------------------------------------+-------------------+----------
 public | clients           | table    | netology=arwdDxt/netology         +|                   | 
        |                   |          | "test-simple-user"=arwd/netology  +|                   | 
        |                   |          | "test-admin-user"=arwdDxt/netology |                   | 
 public | clients_id_seq    | sequence |                                    |                   | 
 public | clients_заказ_seq | sequence |                                    |                   | 
 public | orders            | table    | netology=arwdDxt/netology         +|                   | 
        |                   |          | "test-simple-user"=arwd/netology  +|                   | 
        |                   |          | "test-admin-user"=arwdDxt/netology |                   | 
 public | orders_id_seq     | sequence |                                    |                   | 
(5 rows)

```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

```sql
INSERT INTO orders (наименование, цена) VALUES ('Шоколад', 10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000);
```
```
INSERT 0 5
```

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

```sql
INSERT INTO clients (фамилия, "страна проживания") VALUES ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');
```
```
INSERT 0 5
```

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы
```sql
SELECT COUNT(*) FROM orders;
```
```
 count 
-------
     5
(1 row)

```

```sql
SELECT COUNT(*) FROM clients;
```
```
 count 
-------
     5
(1 row)

```

- приведите в ответе:
    - запросы 
    - результаты их выполнения.

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

```sql
UPDATE clients SET заказ = (SELECT id FROM orders WHERE наименование = 'Книга') WHERE фамилия = 'Иванов Иван Иванович';
UPDATE clients SET заказ = (SELECT id FROM orders WHERE наименование = 'Монитор') WHERE фамилия = 'Петров Петр Петрович';
UPDATE clients SET заказ = (SELECT id FROM orders WHERE наименование = 'Гитара') WHERE фамилия = 'Иоганн Себастьян Бах';
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```sql
SELECT фамилия FROM clients WHERE заказ IS NOT NULL;
```
```
       фамилия        
----------------------
 Иванов Иван Иванович
 Петров Петр Петрович
 Иоганн Себастьян Бах
(3 rows)

```
 
Подсказк - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

```sql
EXPLAIN SELECT фамилия FROM clients WHERE заказ IS NOT NULL;
```
```
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=32)
   Filter: ("заказ" IS NOT NULL)
(2 rows)


```
```sql
test_db=# EXPLAIN ANALYZE SELECT фамилия FROM clients WHERE заказ IS NOT NULL;
```
```
                                             QUERY PLAN                                              
-----------------------------------------------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=32) (actual time=0.014..0.015 rows=3 loops=1)
   Filter: ("заказ" IS NOT NULL)
   Rows Removed by Filter: 2
 Planning Time: 0.055 ms
 Execution Time: 0.030 ms
(5 rows)


```
- cost
  - 0.00 - приблизительная минимальная стоимость запуска. Это время (в произвольных единицах, определяемых параметрами планировщика), которое проходит, прежде чем начнётся этап вывода данных.
  - 18.10 - приблизительная максимальная стоимость.
- rows=806 - ожидаемое число строк, которое должен вывести этот узел плана запроса.
- width=32 - ожидаемый средний размер строк в байтах, выводимых этим узлом плана запроса.
- Filter: ("заказ" IS NOT NULL) - условие WHERE применено как "фильтр" к узлу плана Seq Scan.

- actual time=0.014..0.015 - время выполнения в миллисекундах.
- rows=3 - фактическое число строк.
- loops=1 - сколько всего раз выполнялся этот узел плана запроса, где фактическое время и число строк вычисляется как среднее по всем итерациям.
- Rows Removed by Filter: 2 - число строк, удалённых условием фильтра.
- Planning Time: 0.055 ms - время, затраченное на построение плана запроса из разобранного запроса и его оптимизацию.
- Execution Time: 0.030 ms - время, от запуска до остановки исполнителя запроса, а также время выполнения всех сработавших триггеров, но исключает время разбора, перезаписи и планирования запроса.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

```shell
bash-5.1# pg_dump -U netology test_db > /var/lib/postgresql/backup/test_db.sql
```

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

```shell
root@vagrant:~/hw_6.2# docker stop hw_62_postgres_1
hw_62_postgres_1
root@vagrant:~/hw_6.2# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

```

Поднимите новый пустой контейнер с PostgreSQL.

```shell
root@vagrant:~/hw_6.2# docker run --name clean_postgres -d -v /root/hw_6.2/backup:/var/lib/postgresql/backup -e POSTGRES_PASSWORD=password -e POSTGRES_USER=netology postgres:12-alpine
13abcff433ba9a38b603b2540ac5fef9dba2045c404ec0ed9bb0983a87f90405
root@vagrant:~/hw_6.2# docker ps
CONTAINER ID   IMAGE                COMMAND                  CREATED         STATUS         PORTS      NAMES
13abcff433ba   postgres:12-alpine   "docker-entrypoint.s…"   6 seconds ago   Up 5 seconds   5432/tcp   clean_postgres

```

Восстановите БД test_db в новом контейнере.

```shell
root@vagrant:~/hw_6.2# docker exec -ti clean_postgres /bin/bash
bash-5.1# cat /var/lib/postgresql/backup/test_db.sql | psql -U netology
```
```
bash-5.1# psql -U netology
psql (12.10)
Type "help" for help.

netology=# \c test_db
You are now connected to database "test_db" as user "netology".
test_db=# select * from orders;
 id | наименование | цена 
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      | 3000
  3 | Книга        |  500
  4 | Монитор      | 7000
  5 | Гитара       | 4000
(5 rows)

test_db=# select * from clients;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  4 | Ронни Джеймс Дио     | Russia            |      
  5 | Ritchie Blackmore    | Russia            |      
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(5 rows)


```
Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

- выполнено выше

---
