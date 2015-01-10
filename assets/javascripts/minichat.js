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
        var refresh_interval_id = -1,
            refresh_interval_active = false;

        var set_refresh_period = function () {
            var period = parseInt($mc_refresh.val()) || 0;
            document.cookie = "mcrtd=" + period + "; path=/";
            if (refresh_interval_active) {
                clearInterval(refresh_interval_id);
                refresh_interval_active = false;
            }
            if (period > 0) {
                refresh_interval_id = setInterval(load_messages, period * 1000);
                refresh_interval_active = true;
            }
        };

        $mc_refresh.change(set_refresh_period);

        // Get period from cookie
        var res = document.cookie.match(/(\W|^)mcrtd=([0-9]+)/);
        if (res) {
            $mc_refresh.val(parseInt(res[2]));
            set_refresh_period();
        }
    }
});
