package com.rockstarreserve.control;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  httpReq  = (HttpServletRequest)  req;
        HttpServletResponse httpResp = (HttpServletResponse) resp;

        HttpSession session = httpReq.getSession(false);
        String token = (session != null) ? (String) session.getAttribute("sessionToken") : null;

        if (token == null) {
            httpResp.sendRedirect(httpReq.getContextPath() + "/login");
            return;
        }

        chain.doFilter(req, resp);
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}
