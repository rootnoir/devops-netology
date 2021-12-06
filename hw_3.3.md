# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.
```shell
$ strace -o trc.txt /bin/bash -c 'cd /tmp'
$ grep '/tmp' trc.txt
```
```
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffe8a571460 /* 23 vars */) = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
chdir("/tmp")                           = 0
```
к `cd` относится:
```
chdir("/tmp")                           = 0
```

2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.
```shell
$ strace -e openat file /dev/tty
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/C.UTF-8/LC_CTYPE", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
/dev/tty: character special (5/0)
+++ exited with 0 +++
$ strace -e openat file /dev/sda
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/C.UTF-8/LC_CTYPE", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
/dev/sda: block special (8/0)
+++ exited with 0 +++
$ strace -e openat file /bin/bash
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/C.UTF-8/LC_CTYPE", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
openat(AT_FDCWD, "/bin/bash", O_RDONLY|O_NONBLOCK) = 3
/bin/bash: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=a6cb40078351e05121d46daa768e271846d5cc54, for GNU/Linux 3.2.0, stripped
+++ exited with 0 +++
```
```
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
```
```shell
$ cat /etc/magic
# Magic local data for file(1) command.
# Insert here your local magic data. Format is described in magic(5).
```
- сама база находится в `/usr/share/misc/magic.mgc`

3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
```shell
# ищем PID для APPLICATION 
ps aux | grep APPLICATION  
# ищем в выводе номер дескриптора к примеру "5"
lsof -p PID | grep "deleted"  
# освобождаем место  
> proc/PID/fd/5  
```
4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
- не занимают
- https://ru.wikipedia.org/wiki/%D0%9F%D1%80%D0%BE%D1%86%D0%B5%D1%81%D1%81-%D0%B7%D0%BE%D0%BC%D0%B1%D0%B8
```
Процесс при завершении (как нормальном, так и в результате не обрабатываемого сигнала) освобождает все свои ресурсы и становится «зомби» — пустой записью в таблице процессов, хранящей статус завершения, предназначенный для чтения родительским процессом.

Зомби-процесс существует до тех пор, пока родительский процесс не прочитает его статус с помощью системного вызова wait(), в результате чего запись в таблице процессов будет освобождена.
```
5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).
```shell
$ sudo apt-get install bpfcc-tools linux-headers-$(uname -r) -y
```
```shell
$ sudo opensnoop-bpfcc -d1
```
```
PID    COMM               FD ERR PATH
817    vminfo              5   0 /var/run/utmp
562    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
562    dbus-daemon        18   0 /usr/share/dbus-1/system-services
562    dbus-daemon        -1   2 /lib/dbus-1/system-services
562    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
```
6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.
```shell
uname({sysname="Linux", nodename="vagrant", ...}) = 0
write(1, "#90-Ubuntu SMP Fri Jul 9 22:49:4"..., 43#90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021) = 43
```
```shell
$ sudo apt -y install manpages-dev
$ man 2 uname
```
```
       Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version,
       domainname}.
```
```shell
$ sudo cat /proc/sys/kernel/{ostype,hostname,osrelease,version,domainname}
```
```
Linux
vagrant
5.4.0-80-generic
#90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021
(none)
```
```shell
$ sudo cat /etc/*release
```
```
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04.2 LTS"
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
7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
- `;` - последовательное выполнение команд
- `&&` - вторая команда будет выполнена только при успешном завершении первой

   Есть ли смысл использовать в bash `&&`, если применить `set -e`?
```shell
man bash
/^\s*set\s\[
```
```
       set [--abefhkmnptuvxBCEHPT] [-o option-name] [arg ...]
       set [+abefhkmnptuvxBCEHPT] [+o option-name] [arg ...]
              Without options, the name and value of each shell variable are displayed in a format that can be reused
              as input for setting or resetting the currently-set variables.  Read-only variables  cannot  be  reset.
              In  posix mode, only shell variables are listed.  The output is sorted according to the current locale.
              When options are specified, they set or unset shell attributes.  Any arguments remaining  after  option
              processing  are  treated as values for the positional parameters and are assigned, in order, to $1, $2,
              ...  $n.  Options, if specified, have the following meanings:
              -a      Each variable or function that is created or modified is given the export attribute and  marked
                      for export to the environment of subsequent commands.
              -b      Report  the  status of terminated background jobs immediately, rather than before the next pri‐
                      mary prompt.  This is effective only when job control is enabled.
              -e      Exit immediately if a pipeline (which may consist of a single simple command),  a  list,  or  a
                      compound  command  (see SHELL GRAMMAR above), exits with a non-zero status.  The shell does not
                      exit if the command that fails is part of the command list immediately following a while or un‐
                      til keyword, part of the test following the if or elif reserved words, part of any command exe‐
                      cuted in a && or || list except the command following the final && or  ||,  any  command  in  a
                      pipeline  but  the  last, or if the command's return value is being inverted with !.  If a com‐
                      pound command other than a subshell returns a non-zero status because a command failed while -e
                      was  being  ignored,  the  shell  does not exit.  A trap on ERR, if set, is executed before the
                      shell exits.  This option applies to the shell environment and each subshell environment  sepa‐
                      rately  (see  COMMAND EXECUTION ENVIRONMENT above), and may cause subshells to exit before exe‐
                      cuting all the commands in the subshell.

                      If a compound command or shell function executes in a context where -e is being  ignored,  none
                      of  the  commands executed within the compound command or function body will be affected by the
                      -e setting, even if -e is set and a command returns a failure status.  If a compound command or
                      shell  function sets -e while executing in a context where -e is ignored, that setting will not
                      have any effect until the compound command or the command containing  the  function  call  com‐
                      pletes.
              -f      Disable pathname expansion.
```
- смысл использования `&&` с `set -e` описан тут
```
                      The shell does not exit if the command that fails is part of the command list immediately following a while or un‐
                      til keyword, part of the test following the if or elif reserved words, part of any command exe‐
                      cuted in a && or || list except the command following the final && or  ||,  any  command  in  a
                      pipeline  but  the  last, or if the command's return value is being inverted with !.
```
8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
```shell
man bash
/^\s*set\s\[
```
```
              -e      Exit immediately if a pipeline (which may consist of a single simple command),  a  list,  or  a
                      compound  command  (see SHELL GRAMMAR above), exits with a non-zero status.  The shell does not
                      exit if the command that fails is part of the command list immediately following a while or un‐
                      til keyword, part of the test following the if or elif reserved words, part of any command exe‐
                      cuted in a && or || list except the command following the final && or  ||,  any  command  in  a
                      pipeline  but  the  last, or if the command's return value is being inverted with !.  If a com‐
                      pound command other than a subshell returns a non-zero status because a command failed while -e
                      was  being  ignored,  the  shell  does not exit.  A trap on ERR, if set, is executed before the
                      shell exits.  This option applies to the shell environment and each subshell environment  sepa‐
                      rately  (see  COMMAND EXECUTION ENVIRONMENT above), and may cause subshells to exit before exe‐
                      cuting all the commands in the subshell.

                      If a compound command or shell function executes in a context where -e is being  ignored,  none
                      of  the  commands executed within the compound command or function body will be affected by the
                      -e setting, even if -e is set and a command returns a failure status.  If a compound command or
                      shell  function sets -e while executing in a context where -e is ignored, that setting will not
                      have any effect until the compound command or the command containing  the  function  call  com‐
                      pletes.

              -o option-name
                      The option-name can be one of the following:
                      pipefail
                              If set, the return value of a pipeline is the value of the last (rightmost) command  to
                              exit with a non-zero status, or zero if all commands in the pipeline exit successfully.
                              This option is disabled by default.

              -u      Treat  unset variables and parameters other than the special parameters "@" and "*" as an error
                      when performing parameter expansion.  If expansion is attempted on an unset variable or parame‐
                      ter, the shell prints an error message, and, if not interactive, exits with a non-zero status.

              -x      After  expanding  each simple command, for command, case command, select command, or arithmetic
                      for command, display the expanded value of PS4, followed by the command and its expanded  argu‐
                      ments or associated word list.

```
- хорошо для поиска ошибок и логирования.
9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
```shell
vagrant@vagrant:~$ ps
```
```
    PID TTY          TIME CMD
   1113 pts/0    00:00:00 bash
   5527 pts/0    00:00:00 ps
```
```shell
vagrant@vagrant:~$ ps -o stat
```
```
STAT
Ss
R+
```

```shell
man ps
```
```
PROCESS STATE CODES
       Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display
       to describe the state of a process:

               D    uninterruptible sleep (usually IO)
               I    Idle kernel thread
               R    running or runnable (on run queue)
               S    interruptible sleep (waiting for an event to complete)
               T    stopped by job control signal
               t    stopped by debugger during the tracing
               W    paging (not valid since the 2.6.xx kernel)
               X    dead (should never be seen)
               Z    defunct ("zombie") process, terminated but not reaped by its parent

       For BSD formats and when the stat keyword is used, additional characters may be displayed:

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group

```
