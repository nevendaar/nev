Changelog
=========

## First refactoring

* Переход на блочную верстку.
* Вынесение части кода в подключаемые css и js файлы.
* Срараемся соблюдать идеалогию "ненавязчивого" javascript.
* Вместо $PROFILE_URL$, генерирующего ужас:
```html
<a href="javascript://" rel="nofollow" onclick="window.open('http://site.ru/index/8-1','up1','scrollbars=1,top=0,left=0,resizable=1,width=680,height=350');return false;">Tester</a>
```
используется класс `profile-link` и любая валидная ссылка на профиль (`/index/8-$USER_ID$` или `/index/8-0-$USERNAME$`) в атрибуте `href`.
* Для указания пользовательской фракции использовать класс `fraction-name$_MSN$`, для отображения знамени:
```html
<span class="fraction-flag fflag$_MSN$"></span>
```
А для вывода текстового описания ранга:
```html
<span class="rank-$_RANK$-$_MSN$ <?if($_GENDER_ID$='2')?>rank-$_RANK$-$_MSN$-f<?endif?>"></span>
```
* Для всех prompt-ссылок добавлен единый класс `prompt-link`, который активирует нужный js-скрипт.
Для его использования нужно заполнить аттрибуты `title` и `href`.
* Добавлен новый глобальный блок: `$GLOBAL_AJAXJS$`. Он содержит в себе стандартные подключаемые (css, js) файлы.
При сохранении система прячет код `$AJAX_JS$`, следует учитывать это при необходимости редактирования шаблона.
