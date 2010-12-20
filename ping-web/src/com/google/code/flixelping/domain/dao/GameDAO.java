package com.google.code.flixelping.domain.dao;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.jdo.PersistenceManager;
import javax.jdo.PersistenceManagerFactory;

import com.google.code.flixelping.domain.Game;
import com.google.inject.Inject;

public class GameDAO {
	
	private static final Logger log = Logger.getLogger(GameDAO.class.getName());

	private PersistenceManagerFactory pmf;
	
	private static long MAX_TIME_ELAPSED_ACTIVE = 30000;

	@Inject 
	public GameDAO(PersistenceManagerFactory pmf) {
		this.pmf = pmf;
	}
	
	public Game createGame(String peerID) {
		Game game = new Game(peerID);
		PersistenceManager pm = pmf.getPersistenceManager();
        try {
            pm.makePersistent(game);
        } catch(Exception e) {
			log.logp(Level.SEVERE, "GameDAO", "createGame", "Exception createGame peerID: " + peerID, e);
		} finally {
            pm.close();
        }

		return game;
	}
	
	public Game refreshGame(Long gameID) {
		Game game = null;
		PersistenceManager pm = pmf.getPersistenceManager();
        try {
           game = (Game) pm.getObjectById(Game.class, gameID);
           if (game != null) {
        	   game.setLastActive(new Date(System.currentTimeMillis()));
           }
        } catch(Exception e) { 
        	log.logp(Level.SEVERE, "GameDAO", "refreshGame", "Exception refreshing game: "+ gameID, e);
        } finally {
            pm.close();
        }

		return game;
	}
	
	public List<Game> getActiveGames() {
		List<Game> games = new ArrayList<Game>();
		PersistenceManager pm = pmf.getPersistenceManager();
		try {
		    String query = "select from " + Game.class.getName();
		    games = new ArrayList<Game>((List<Game>) pm.newQuery(query).execute());
		    
		    Iterator<Game> gameIterator = games.iterator();

		    //Cleanup inactive game records
		    while(gameIterator.hasNext()) {
		    	Date currentTime = new Date(System.currentTimeMillis());
		    	Game game = gameIterator.next();
		    	long timeSinceLastRefresh = currentTime.getTime() - game.getLastActive().getTime();
		    	
		    	if (timeSinceLastRefresh > MAX_TIME_ELAPSED_ACTIVE) {
		    		//Delete inactive records
		    		gameIterator.remove();
		    		pm.deletePersistent(game);
		    	}
		    }
		} catch(Exception e) {
			log.logp(Level.SEVERE, "GameDAO", "getActiveGames", "Exception getActiveGames game: ", e);
		} finally {
			pm.close();
		}
	    
		return games;
	}
}
