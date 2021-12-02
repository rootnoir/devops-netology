# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"

1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.
```shell
$ type cd
cd is a shell builtin
```
`cd` должна менять cwd (current working directory). 
Если бы `cd` была внешней программой - она меняла бы cwd только своего подпроцесса, а после выполнения shell бы оставался в точке запуска. 
`cd` меняет cwd родительского процесса shell
2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.
```shell
grep <some_string> <some_file> -c
```
```
-c, --count
      Suppress normal output; instead print a count of matching lines for each  input  file.   With  the  -v,
      --invert-match option (see below), count non-matching lines.

```
3. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
```shell
$ ps -p 1
    PID TTY          TIME CMD
      1 ?        00:00:03 systemd
```
`systemd`
4. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?
```shell
$ ls /mydir 2> /dev/pts/1
```
- `2` - дескриптор stderr
- `/dev/pts/1` - другая сессия терминала
6. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.
```shell
cat < /etc/os-release > /tmp/os-release
cat /tmp/os-release
```
```
NAME="Ubuntu"
VERSION="20.04.2 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.2 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
```
6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
```shell
echo 'test' > /dev/tty1
```
- Всё получится. Данные искать в tty1
7. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?
- `bash 5>&1` - создаст дескриптор `5` и перенаправит его в `1` (stdout)
- `echo netology > /proc/$$/fd/5` - выведет `netology` в stdout
- `/proc/$$/fd` - содержит ссылки для дескрипторов файлов, которые были открыты собственным процессом `$$`
```shell
$ ll /proc/$$/fd
total 0
dr-x------ 2 vagrant vagrant  0 Dec  2 20:46 ./
dr-xr-xr-x 9 vagrant vagrant  0 Dec  2 20:46 ../
lrwx------ 1 vagrant vagrant 64 Dec  2 20:48 0 -> /dev/pts/0
lrwx------ 1 vagrant vagrant 64 Dec  2 20:48 1 -> /dev/pts/0
lrwx------ 1 vagrant vagrant 64 Dec  2 20:48 2 -> /dev/pts/0
lrwx------ 1 vagrant vagrant 64 Dec  2 20:48 255 -> /dev/pts/0
lrwx------ 1 vagrant vagrant 64 Dec  2 20:46 5 -> /dev/pts/0
```
8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа.
Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.
```shell
cat /mydir 5>&1 1>&2 2>&5 | grep file
```
- Всё получится.
9. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?
- переменные окружения
```shell
env
printenv
```
10. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.
`man proc`
```
       /proc/[pid]/cmdline
              This read-only file holds the complete command line for the process, unless the process  is  a  zombie.
              In  the  latter case, there is nothing in this file: that is, a read on this file will return 0 charac‐
              ters.  The command-line arguments appear in this file as a set  of  strings  separated  by  null  bytes
              ('\0'), with a further null byte after the last string.
```
```
       /proc/[pid]/exe
              Under  Linux 2.2 and later, this file is a symbolic link containing the actual pathname of the executed
              command.  This symbolic link can be dereferenced normally; attempting to open it  will  open  the  exe‐
              cutable.   You  can  even type /proc/[pid]/exe to run another copy of the same executable that is being
              run by process [pid].  If the pathname has been unlinked, the symbolic link  will  contain  the  string
              '(deleted)'  appended  to the original pathname.  In a multithreaded process, the contents of this sym‐
              bolic link are not  available  if  the  main  thread  has  already  terminated  (typically  by  calling
              pthread_exit(3)).

              Permission  to dereference or read (readlink(2)) this symbolic link is governed by a ptrace access mode
              PTRACE_MODE_READ_FSCREDS check; see ptrace(2).

              Under Linux 2.0 and earlier, /proc/[pid]/exe is a pointer to the binary which was executed, and appears
              as a symbolic link.  A readlink(2) call on this file under Linux 2.0 returns a string in the format:

                  [device]:inode

              For example, [0301]:1502 would be inode 1502 on device major 03 (IDE, MFM, etc. drives) minor 01 (first
              partition on the first drive).

              find(1) with the -inum option can be used to locate the file.

```
11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.
```shell
$ cat /proc/cpuinfo | grep -Pio 'sse\S*'
sse
sse2
sse3
sse4_1
sse4_2
sse
sse2
sse3
sse4_1
sse4_2
```
- `sse4_2`
12. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:

     ```bash
     vagrant@netology1:~$ ssh localhost 'tty'
     not a tty
     ```

     Почитайте, почему так происходит, и как изменить поведение.

`man tty`
```
tty - print the file name of the terminal connected to standard input
```

`man ssh`
```
     -t      Force pseudo-terminal allocation.  This can be used to execute arbitrary screen-based programs on a re‐
             mote machine, which can be very useful, e.g. when implementing menu services.  Multiple -t options force
             tty allocation, even if ssh has no local tty.
```
```shell
$ ssh -t localhost 'tty'
/dev/pts/1
Connection to localhost closed.
```
13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.
```shell
$ sudo apt -y install screen reptyr
```
- tty0
```shell
$ tty
/dev/pts/0
$ top
```
- tty1
```shell
$ tty
/dev/pts/1
$ sudo sysctl kernel.yama.ptrace_scope=0
kernel.yama.ptrace_scope = 0
$ ps aux | grep top
vagrant     1679  0.1  0.3  11852  3860 pts/0    S+   21:18   0:00 top
vagrant     1689  0.0  0.0   8900   736 pts/1    S+   21:19   0:00 grep --color=auto top
$ screen
```
- в screen
```shell
$ reptyr -s 1679
```
14. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.

`man tee`

```
tee - read from standard input and write to standard output and files
```

- `sudo echo string` - sudo применяется к echo, а не к записи в файл.
- `sudo tee` - sudo применяется к tee, у tee будут права на запись в файл. echo выполняется без повышенных привилегий, а вывод stdout echo перенаправляется на stdin tee, запущенной от sudo, и она записывает данные в файл.


 