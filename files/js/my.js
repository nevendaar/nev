function activate_menu(module_id, uri_id){
    $("#site_menu .slider").hide();
    $("#site_menu .dropdown-link").click(function(){
        $(this).parent().parent().children(".slider:first").slideToggle('fast');
        return false;
    });
    var gen_href = function(){
        if(uri_id == 'page1')              return '/';
        else if(/^ldCat\d+$/.test(uri_id)) return '/load/'    + uri_id.substr(5);
        else if(/^puCat\d+$/.test(uri_id)) return '/publ/'    + uri_id.substr(5);
        else if(/^page\d+$/.test(uri_id))  return '/index/0-' + uri_id.substr(4);
        return null;
    }
    var href;
    if($.inArray(module_id, ['news', 'faq', 'photo', 'blog']) >= 0){
        href = '/' + module_id;
    }
    else{
        var reserved = {
            page48: "/index/0-38",
            page49: "/index/0-38",
            page60: "/index/0-53",
            page61: "/index/0-53",
            page62: "/index/0-53",
            page63: "/index/0-53",
            page64: "/index/0-53",
            page65: "/index/0-54",
            page66: "/index/0-54",
            page67: "/index/0-54",
            page68: "/index/0-46",
            page69: "/index/0-46",
            page70: "/index/0-46",
            page71: "/index/0-46",
            page73: "/index/0-45",
            page74: "/index/0-45",
            page75: "/index/0-45",
            page76: "/index/0-45",
            page77: "/index/0-45",
            puCat12: "/publ/8",
            puCat15: "/publ/11",
            puCat16: "/publ/10",
            puCat17: "/publ/9",
            puCat18: "/publ/11",
            puCat23: "/publ/13",
            puCat24: "/publ/10"
        }
        if((href = reserved[uri_id]) === undefined){
            href = gen_href();
            if(href === null){
                if(module_id == 'load'){
                    href = '/load/6';
                }
                else if(module_id == 'dir' && uri_id != 'drCat5'){
                    href = '/dir/6';
                }
                //else default here
            }
        }
    }
    var $link = $("#site_menu a[href='" + href + "']:first");
    var $blk;
    $link.parent().addClass('active');
    if($link.hasClass('dropdown-link')){
        $blk = $link.parent().next('.slider');
    }
    else{
        $blk = $link.parent().parent().parent();
    }
    if($blk.hasClass('slider')){
        $blk.show();
        $blk.prev().addClass('active');
    }
}
