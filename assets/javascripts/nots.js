// New on the site script
$(document).on('click', '.add_to_nots_btn', function () {
    var NOTS_CATEGORY_ID = 5;
    var title = $('.nots-title').text(),
        target_url = '' + window.location,
        brief = ('' + $('.nots-brief').text()).replace(/\n/g, '').trim();
    // Get SSID first
    $.get('/dir/' + NOTS_CATEGORY_ID + '-0-0-0-1', function (html) {
        var ssid = $('input[name="ssid"]:first', html).val();
        $.post('/dir/', {
                jkd498: 1,
                jkd428: 1,
                ocat: NOTS_CATEGORY_ID,
                title: title,
                slink: target_url,
                brief: brief,
                edttbrief: 2,
                format_brief: 1,
                a: 12,
                ssid: ssid,
                numi: 1
            },
            function (p, s) {
                if (s == 'success') {
                    alert('Добавлено в блок "Новое на сайте"');
                }
                else {
                    alert('Что-то пошло не так :(');
                }
            }
        );
    });
    return false;
});
