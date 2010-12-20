package com.google.code.flixelping.remoting;

import java.util.Date;

public class EchoService {

	public String echo(String echoTxt) {
		return "Server says: I received '" + echoTxt + "' at " + new Date();
	}
}
