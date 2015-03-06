// Original: http://s1.ucoz.net/src/photopage.js
// Last check: 2015-03-06 13:19:23 +0300

window.processComments = {
    initialise: function(a, c, b, d) {
        var e = this;
        e.comPage = 0;
        e.comParentBlock = $("#photoModalWrap").find(a);
        e.comShowBtn = $(c);
        e.comAddBtn = $(b);
        e.comAddFrm = $(d);
        e.loadCmtsFlag = !0;
        e.comLoading = $("#modalCmtsLoading");
        $(e.comAddBtn).click(function(a) {
            a.preventDefault();
            $(this).parent().addClass("comAddOpened");
            window.processComments.posAddComBtn("position")
        });
        $("<a/>", {
            id: "hideComFrm",
            text: window.ulb.closeBtn,
            style: "margin-left: 5px"
        }).addClass("button").insertAfter("#addcBut").click(function() {
            $("#mphoto-addcmt").removeClass("comAddOpened");
            window.processComments.posAddComBtn("position")
        });
        e.commentsBuffer = null;
        e.commentsUrl = e.getCommentsUrl(window.photo.currentUrl);
        e.loadComments(e.commentsUrl.url, e.commentsUrl.entryId);
        $("#photoModalWrap").scroll(function(a) {
            e.loadCmtsFlag && $(window).height() + $("#photoModalWrap").scrollTop() + window.processComments.paddingBoottom >= $("#photoModalWrap")[0].scrollHeight && (window.processComments.comLoading.show(), e.loadComments(window.processComments.commentsUrl.url, window.processComments.commentsUrl.entryId));
            window.processComments.posAddComBtn("reposition")
        });
        window.processComments.posAddComBtn("position");
        $(window).resize(function() {
            $("#photoModalWrap").length && window.processComments.posAddComBtn("position")
        });
        e.paddingBoottom = parseInt($(".fancybox-outer").css("padding-bottom"), 10) + parseInt($(".fancybox-wrap").css("padding-bottom"), 10);
        e.paddingTop = parseInt($(".fancybox-outer").css("padding-top"), 10) + parseInt($(".fancybox-wrap").css("padding-top"), 10);
        window.processComments.posAddComBtn("position")
    },
    posAddComBtn: function(a) {
        var c = $("#mphoto-addcmt"),
            b = $("#photoModalWrap").find("#u-photo").outerHeight(),
            d = c.outerHeight(),
            e = $("#photoModalWrap").find("#u-photo").width();
        "position" === a && c.width(e);
        $(window).height() + $("#photoModalWrap").scrollTop() + this.paddingBoottom < $("#photoModalWrap")[0].scrollHeight ? ($("#dynPhoto").css("padding-bottom", d + "px"), c.addClass("fixedAddComBtn"), c.css("margin-left", -e / 2), a = $(window).height() + $("#photoModalWrap").scrollTop() - b - this.paddingTop - d, 0 <= a ? c.css("bottom",
            "0px") : c.css("bottom", a + "px")) : (c.removeClass("fixedAddComBtn"), c.css("margin-left", 0), $("#dynPhoto").css("padding-bottom", "0px"))
    },
    getCommentsUrl: function(a) {
        a = window.photo.getLastDigitFromUrl(a);
        var c = a.digit;
        return {
            url: window.photo.getLastDigitFromUrl(a.substrUrl).substrUrl,
            entryId: c
        }
    },
    loadComments: function(a, c) {
        var b = this;
        b.comPage += 1;
        $.ajax({
            url: a + "-" + b.comPage + "-" + c + "-24",
            data: "json",
            error: function(a, c, f) {
                console.log(c + ", " + f);
                b.comments = null;
                window.processComments.comLoading.hide()
            },
            success: function(a,
                c) {
                window.processComments.comLoading.hide();
                if (null === a.comments || "" === a.comments) console.log("no comments"), null !== b.commentsBuffer && b.insertComments(b.commentsBuffer), b.comShowBtn.hide(), b.commentsBuffer = null, b.loadCmtsFlag = !1;
                else {
                    var f = $("<div/>", {
                        style: "display: none;",
                        html: a.comments
                    });
                    console.log("got comments");
                    null === b.commentsBuffer ? (b.insertComments(f), 1 !== b.comPage && (b.commentsBuffer = f), b.loadComments(b.commentsUrl.url, b.commentsUrl.entryId)) : (2 !== b.comPage && b.insertComments(b.commentsBuffer),
                        b.commentsBuffer = f)
                }
            }
        })
    },
    insertComments: function(a) {
        this.commentsBuffer = a;
        this.comParentBlock.append(a);
        a.fadeIn(200);
        window.processComments.posAddComBtn("reposition")
    }
};
window.photo = {
    init: function() {
        $("#u-photos").length ? window.photo.root = $("#u-photos") : window.photo.root = $("#uEntriesList");
        window.photo.details = window.photo.root.find(".ph-js-details");
        window.photo.modalDetails = $("#photoModalWrap").find(".ph-js-details");
        window.photo.root.find(".ph-author").click(function(a) {
            a.stopPropagation();
            a.preventDefault()
        });
        window.photo.detailsInit(window.photo.details, "window.photo.details");
        $("body").click(function() {
            window.photo.details.removeClass("phr-opened");
            window.photo.modalDetails.removeClass("phr-opened")
        });
        badBrowser && ($(".photo-expand").hover(function() {
            $(this).addClass("hovered")
        }, function() {
            $(this).removeClass("hovered")
        }), $("#oldPhotos").delegate("a", "click", function(a) {
            window.location.href = $(this).attr("href")
        }));
        if ("undefined" !== typeof uShowLightboxPage && uShowLightboxPage) {
            Object.size = function(a) {
                var b = 0,
                    d;
                for (d in a) a.hasOwnProperty(d) && b++;
                return b
            };
            window.photo.currentShownPage = window.photo.photoVars.currentPage;
            window.photo.pageUrlMask = window.photo.photoVars.pageUrlMask.replace("%a", "2");
            window.photo.photoVars.photoIds.length = Object.size(window.photo.photoVars.photoIds);
            var a = function(a, b) {
                a.preventDefault();
                window.photo.popupEvent = !1;
                var c = b.attr("href");
                window.photo.getRealUrl(c, function(h){
                	for (var d = h.split("#")[0].split("/");
                	    "photo" !== d[d.length - 2];) d.splice(d.length - 2, 1), d.join("/");
                	d = d.join("/");
                	window.photo.modalId = window.photo.getLastDigitFromUrl(d).digit;
                	d = d.split("/");
                	d.splice(-1, 1, "0-0-" + window.photo.modalId);
                	d = d.join("/");
                	window.photo.fakeLoad(d, window.photo.loadModal)
                })
            };
            window.photo.root.find(".photo-title a, .phd-comments").click(function(c) {
                window.photo.currentShownPage =
                    window.photo.photoVars.currentPage;
                a(c, $(this));
                return !1
            });
            if ($.isFunction($.fn.live)) $(".ulb-photopage-link").live("click", function(c) {
                a(c, $(this));
                return !1
            });
            else $(".ulb-photopage-link").on("click", function(c) {
                a(c, $(this));
                return !1
            });
            window.photo.originalTitle = $("title").text();
            window.photo.autoFancyClose = !1;
            window.photo.popupEvent = !1;
            window.history && history.pushState && !navigator.userAgent.match(/(iPad|iPhone|iPod)/g) && (window.photo.historyModern = !0, window.history.replaceState({
                    ucozPhoto: !0
                }, null,
                window.location.href), window.onpopstate = function(a) {
                a.state && window.photo.processPopstate()
            });
            window.photo.processPopstate();
            $(window).keydown(function(a) {
                window.photo.nextLink && "text" !== a.target.type && "textarea" !== a.target.type && (39 === a.keyCode ? window.photo.nextLink.click() : 37 === a.keyCode && window.photo.prevLink.click())
            })
        }
    },
    processPopstate: function() {
        window.photo.popupEvent = !0;
        window.photo.autoFancyClose = !1;
        var a;
        $.each(location.search.substring(1).split("&"), function(c) {
            a = a || this.split("photo=")[1]
        });
        a ? window.photo.fakeLoad("//" + location.hostname + "/photo/0-0-" + a, window.photo.loadModal) : $.fancybox && (window.photo.autoFancyClose = !1, $.fancybox.close())
    },
    fakeLoad: function(a, c) {
        window.photo.historyModern ? (window.photo.currentUrl = a, console.log("loading..."), $.fancybox.showLoading(), window.photo.modalId = window.photo.getLastDigitFromUrl(a).digit, window.photo.popupEvent ? window.photo.autoFancyClose = !1 : (window.photo.autoFancyClose = !0, window.history.pushState({
                ucozPhoto: !0
            }, null, window.location.pathname + "?photo=" +
            window.photo.modalId)), c(a)) : window.location.href = a
    },
    loadModal: function(a) {
        var c = this;
        a += "-22";
        var b = "photo-" + window.photo.modalId;
        console.log("ID: " + b);
        var d = $("<div/>", {
            id: b,
            style: "display: none"
        }).appendTo("body");
        $.ajax({
            url: a,
            error: function(a, b, d) {
                console.log(b + ", " + d);
                c.comments = null
            },
            success: function(a, c) {
                if (window.uCoz && window.uCoz.uwbb && !window.photo.popupEvent) {
                    var g = window.uCoz.uwbb.instances.pop();
                    if (!g) return;
                    var h = g.$txtArea;
                    g.destroy();
                    h.remove();
                    $("textarea.commFl").wysibb()
                }
                d.html(a.currentPhoto).find("#acform").hide();
                $.fancybox({
                    fitToView: !1,
                    autoHeight: !0,
                    scrolling: "no",
                    minWidth: parseInt(window.photo.pagePhotoWidth, 10) + 40,
                    maxWidth: parseInt(window.photo.pagePhotoWidth, 10) + 240,
                    href: "#" + b,
                    padding: 10,
                    preload: 5,
                    openEffect: "fade",
                    closeEffect: "fade",
                    nextEffect: "fade",
                    prevEffect: "fade",
                    openEasing: "linear",
                    nextEasing: "linear",
                    prevEasing: "linear",
                    fixed: fixedFlag,
                    beforeShow: function() {
                        $(".fancybox-wrap").wrap('<div id="photoModalWrap"></div>').wrap('<div id="fakeArrowsBlock"></div>');
                        window.photo.addNavArrows(window.photo.currentUrl);
                        $("body").css({
                            overflow: "hidden"
                        });
                        document.title = $("#dynPhoto").find(".photo-etitle").text() + " - " + window.photo.originalTitle;
                        window.photo.autoFancyClose = !1;
                        window.photo.popupEvent = !1
                    },
                    afterShow: function() {
                        $("#fancybox-overlay").css("z-index", 10005);
                        window.processComments.initialise("#allEntries", "#mphoto-showcmt", "#mphoto-addcmt-btn", "#acform");
                        window.photo.modalDetails = $("#photoModalWrap").find(".ph-js-details");
                        window.photo.detailsInit(window.photo.modalDetails, "window.photo.modalDetails");
                        if (window.addcom &&
                            window.uCoz && window.uCoz.uwbb) {
                            var a = window.addcom;
                            window.addcom = function() {
                                window.uCoz.uwbb.syncAll();
                                a()
                            }
                        }
                    },
                    beforeClose: function() {
                        window.photo.autoFancyClose || window.photo.popupEvent || window.photo.historyModern && window.history.pushState({
                            ucozPhoto: !0
                        }, null, window.location.href.replace(window.location.search, ""));
                        document.title = window.photo.originalTitle;
                        window.photo.popupEvent = !1;
                        window.photo.autoFancyClose = !1
                    },
                    afterClose: function() {
                        $("body").css({
                            overflow: "auto"
                        });
                        $("#photoModalWrap").remove();
                        $("#" + b).remove()
                    },
                    helpers: {
                        title: null,
                        overlay: {
                            opacity: 0.6,
                            speedIn: 0,
                            speedOut: 0
                        }
                    },
                    keys: {
                        next: {},
                        prev: {}
                    }
                })
            }
        })
    },
    getNextPrevIds: function(a) {
        function c(a, c) {
            d = "next" === c ? f + 1 : f - 1;
            b = window.photo.photoVars.photoIds[window.photo.currentShownPage][d];
            "undefined" === typeof b && ("next" === c ? (e = "undefined" !== typeof window.photo.photoVars.photoIds[window.photo.currentShownPage + 1] ? window.photo.currentShownPage + 1 : 1, window.photo.nextBtnPage = e) : (e = "undefined" !== typeof window.photo.photoVars.photoIds[window.photo.currentShownPage -
                1] ? window.photo.currentShownPage - 1 : window.photo.photoVars.photoIds.length, window.photo.prevBtnPage = e), window.photo.photoVars.photoIds[e] ? b = "next" === c ? window.photo.photoVars.photoIds[e][0] : window.photo.photoVars.photoIds[e][window.photo.photoVars.photoIds[e].length - 1] : $.ajax({
                url: window.photo.pageUrlMask.replace("%p", e),
                async: !1,
                error: function(a, b, c) {
                    console.log(b + ", " + c)
                },
                success: function(a, d) {
                    b = "next" === c ? a[0] : a[a.length - 1];
                    window.photo.photoVars.photoIds[e] = a
                }
            }));
            return b
        }
        var b, d, e;
        a = parseInt(a,
            10);
        window.photo.currentId = a;
        var f = window.photo.photoVars.photoIds[window.photo.currentShownPage].indexOf(a);
        window.photo.nextBtnPage = window.photo.currentShownPage;
        window.photo.prevBtnPage = window.photo.currentShownPage;
        return {
            next: c(a, "next"),
            prev: c(a, "prev")
        }
    },
    addNavArrows: function(a) {
        var c = this,
            b = window.photo.getLastDigitFromUrl(a);
        a = b.substrUrl;
        var d = window.photo.getNextPrevIds(b.digit),
            b = d.next,
            d = d.prev,
            e = $("#photoModalWrap");
        c.prevLink = $("<a/>", {
            href: a + "-" + d,
            html: "<span></span>",
            style: "display: none;"
        }).addClass("fancybox-nav modalArrow fancybox-prev").attr("data-changepage",
            window.photo.prevBtnPage);
        c.nextLink = c.prevLink.clone().attr("href", a + "-" + b).attr("data-changepage", window.photo.nextBtnPage).removeClass("fancybox-prev").addClass("fancybox-next");
        $.each([c.prevLink, c.nextLink], function() {
        	var j = this;
            j.insertBefore(e).fadeIn();
            j.click(function(a) {
                a.preventDefault();
                window.photo.autoFancyClose = !0;
                c.getRealUrl($(j).attr("href"),function(href){
                	if(href){
                		c.fakeLoad(href, c.loadModal);
                		window.photo.currentShownPage = parseInt($(j).data("changepage"), 10);
                	}
                })
                return !1
            })
        });
        a = $("<a/>").addClass("fakeArrow").attr("data-target",
            ".fancybox-prev");
        b = a.clone().attr("data-target", ".fancybox-next").addClass("fakeArrowNext");
        $.each([a, b], function() {
            e.find("#fakeArrowsBlock").append(this);
            this.hover(function() {
                $($(this).data("target")).addClass("hovered")
            }, function() {
                $($(this).data("target")).removeClass("hovered")
            });
            this.click(function() {
                $($(this).data("target")).trigger("click")
            })
        })
    },
    getLastDigitFromUrl: function(a) {
        for (var c, b = -1;
            "-" != c && "/" != c;) b -= 1, c = a.slice(b, b + 1);
        c = a.slice(b + 1);
        a = a.slice(0, b);
        return {
            substrUrl: a,
            digit: c
        }
    },
    detailsInit: function(a, c) {
        a.find(".phd-rating").click(function(b) {
            b = $(this).parent();
            b.hasClass("phr-opened") || (a.removeClass("phr-opened"), b.addClass("phr-opened"));
            return !1
        });
        a.find(".phd-dorating").each(function() {
            $(this).find("a").length || $(this).find(".u-current-rating").css("visibility", "visible");
            $(this).click(function() {
                $(this).find(".u-current-rating").css("visibility", "visible");
                setTimeout(c + ".removeClass('phr-opened')", 900);
                return !1
            })
        })
    },
    getRealUrl: function(e, t){
    	$.ajax({
    	    headers: {
    	        getlink: 1
    	    },
    	    url: e,
    	    dataType: 'json',
    	    success: function(p) {
    	    	if (p.photo_id && p.album_id) {
                	href = "/photo/" + p.album_id + "-0-" + p.photo_id;
                	if(t){
                		t(href);
                	}
                }
    	    }
    	})
    }
};
var badBrowser = !1;
$(document).ready(function() {
    $.browser ? $.browser.msie && 10 > $.browser.version && "BackCompat" == document.compatMode && (badBrowser = !0) : document.documentMode && 10 > document.documentMode && (badBrowser = !0);
    window.photo.init()
});
