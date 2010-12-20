package com.google.code.flixelping.guice;

import uk.co.chasetechnology.guice_blazeds.AbstractGuiceFactory;

import com.google.inject.Guice;
import com.google.inject.Injector;

public class GuiceFactory extends AbstractGuiceFactory {

	private Injector injector;

	public GuiceFactory() {
		injector = Guice.createInjector(new PingWebModule());
	}

	public <T> T createInjectedObject(Class<T> clazz) {
		return injector.getInstance(clazz);
	}
}
