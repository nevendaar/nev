// New on the site script
$(document).on('click', '.add_to_nots_btn', function () {
    var NOTS_CATEGORY_ID = 5;
    var TG_UTIL_URL = 'https://nev-telegram.herokuapp.com';
    var $news_title_blk = $('.news-title');

    var title = $('.nots-title').text(),
        news_title = $news_title_blk.text(),
        target_url = '' + window.location,
        brief = ('' + $('.nots-brief').text()).replace(/\n/g, '').trim();

    var $nots_btn = $('<button>', {type: 'button'}).text('Добавить в блок ННС');
    var post_to_nots = function () {
        $nots_btn.prop('disabled', true).text('    ...    ');
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
                        $nots_btn.text('Добавлено в блок "Новое на сайте"');
                    }
                    else {
                        $nots_btn.text('Что-то пошло не так :(');
                    }
                }
            );
        });
        return false;
    };
    $nots_btn.click(post_to_nots);

    var iframe_src = TG_UTIL_URL +
        '?title=' + encodeURIComponent(news_title) +
        '&text=' + encodeURIComponent(brief.replace(/\[i\]/g, '<i>').replace(/\[\/i\]/g, '</i>')) +
        '&ref_url=' + encodeURIComponent(target_url);
    var $iframe = $('<iframe>', {
        src: iframe_src,
        width: '100%',
        height: '100%'
    }).one('load', function () {
        $nots_btn.insertBefore($iframe);
        $('<hr>').insertBefore($iframe);
    });

    var nots_modal = new _uWnd(
        'nots-modal',
        'Новое на сайте',
        450,
        380,
        {
            autosize: 1,
            maxh: 450,
            minh: 300,
            maxw: 550,
            minw: 350,
            closeonesc: 1
        },
        ''
    );
    nots_modal.content($iframe);

    return false;
});
