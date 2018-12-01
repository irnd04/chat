
function scrolldown() {
	$(".chat-logs").scrollTop($(".chat-logs")[0].scrollHeight);
}

$(function() {
	$("#live-chat").hide();
	$("#chat-circle").click(function() {
		$(".chat-box").fadeIn();
	});

	$(".chat-close").click(function() {
		$(".chat-box").fadeOut();
	});
	
});