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
