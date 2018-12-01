package kr.or.jg.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.google.gson.Gson;

import kr.or.jg.vo.ChatMessage;


public class EchoHandler extends TextWebSocketHandler {
	
	private static final Logger logger = LoggerFactory.getLogger(EchoHandler.class);
	
	private List<WebSocketSession> sessionList = new ArrayList<WebSocketSession>();
	private Gson gson = new Gson();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		sessionList.add(session);
		logger.info("{} open", session.getId());
	}
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		String msg = getMsg(session, message.getPayload());
		logger.info("msg {}", msg);
		notify(msg);
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		sessionList.remove(session);
		if (session.isOpen())
			session.close();
		logger.info("{} close", session.getId());
	}
	
	private void notify(String msg) throws IOException {
		for (WebSocketSession sess : sessionList) {
			if (!sess.isOpen()) {
				if (sessionList.contains(sess)) { sessionList.remove(sess); }
				continue;
			}
			sess.sendMessage(new TextMessage(msg));	
		}
	}
	
	private String getMsg(WebSocketSession session, String msg) {
		ChatMessage chatmsg = new ChatMessage();
		chatmsg.setId(session.getId());
		chatmsg.setMsg(msg);
		return gson.toJson(chatmsg);
	}
	
}
