package com.rockstarreserve.control.auth;

import com.rockstarreserve.dao.CarrelloDAO;
import com.rockstarreserve.dao.UtenteDAO;
import com.rockstarreserve.model.Utente;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

public class LoginServlet extends HttpServlet {

    private final UtenteDAO   utenteDAO   = new UtenteDAO();
    private final CarrelloDAO carrelloDAO = new CarrelloDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("utente") != null) {
            resp.sendRedirect(req.getContextPath() + "/catalogo");
            return;
        }
        if (session != null && Boolean.TRUE.equals(session.getAttribute("adminLoggato"))) {
            resp.sendRedirect(req.getContextPath() + "/admin/edizioni");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        if (isBlank(email) || isBlank(password)) {
            req.setAttribute("errore", "Inserisci email e password.");
            req.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(req, resp);
            return;
        }

        /* ---- 1. Controllo admin (context-param) ---- */
        String adminEmail = getServletContext().getInitParameter("adminUsername");
        String adminPass  = getServletContext().getInitParameter("adminPassword");

        if (email.trim().equalsIgnoreCase(adminEmail) && password.equals(adminPass)) {
            HttpSession oldSession = req.getSession(false);
            if (oldSession != null) oldSession.invalidate();
            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("adminLoggato", Boolean.TRUE);
            newSession.setAttribute("sessionToken", UUID.randomUUID().toString());
            resp.sendRedirect(req.getContextPath() + "/admin/edizioni");
            return;
        }

        /* ---- 2. Controllo utente normale (DB) ---- */
        try {
            Utente utente = utenteDAO.findByEmail(email.trim());

            if (utente == null || !utente.getPassword().equals(password)) {
                req.setAttribute("errore", "Credenziali non valide.");
                req.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(req, resp);
                return;
            }

            if (!utente.isAttivo()) {
                req.setAttribute("errore", "Account disattivato. Contatta l'assistenza.");
                req.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(req, resp);
                return;
            }

            /* Trasferisci carrello guest */
            String oldSessionId = null;
            HttpSession oldSession = req.getSession(false);
            if (oldSession != null) {
                oldSessionId = oldSession.getId();
                oldSession.invalidate();
            }

            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("utente", utente);
            newSession.setAttribute("sessionToken", UUID.randomUUID().toString());

            if (oldSessionId != null) {
                carrelloDAO.trasferisciSessioneAUtente(oldSessionId, utente.getId());
            }

            String redirect = (String) newSession.getAttribute("redirectAfterLogin");
            if (redirect != null) {
                newSession.removeAttribute("redirectAfterLogin");
                resp.sendRedirect(redirect);
            } else {
                resp.sendRedirect(req.getContextPath() + "/catalogo");
            }

        } catch (SQLException e) {
            throw new ServletException("Errore database durante il login", e);
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.isBlank();
    }
}
