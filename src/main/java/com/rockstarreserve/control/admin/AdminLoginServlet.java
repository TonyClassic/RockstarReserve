package com.rockstarreserve.control.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        /* Se giÃ  autenticato come admin, vai alla dashboard */
        HttpSession session = req.getSession(false);
        if (session != null && Boolean.TRUE.equals(session.getAttribute("adminLoggato"))) {
            resp.sendRedirect(req.getContextPath() + "/admin/edizioni");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/view/admin/admin-login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        String adminUser = getServletContext().getInitParameter("adminUsername");
        String adminPass = getServletContext().getInitParameter("adminPassword");

        if (adminUser.equals(username) && adminPass.equals(password)) {
            HttpSession session = req.getSession(true);
            session.setAttribute("adminLoggato", Boolean.TRUE);
            resp.sendRedirect(req.getContextPath() + "/admin/edizioni");
        } else {
            req.setAttribute("errore", "Credenziali amministratore non valide.");
            req.getRequestDispatcher("/WEB-INF/view/admin/admin-login.jsp").forward(req, resp);
        }
    }
}
