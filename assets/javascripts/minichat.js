$(function () {
    var $mc_window = $('#mc-window'),
        $mc_refresh = $('#mchatRSel'),
        $mc_form = $('#MCaddFrm'),
        $mc_refresh_btn = $('#mc-reload-btn');
    if ($mc_window.length) {
        var load_messages = function () {
            $mc_window.load('/mchat div:eq(1)');
            return false;
        };
        load_messages();

        // Refresh message box by click
        $mc_refresh_btn.click(load_messages);

        // Form submit
        $mc_form.
            removeAttr('onsubmit').
            submit(function (e) {
                $('#mchatBtn').css({display: 'none'});
                $('#mchatAjax').css({display: ''});
                _uPostForm('MCaddFrm', {
                    type: 'POST',
                    url: '/mchat/?' + (Math.random() * 1000000000)
                });
                e.preventDefault();
            });
        // Form submit by CTRL + Enter
        $('#mchatMsgF').bind('keydown', function (e) {
            if (e.keyCode == 13 && e.ctrlKey && !e.shiftKey) {
                e.preventDefault();
                $mc_form.submit();
            }
        });

        // Auto refresh message box
    }
});
