# otus_5
Инициализация системы. Systemd и SysV
1) Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в ```/etc/sysconfig```

Создаём файл с конфигурацией для сервиса в директории ```/etc/sysconfig``` - из неё сервис будет брать необходимые переменные.
```
cd /etc/sysconfig/
vi watchlog
```
Содержимое файла
```
# Configuration file for my watchlog service
# Place it to /etc/sysconfig
# File and word in that file that we will be monit
WORD="ALERT"
LOG=/var/log/watchlog.log
```
Затем создаем /var/log/watchlog.log и пишем туда строки на своё усмотрение, плюс ключевое слово ‘ALERT’
```
cd /var/log/
vi watchlog
```
Создадим скрипт watchlog.sh :
```
cd /opt/
vi watchlog
```
Содержимое файла (команда logger отправляет лог в системный журнал):
```
#!/bin/bash
WORD=$1
LOG=$2
DATE=`date`

if grep $WORD $LOG &> /dev/null
then
   logger "$DATE: I found word, Master!"
else
   exit 0
fi
```
Создадим юнит для сервиса:
```
cd /etc/systemd/system
vi watchlog.service
```
Содержимое файла watchlog.service :
```
[Unit]
Description=My watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchlog
ExecStart=/opt/watchlog.sh $WORD $LOG
```
Создадим юнит для таймера:
```
vi watchlog.timer
```
Содержимое файла watchlog.timer:
```
[Unit]
Description=Run watchlog script every 30 second

[Timer]
# Run every 30 second
OnUnitActiveSec=30
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
```
Запускаем ~гуся, работяги~ timer:
```
systemctl start watchlog.timer
```
Проверить результат
```
tail -f /var/log/messages
```


2) Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно также называться.


[Здесь](https://github.com/Edo1993/otus_5/tree/master/spawn) vargrantfile, скрипты - при разворачивании vm можно проверить, что всё поднялось корректно командой 
```
systemctl status spawn-fcgi
```

Далее просто пошаговая инструкция.

Устанавливаем spawn-fcgi и необходимые для него пакеты:
```
yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y
```
Раскомментировать строки с переменными в /etc/sysconfig/spawn-fcgi, должен принять следующий вид

![Image alt](https://github.com/Edo1993/otus_5/raw/master/21.png)
Юнит файл имеет следующий вид ```vi /etc/systemd/system/spawn-fcgi.service```:
```
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target

[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n $OPTIONS
KillMode=process

[Install]
WantedBy=multi-user.target

```
Убеждаемся, что все успешно работает:
```
systemctl start spawn-fcgi
systemctl status spawn-fcgi
```
![Image alt](https://github.com/Edo1993/otus_5/raw/master/22.png)

3) Дополнить юнит-файл apache httpd возможностью запустить несколько инстансов сервера с разными конфигами

