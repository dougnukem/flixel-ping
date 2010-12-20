package com.google.code.flixelping.remoting;

import java.util.List;

import javax.jdo.annotations.Transactional;

import com.google.code.flixelping.domain.Game;
import com.google.code.flixelping.domain.dao.GameDAO;
import com.google.inject.Inject;

public class GameService {

	private GameDAO dao;

	@Inject
	public GameService(GameDAO dao) {
		this.dao = dao;
	}

	@Transactional
	public Game createNewGame(String peerID) {
		return dao.createGame(peerID);
	}

	@Transactional
	public List<Game> getActiveGames() {
		return dao.getActiveGames();
	}
	
	@Transactional
	public Game refreshGame(Long gameId) {
		return dao.refreshGame(gameId);
	}
}
