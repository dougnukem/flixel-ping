package com.google.code.flixelping;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;


public class LoginFilter implements Filter {

	private FilterConfig filterConfig;

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain filterChain) throws IOException, ServletException {
		
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        if (user != null) {
            filterChain.doFilter(request, response);
        } else {
        	res.sendRedirect(userService.createLoginURL(req.getRequestURI()));
        }
	}

	@Override
	public void init(FilterConfig config) throws ServletException {
		this.filterConfig = config;
	}

}
