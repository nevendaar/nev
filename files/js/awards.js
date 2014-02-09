function replacer(){
    $.get('/index/54-$_USER_ID$', function(data){//nevendaar.com
        cont=$('cmd:last', data).text().replace(/Предметы/ig, 'Инвентарь').replace(/Богатство/ig, 'Заклинания').replace(/AwL/ig, 'AwLD').replace(/\{url:'\/index\/54-$_USER_ID$-/ig, '\'<div align=&#34;left&#34;><img alt=&#34;&#34; src=&#34;http://s29.ucoz.net/.s/img/wd/6/ajax.gif&#34;></div>\');set_content(').replace(/'\}\);/ig, ');');
        _uWnd.content('AwL',cont);
    });
}
function set_content(id){
    $.get('/index/54-$_USER_ID$-'+id, function(data){
        title=$('cmd:first', data).text();//nevendaar.com
        jscr='<script'+' type="text/javascript">'+$('cmd:eq(1)', data).text()+'</'+'script>';
        cont=$('cmd:last', data).text().replace(/Все награды/ig, '').replace(/>\[</ig, '><').replace(/>\]</ig, '><')<?if($GROUP_ID$!="4" && $GROUP_ID$!="3" && $GROUP_ID$!="14")?>.replace(/\[\/url\]/ig, '</a>').replace(/\[url=/ig, '<a target="_blank" href="').replace(/\]/ig, '">')<?endif?>;
        _uWnd.content('AwLD',cont+jscr);
        _uWnd.setTitle('AwLD',title);
    });
}

$(function () {
    // See awards link
    $('#see_user_awards').click(function () {
        var params = {autosizeonimages:1, maxh:300, minh:100, closeonesc:1};
        new _uWnd('AwL', 'Список наград', 380, 200, params, '<div align="left"><img alt="" border="0" src="http://s29.ucoz.net/.s/img/wd/6/ajax.gif"></div>');
        replacer();
        return false;
    });
});
