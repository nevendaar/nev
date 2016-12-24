$(function () {
    var $mc_window = $('#mc-window'),
        $mc_smiles = $('#mc-smiles'),
        $mc_refresh = $('#mchatRSel'),
        $mc_form = $('#MCaddFrm'),
        $mc_ok_btn = $('#mchatBtn'),
        $mc_load_icon = $('#mchatAjax'),
        $mc_msg_fld = $('#mchatMsgF'),
        $mc_refresh_btn = $('#mc-reload-btn'),
        $mc_limit_counter = $('#mc-length-counter'),
        char_limit = ~~$mc_msg_fld.attr('maxlength');
    if ($mc_window.length) {
        var load_messages = function () {
            $.ajax({
                url: '/mchat',
                cache: false,
                method: 'GET',
                dataType: 'html'
            }).done(function (html) {
                var $msg_body = $(html).children('div');
                $mc_window.html($msg_body);
            });
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
                        $mc_msg_fld.prop('readonly', false).val('').focus();
                        load_messages();
                    }
                });
                e.preventDefault();
            });
        // Form submit by CTRL + Enter
        $mc_msg_fld.bind('keydown', function (e) {
            if (e.keyCode == 13 && e.ctrlKey && !e.shiftKey) {
                e.preventDefault();
                $mc_ok_btn.click();
            }
        }).on('keyup focus', function () {
            var rst = char_limit - $mc_msg_fld.val().length;
            if (rst < 0) {
                rst = 0;
                // For IE & old Opera
                $mc_msg_fld.val($mc_msg_fld.val().substr(0, char_limit));
            }
            $mc_limit_counter.html(rst);
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

        // Paste username to message input
        $mc_window.on('click', '.mc_username', function () {
            $mc_msg_fld.val(
                '' + $mc_msg_fld.val() +
                '[i]' + $(this).text().replace('\n', '').trim() + '[/i], '
            ).focus();
            return false;
        });

        if ($mc_form.length && $mc_smiles.length) {
            var mc_d_smiles = {
                    ':)':        [':)', '/Smiley/smile3.gif'],
                    'flirt':     null,
                    '<_<':       ['<_<', '/Smiley/4.gif'],
                    ';)':        [';)', '/Smiley/2.gif'],
                    'grin':      true,
                    ':D':        [':D', '/Smiley/1.gif'],
                    'girl_haha': null,
                    ':p':        [':p', '/Smiley/blum2.gif'],
                    'blush':     true,
                    '^_^':       ['^_^', '/Smiley/3.gif'],
                    'spiteful':  [
                        '[img]http://www.kolobok.us/smiles/remake/spiteful.gif[/img]',
                        'http://www.kolobok.us/smiles/remake/spiteful.gif'
                    ],
                    'thinkin':   [':thinkin:', '/smiley2/thinkin.gif'],
                    'girl_sad':  null,
                    '>(':        ['>(', '/Smiley/6.gif'],
                    'cray':      true,
                    'scratch':   [':scratch:', '/Smiley/scratch_one-s_head.gif'],
                    'ok':        true,
                    'nea':       true,
                    'hi':        true,
                    'preved':    true,
                    'priest':    true,
                    'diablo':    true,
                    'skull':     true,
                    'moderator': true,
                    'dwarf':     true,
                    'elf':       true,
                    'orc':       true
                },
                mc_f_smiles = {
                    ':)':        [':girl_smile:', '/Smiley/girl_smile.gif'],
                    'flirt':     true,
                    ';)':        [':girl_wink:', '/Smiley/girl_wink.gif'],
                    'girl_haha': true,
                    ':p':        [':girl_blum:', '/Smiley/girl_blum.gif'],
                    'girl_sad':  true,
                    '>(':        [':girl_mad:', '/Smiley/girl_mad.gif'],
                    'cray':      [':girl_cray:', '/Smiley/girl_cray.gif'],
                    'diablo':    [':girl_devil:', '/Smiley/girl_devil.gif']
                },
                html_smiles = '';

            if (~~$mc_smiles.data('female') == 1)
                $.extend(mc_d_smiles, mc_f_smiles);

            var key, val, code, img_src;
            for (key in mc_d_smiles) if (mc_d_smiles.hasOwnProperty(key)) {
                val = mc_d_smiles[key];
                if (val === null) continue; // Smile only for girls
                // Simple smile: <img alt=":ok:" title="ok" src="/Smiley/ok.gif">
                if (val === true) {
                    code = ':' + key + ':';
                    img_src = '/Smiley/' + key + '.gif';
                }
                else if (val.length) {
                    code = val[0];
                    img_src = val[1];
                }
                html_smiles += '<img alt="' + code + '" title="' + key + '" src="' + img_src + '">\n';
            }
            $mc_smiles.html(html_smiles).on('click', 'img', function () {
                $mc_msg_fld.
                    val('' + $mc_msg_fld.val() + ' ' + $(this).attr('alt') + ' ').
                    focus();
            });
        }
    }
});
