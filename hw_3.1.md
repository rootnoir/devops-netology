### Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"

---
1. Установите средство виртуализации Oracle VirtualBox.
   - выполнено
2. Установите средство автоматизации Hashicorp Vagrant.
    - выполнено
    - для связки Windows 10 + WSL2 (ну и Hyper-V) + VirtualBox + Vagrant применено решение: https://blog.thenets.org/how-to-run-vagrant-on-wsl-2/ (не требуется отключения Hyper-V и WSL)  
3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал.
    - xshell 7 
4. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:
```shell
$ vagrant up
```
```
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
==> default: Clearing any previously set forwarded ports...
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 172.17.48.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
==> default: Machine booted and ready!
```
5. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?
    - RAM: 1G
    - CPU 2
    - HDD 64G
6. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: документация. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?
- https://www.vagrantup.com/docs/providers/virtualbox/configuration#vboxmanage-customizations
```
config.vm.provider "virtualbox" do |v|
  v.memory = 1024
  v.cpus = 2
end
```
7. Команда vagrant ssh из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.
```shell
$ vagrant ssh
```
```
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat 13 Nov 2021 07:50:02 PM UTC

  System load:  0.95              Processes:             115
  Usage of /:   2.3% of 61.31GB   Users logged in:       0
  Memory usage: 14%               IPv4 address for eth0: 10.0.2.15
  Swap usage:   0%


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
```
8. Ознакомиться с разделами man bash, почитать о настройках самого bash:
    - какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?

   `HISTSIZE` - строка 862
    ```
       HISTSIZE
              The number of commands to remember in the command history (see HISTORY below).  If the value is 0, com‐
              mands  are  not saved in the history list.  Numeric values less than zero result in every command being
              saved on the history list (there is no limit).  The shell sets the default value to 500  after  reading
              any startup files.
       HISTTIMEFORMAT
              If this variable is set and not null, its value is used as a format string for strftime(3) to print the
              time stamp associated with each history entry displayed by the history builtin.  If  this  variable  is
              set,  time stamps are written to the history file so they may be preserved across shell sessions.  This
              uses the history comment character to distinguish timestamps from other history lines.
       HOME   The home directory of the current user; the default argument for the cd builtin command.  The value  of
              this variable is also used when performing tilde expansion.
       HOSTFILE
              Contains  the  name of a file in the same format as /etc/hosts that should be read when the shell needs
              to complete a hostname.  The list of possible hostname completions may be changed while  the  shell  is
              running;  the next time hostname completion is attempted after the value is changed, bash adds the con‐
              tents of the new file to the existing list.  If HOSTFILE is set, but has no value, or does not  name  a
              readable  file,  bash  attempts to read /etc/hosts to obtain the list of possible hostname completions.
              When HOSTFILE is unset, the hostname list is cleared.
       IFS    The Internal Field Separator that is used for word splitting after expansion and to  split  lines  into
              words with the read builtin command.  The default value is ``<space><tab><newline>''.
       IGNOREEOF
              Controls  the action of an interactive shell on receipt of an EOF character as the sole input.  If set,
              the value is the number of consecutive EOF characters which must be typed as the first characters on an
              input  line  before  bash  exits.   If the variable exists but does not have a numeric value, or has no
              value, the default value is 10.  If it does not exist, EOF signifies the end of input to the shell.
       INPUTRC
              The filename for the readline startup file, overriding the default of ~/.inputrc (see READLINE below).
       INSIDE_EMACS
    Manual page bash(1) line 862 (press h for help or q to quit)
    ```

    - что делает директива ignoreboth в bash?
   
   `man bash`
   ```
       HISTCONTROL
              A  colon-separated  list of values controlling how commands are saved on the history list.  If the list
              of values includes ignorespace, lines which begin with a space character are not saved in  the  history
              list.  A value of ignoredups causes lines matching the previous history entry to not be saved.  A value
              of ignoreboth is shorthand for ignorespace and ignoredups.  A value of erasedups  causes  all  previous
              lines  matching  the  current  line to be removed from the history list before that line is saved.  Any
              value not in the above list is ignored.  If HISTCONTROL is unset, or does not include  a  valid  value,
              all  lines  read by the shell parser are saved on the history list, subject to the value of HISTIGNORE.
              The second and subsequent lines of a multi-line compound command are not tested, and are added  to  the
              history regardless of the value of HISTCONTROL.
   ```
   - ignoreboth is shorthand for ignorespace and ignoredups
   

9. В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?

`Brace Expansion` - строка 1091

```
   Brace Expansion
       Brace  expansion  is  a  mechanism  by which arbitrary strings may be generated.  This mechanism is similar to
       pathname expansion, but the filenames generated need not exist.  Patterns to be brace expanded take  the  form
       of  an  optional preamble, followed by either a series of comma-separated strings or a sequence expression be‐
       tween a pair of braces, followed by an optional postscript.  The preamble is prefixed to each string contained
       within the braces, and the postscript is then appended to each resulting string, expanding left to right.

       Brace  expansions  may  be nested.  The results of each expanded string are not sorted; left to right order is
       preserved.  For example, a{d,c,b}e expands into `ade ace abe'.

       A sequence expression takes the form {x..y[..incr]}, where x and y are either integers or  single  characters,
       and  incr,  an  optional increment, is an integer.  When integers are supplied, the expression expands to each
       number between x and y, inclusive.  Supplied integers may be prefixed with 0 to force each term  to  have  the
       same width.  When either x or y begins with a zero, the shell attempts to force all generated terms to contain
       the same number of digits, zero-padding where necessary.  When characters are supplied, the expression expands
       to  each character lexicographically between x and y, inclusive, using the default C locale.  Note that both x
       and y must be of the same type.  When the increment is supplied, it is used as  the  difference  between  each
       term.  The default increment is 1 or -1 as appropriate.

       Brace  expansion  is performed before any other expansions, and any characters special to other expansions are
       preserved in the result.  It is strictly textual.  Bash does not apply any  syntactic  interpretation  to  the
       context of the expansion or the text between the braces.

       A correctly-formed brace expansion must contain unquoted opening and closing braces, and at least one unquoted
       comma or a valid sequence expression.  Any incorrectly formed brace expansion is left unchanged.  A { or , may
       be  quoted  with  a  backslash to prevent its being considered part of a brace expression.  To avoid conflicts
       with parameter expansion, the string ${ is not considered eligible for brace expansion, and inhibits brace ex‐
       pansion until the closing }.

       This  construct is typically used as shorthand when the common prefix of the strings to be generated is longer
       than in the above example:

              mkdir /usr/local/src/bash/{old,new,dist,bugs}
       or
              chown root /usr/{ucb/{ex,edit},lib/{ex?.?*,how_ex}}

       Brace expansion introduces a slight incompatibility with historical versions of sh.  sh does not treat opening
       or  closing  braces  specially when they appear as part of a word, and preserves them in the output.  Bash re‐
       moves braces from words as a consequence of brace expansion.  For example, a word entered to sh  as  file{1,2}
       appears identically in the output.  The same word is output as file1 file2 after expansion by bash.  If strict
       compatibility with sh is desired, start bash with the +B option or disable brace expansion with the +B  option
       to the set command (see SHELL BUILTIN COMMANDS below).

 Manual page bash(1) line 1091/4548 26% (press h for help or q to quit)
```
10. Основываясь на предыдущем вопросе, как создать однократным вызовом touch 100000 файлов? А получилось ли создать 300000? Если нет, то почему?
```shell
$ mkdir test
$ cd test
$ touch {1..100000}
$ touch {1..300000}
-bash: /usr/bin/touch: Argument list too long
$ getconf ARG_MAX
2097152
```
Превышена максимальная длинна аргументов

`ARG_MAX, maximum length of arguments for a new process`
- https://www.in-ulm.de/~mascheck/various/argmax/

11. В man bash поищите по `/\[\[`. Что делает конструкция `[[ -d /tmp ]]`
```
       [[ expression ]]
              Return a status of 0 or 1 depending on the evaluation of the conditional  expression  expression.   Ex‐
              pressions  are composed of the primaries described below under CONDITIONAL EXPRESSIONS.  Word splitting
              and pathname expansion are not performed on the words between the [[ and ]]; tilde expansion, parameter
              and variable expansion, arithmetic expansion, command substitution, process substitution, and quote re‐
              moval are performed.  Conditional operators such as -f must be unquoted to be recognized as primaries.
```
`[[ -d /tmp ]]` - возвращает 1 (True) если каталог существует.

12. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:
```
bash is /tmp/new_path_directory/bash
bash is /usr/local/bin/bash
bash is /bin/bash
```
(прочие строки могут отличаться содержимым и порядком) В качестве ответа приведите команды, которые позволили вам добиться указанного вывода или соответствующие скриншоты.

```shell
$ mkdir -p /tmp/new_path_directory
$ ln -s /bin/bash /tmp/new_path_directory/bash
$ sudo ln -s /bin/bash /usr/local/bin/bash
$ export PATH=/tmp/new_path_directory:/usr/local/bin:/bin:$PATH
$ type -a bash
```
```
bash is /tmp/new_path_directory/bash
bash is /usr/local/bin/bash
bash is /bin/bash
bash is /usr/local/bin/bash
bash is /usr/bin/bash
bash is /bin/bash
```
13. Чем отличается планирование команд с помощью `batch` и `at`?
- Команда `at` - используется для назначения одноразового задания на заданное время
- Команда `batch` — для назначения одноразовых задач, которые должны выполняться, когда загрузка системы становится меньше 0,8.
14. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.
```shell
vargant halt
```