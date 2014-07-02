// Заменяем MSN_ID на текстовые описания.
function set_userlist_msn(){
    $('tr td:nth-child(2)', '.uTable').each(function(i){
        var $this = $(this);
        var h = $this.html();
        if (~~h)
            $this.addClass('fraction-name' + h).html('&nbsp;');
    });
}

$(function () {
    // Ссылки на профили пользователей
    $('.profile-link').click(function () {
        window.open($(this).attr('href'), 'up1', 'scrollbars=1,top=0,left=0,resizable=1,width=750,height=420');
        return false;
    });

    // Ссылки для копирования информации
    $('.prompt-link').click(function () {
        var $this = $(this);
        prompt($this.attr('title'), $this.attr('href'));
        return false;
    });

    // Подключаем VK_API если нужно.
    if ($('main.content').hasClass('vk-init')) {
        VK.init({apiId: 2014686, onlyWidgets: true});

        // Подключаем ВКомментарии если нужно.
        var vk_uid = parseInt($('#vk_comments').attr('data-uid'));
        if (vk_uid) {
            VK.Widgets.Comments("vk_comments", {limit: 10}, vk_uid);
        }
    }
});
