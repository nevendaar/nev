$(function () {
    var $mc_window = $('#mc-window'),
        $mc_refresh = $('#mchatRSel'),
        $mc_form = $('#MCaddFrm'),
        $mc_ok_btn = $('#mchatBtn'),
        $mc_load_icon = $('#mchatAjax'),
        $mc_msg_fld = $('#mchatMsgF'),
        $mc_refresh_btn = $('#mc-reload-btn');
    if ($mc_window.length) {
        var load_messages = function () {
            $mc_window.load('/mchat div:eq(1)');
        };
        load_messages();

        // Refresh message box by click
        $mc_refresh_btn.click(load_messages);

        // Form submit
        $mc_form.
            removeAttr('onsubmit').
            submit(function (e) {
                $mc_ok_btn.hide();
                $mc_load_icon.show();
                $mc_msg_fld.prop('readonly', true);
                _uPostForm($mc_form, {
                    type: 'POST',
                    url: '/mchat/?' + (Math.random() * 1000000000),
                    success: function () {
                        $mc_ok_btn.show();
                        $mc_load_icon.hide();
                        $mc_msg_fld.prop('readonly', false).val('');
                        load_messages();
                    }
                });
                e.preventDefault();
            });
        // Form submit by CTRL + Enter
        $mc_msg_fld.bind('keydown', function (e) {
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
