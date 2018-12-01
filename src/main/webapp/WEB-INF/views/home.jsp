<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>

<!doctype html>
<html lang="ko">
<head>
<c:set var="ctx">${pageContext.request.contextPath}</c:set>
<meta charset="UTF-8">
<title>Live Chat</title>
<meta name="viewport"
	content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<link rel="stylesheet" href="${ctx }/resources/css/common.css">
<script type="text/javascript"
	src="${ctx }/resources/js/jquery-3.1.0.min.js"></script>
<script type="text/javascript" src="${ctx }/resources/js/global.js"></script>
<script type="text/javascript" src="${ctx }/resources/js/uuidv4.js"></script>
<script type="text/javascript" src="${ctx }/resources/js/sockjs.min.js"></script>
</head>

<body>
	<div id="chat-circle" class="btn btn-raised">
		<div id="chat-overlay"></div>
		<img src="${ctx }/resources/img/icon.png">
	</div>

	<div class="chat-box" style="display: block;">
		<div class="chat-box-header">
			<h3>Live Chat</h3>
			<p>anonymous</p>
			<span class="chat-box-toggle chat-close"> <i
				class="material-icons"> <img
					src="${ctx }/resources/img/close.png" width="15px;">
			</i>
			</span>
		</div>
		<div class="chat-box-body">
			<div class="chat-box-overlay"></div>
			<div class="chat-logs"></div>
			<!--chat-log -->
		</div>
		<div class="chat-input">
			<form onsubmit="return sendMessage();">
				<%-- <button type="submit" class="chat-file" id="chat-file">
					<i class="material-icons"> <img src="${ctx }/resources/img/file.png">
					</i>
				</button> --%>

				<input type="text" id="chat-input" placeholder="Send a message..." autocomplete="off">

				<button type="submit" class="chat-submit" id="chat-submit">
					<i class="material-icons"> <img
						src="${ctx }/resources/img/send.png"></i>
				</button>
			</form>
		</div>
	</div>
	
	<script>
		var sock = null;
		var cursessionid = uuidv4();
	
		$(function() {
			sock = new SockJS('<c:url value="/echo" />', [], {
				sessionId : function() {
					return cursessionid;
				}
			});
	
			sock.onmessage = onMessage;
			sock.onclose = onClose;
		});
		
		function sendMessage() {
			var msg = $("#chat-input").val();
			if (msg.trim() !== "") {
				sock.send($("#chat-input").val());
				$("#chat-input").val('');	
			}
			return false;
		}
		
		function onMessage(e) {
			var res = JSON.parse(e.data);
			var type = 'user';
			var phtml = "";

			sessionid = res['id'];
			message = res['msg'];

			if (sessionid == cursessionid) {
				type = 'self';
			}

			phtml += '<div id="cm-msg-id" class="chat-msg ' + type + '" style="">';
			phtml += '<span class="msg-avatar"><img src="${ctx }/resources/img/profile.png"></span>';
			phtml += '<div class="cm-msg-text">' + message + '</div>';
			phtml += '</div>';

			$(".chat-logs").append(phtml);
			scrolldown();
		}
		
		function onClose(e) { }

	</script>

</body>

</html>