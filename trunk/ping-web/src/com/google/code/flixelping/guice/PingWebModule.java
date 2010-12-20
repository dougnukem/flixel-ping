package com.google.code.flixelping.guice;

import javax.jdo.PersistenceManagerFactory;

import com.google.code.flixelping.domain.dao.GameDAO;
import com.google.code.flixelping.persistence.jdo.PMF;
import com.google.inject.AbstractModule;
import com.google.inject.Scopes;

public class PingWebModule extends AbstractModule {

	@Override
	public void configure() {
		bind(PersistenceManagerFactory.class).toInstance(PMF.get());
		//bind(GameDAO.class).to(GameDAO.class).in(Scopes.SINGLETON);
	}
}
