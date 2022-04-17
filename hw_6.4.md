# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

```
General
  \q                     quit psql

Informational
  \d[S+]                 list tables, views, and sequences
  \l[+]   [PATTERN]      list databases
  \d[S+]  NAME           describe table, view, sequence, or index

Connection
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
```
## Задача 2

Используя `psql` создайте БД `test_database`.
```shell
bash-5.1# psql -U postgres -c "CREATE DATABASE test_database;"
```
Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
```shell
bash-5.1# psql -U postgres -d test_database < /var/lib/postgresql/backup/test_dump.sql
```
Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```
bash-5.1# psql -U postgres -d test_database
psql (13.6)
Type "help" for help.

test_database=# ANALYZE;
ANALYZE

```
Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
- столбец `title`
```mysql
test_database=# select tablename,attname,avg_width from pg_stats where tablename='orders' order by avg_width desc;
 tablename | attname | avg_width 
-----------+---------+-----------
 orders    | title   |        16
 orders    | id      |         4
 orders    | price   |         4
(3 rows)

```
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.
```mysql
BEGIN;

CREATE TABLE orders_sharded (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
) PARTITION BY RANGE (price);

ALTER TABLE orders_sharded OWNER TO postgres;

CREATE TABLE orders_2 PARTITION OF orders_sharded
    FOR VALUES FROM (0) TO (500);

ALTER TABLE orders_2 OWNER TO postgres;

CREATE TABLE orders_1 PARTITION OF orders_sharded
    FOR VALUES FROM (500) TO (MAXVALUE);

ALTER TABLE orders_1 OWNER TO postgres;

INSERT INTO orders_sharded SELECT * FROM orders;
DROP table orders;
ALTER table orders_sharded rename to orders;

CREATE SEQUENCE orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE orders_id_seq OWNER TO postgres;

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);

ALTER TABLE orders ADD CONSTRAINT orders_pkey PRIMARY KEY (id, price);

COMMIT;
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

- Безусловно! Каждый разработчик, на этапе проектирования, всегда должен задаваться вопросом "а что будет с моей таблицей, когда она вырастет до миллона/миллиарда строк?" 

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

```shell
bash-5.1# pg_dump -U postgres -d test_database -f /var/lib/postgresql/backup/test_database.dump
```
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?
```mysql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) UNIQUE NOT NULL,
    price integer DEFAULT 0
);
```