$(function () {
    // Ссылки для копирования информации
    $('.mc_username').click(function () {
        //              window.parent ???
        $('#mchatMsgF', parent.window.document).html(input.html() + '[i]' + $(this).html() + '[/i], ').focus();
        return false;
    });
});
