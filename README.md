ConductorWine
=============

Shell script with GUI interface to easly manage Wine versions to run Windows apps on Linux

Author: Airvikar http://ubuntu-wine.ru


Modified and translated by: Demontager http://nixtalk.com



ENG:

Script to manage additional Wine versions and his prefixes

Features: 

1. Install\choose additional 32-bit Wine versions (from POL archive);

2. Create\choose deferent Wine prefixes;

3. Software instalation in new or existing prefix and defining Wine version;
 
4. If you already have a few Wine versions and prefixes, there is a way to choose from and install software where required;

5. Script also offers winetricks to install additional components if needed; 

6. Creates a folder named Control(wine-version) in predefined prefix and copy below files in it:

winecfg.sh -  Wine configuration;

regedit.sh - register editor;

winetricks.sh -  to launch winetricks;

loader.sh - install\run Windows software.


Don't forget to make ConductorWine.sh executable.

Any questions, please ask on: http://ubuntu-wine.ru
==========================================================



RUS:


Скрипт для работы с дополнительными версиями Wine и их префиксами

Возможности: 

1. Установка\выбор дополнительных 32-bit версий Wine (из POL архива);

2. Создание\выбор разных префиксов Wine;

3. Установка программы в новый или уже существующий префикс, с указанием используемой версии Wine;
 
4. Если у Вас уже установлено несколько версий Wine и префиксов, то имеется возможность выбрать на какой версии Wine и в каком префиксе будет установлена программа;
 
5. Скрипт предлагает, так же, запуск winetricks, для установки дополнительных компонентов, при необходимости;
 
6. Создает в указанном Вами префиксе папку Control(wine-version), в которую будут помещены файлы: 

winecfg.sh - для запуска настройки Wine;

regedit.sh - для запуска настройки реестра;

winetricks.sh - для запуска Winetricks;

loader.sh - для запуска\установки программ Windows.


Не забудьте сделать скрипт ConductorWine.sh исполняемым.

По вопросам обращаться на сайт: http://ubuntu-wine.ru



