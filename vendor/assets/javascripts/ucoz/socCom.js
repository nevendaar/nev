// Original: http://s1.ucoz.net/src/socCom.js
// Last check: 2015-03-06 13:19:23 +0300

if (!window.uCoz) {window.uCoz = {};}
uCoz.socialComments = (function() {

	function setEternalCookie(name, value) {
		document.cookie = (name || 'oops') + '=' + encodeURIComponent(value || '') + '; path=/; expires=' + (new Date((new Date).getTime() + 1000*60*60*24*365)).toGMTString();
	};

	function getCookieEmail() {
		return decodeURIComponent( ( /socComEmail=\s*(.+?)\s*(?:;|$)/.exec(document.cookie) || {} )[1] || '' );
	};

	function timeWait(tryCount, interval, testFunction, onSuccess, onFailure) {
		window.console && console && console.info('timeWait: ' + tryCount);
		if( !tryCount ) {
			return onFailure && onFailure('timeout');
		};
		var done = testFunction ? testFunction() : 'nocb';
		if( done === 'abort' || done === 'nocb' ) {
			window.console && console.warn && console.warn('timeWait: ' + done);
			return;
		};
		if( done ) {
			window.console && console && console.info('timeWait: done');
			return onSuccess && onSuccess();
		};
		return setTimeout(function() {
			return timeWait(tryCount - 1, interval, testFunction, onSuccess, onFailure);
		}, interval);
	};

	var dontHandleLocationHash = false;

	var hashCommandHandlers = {
		reloadPage: function(command) {
			location.reload();
			dontHandleLocationHash = true;
		},
		gotoAddCommentForm: function(command) {
			var handled = false;
			var selector = '#postFormContent';
			var handler = function() {
				if( handled ) {
					window.console && console.warn && console.warn('gotoAddCommentForm: already handled.');
					return 'once';
				};
				var target = $(selector);
				if( !target.length ) {
					window.console && console.warn && console.warn('gotoAddCommentForm: target not found.');
					return;
				};
				setTimeout(function() {
					$('html, body').animate({
						scrollTop: ( target.eq(0).offset() || { top: 0 } ).top
					}, 'fast');
				}, 750);
				handled = true;
				return 'once';
			};
			if( typeof window.___uwbbCallbacks === 'array' ) {
				window.___uwbbCallbacks.push(handler);
			} else {
				window.___uwbbCallbacks = [handler];
			};
			$(document).ready(function() {
				timeWait(10, 500, function() { return handled ? 'abort' : $(selector).length ? true : false; }, handler);
			});
		}
	};

	function handleLocationHash() {
		if( dontHandleLocationHash || !location.hash ) return;
		var command = ( /^#([0-9a-zA-Z_-]+)(?:,|$)/.exec(location.hash) || {} )[1] || '';
		var handler = hashCommandHandlers[command];
		if( !handler ) return;
		try {
			var regexp = new RegExp('^#' + command + ',?');
			location.hash = location.hash.replace(regexp, '#');
			handler(command);
			window.console && console.info && console.info('handleLocationHash', command, 'ok');
		} catch(exception) {
			window.console && console.error && console.error('handleLocationHash', command, exception);
		}
	};

	var obj = {

		init: function() {
			handleLocationHash();
			$(window).bind('hashchange', handleLocationHash);
			if( /subscrOn=false/.test(document.cookie) ) {
				$(function() {
					var checkbox = $('input[name="subscribe"]');
					checkbox.prop('checked', false).removeAttr('checked').parents('.ucf-option-label').eq(0).removeClass('ucf-option-checked');
				});
			};
			var email = getCookieEmail();
			var emailInput = $('#acform input[name=email]').filter(':visible');
			if( email && emailInput.length ) {
				emailInput.val(email);
			};
			obj.addEventListeners();
		},

		getCookieEmail: getCookieEmail,

		addEventListeners: function() {
			$(function() {
				var form = $('#acform');
				obj.placeholderLegacy(form);
				form.find('.js-ucf-option').change(function(event) {
					if( $(this).attr('name') == 'subscribe' ) {
						setEternalCookie( 'subscrOn', ( $(this).prop('checked') ? 'true' : 'false' ) );
					};
					if ($(this).is('[name=share]') && $('input[name=anonymous]').prop('checked')) {
							$("input[name='share']").prop('checked',false);
							return;
					}
					if ($(this).is('[name=anonymous]') && $('input[name=share]').prop('checked')) {
							$("input[name='share']").prop('checked',false);
							$("input[name='share']").parent('label').removeClass('ucf-option-checked');
					}
					if ($(this).prop('checked')) {
						$(this).parent('label').addClass('ucf-option-checked');
					}
					else {
						$(this).parent('label').removeClass('ucf-option-checked');
					}
				}).trigger('change');

				$('#acform input[name=email]').change(function(event) {
					var email = $(this).val();
					if( email && !/^\s*$/.test(email) ) {
						setEternalCookie('socComEmail', email);
					};
				});

				var startTxt = form.find('.js-start-txt');
				startTxt.bind('change keydown keyup', function() {
					if($(this).scrollTop() > 0){
						$(this).css('height',$(this).scrollTop() + $(this).outerHeight());
					}
				});

				if( window.socialCommentsOnSubmit ) {
					var submitButton = $('#acform button.uf-btn');
					if( submitButton.length === 1 ) {
						submitButton.removeAttr('onclick').click(function(event) {
							event && event.preventDefault && event.preventDefault();
							window.preSaveMessage && preSaveMessage();
							window.socialCommentsOnSubmit && socialCommentsOnSubmit();
							return false;
						});
					};
				};

			});
		},

		placeholderLegacy: function(form) {
			$.support.placeholder = false;
			var test = document.createElement('input');
			if('placeholder' in test) $.support.placeholder = true;
			if (window.navigator && window.navigator.userAgent && (window.navigator.userAgent.indexOf('Presto') !== -1)) {$.support.placeholder = false;}

			if(!$.support.placeholder) {
				var phEls = form.find('[placeholder]');
				phEls.focus(function() {
					if ($(this).val() === $(this).attr('placeholder')) {
						$(this).val('');
					}
				}).blur(function() {
					if (($(this).val() !== $(this).attr('placeholder')) && !$(this).val()) {
						$(this).val($(this).attr('placeholder'));
					}
				}).blur();

				function formOnSubmit() {
					phEls.each(function() {
						if ($(this).val() === $(this).attr('placeholder')) {$(this).val('');}
					});
					setTimeout(function () {
						phEls.blur();
					}, 3000);
				}
				form.submit(function() {formOnSubmit();});
				$('#addcBut').click(function () {formOnSubmit();});
			}
		}
	};

	return {
		init: obj.init,
		getCookieEmail: obj.getCookieEmail
	};

}());
uCoz.socialComments.init();
