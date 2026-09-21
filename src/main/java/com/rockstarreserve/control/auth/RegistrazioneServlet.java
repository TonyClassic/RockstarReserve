package com.rockstarreserve.control.auth;

import com.rockstarreserve.dao.UtenteDAO;
import com.rockstarreserve.model.Utente;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

public class RegistrazioneServlet extends HttpServlet {

    private final UtenteDAO utenteDAO = new UtenteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("utente") != null) {
            resp.sendRedirect(req.getContextPath() + "/catalogo");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/view/auth/registrazione.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String nome     = req.getParameter("nome");
        String cognome  = req.getParameter("cognome");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String conferma = req.getParameter("confermaPassword");

        /* --- Validazione base --- */
        if (isBlank(nome) || isBlank(cognome) || isBlank(email)
                || isBlank(password) || isBlank(conferma)) {
            req.setAttribute("errore", "Tutti i campi sono obbligatori.");
            forward(req, resp);
            return;
        }

        if (!password.equals(conferma)) {
            req.setAttribute("errore", "Le password non coincidono.");
            req.setAttribute("nome", nome);
            req.setAttribute("cognome", cognome);
            req.setAttribute("email", email);
            forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("errore", "La password deve essere di almeno 6 caratteri.");
            req.setAttribute("nome", nome);
            req.setAttribute("cognome", cognome);
            req.setAttribute("email", email);
            forward(req, resp);
            return;
        }

        if (!email.contains("@") || !email.contains(".")) {
            req.setAttribute("errore", "Inserisci un indirizzo email valido.");
            req.setAttribute("nome", nome);
            req.setAttribute("cognome", cognome);
            forward(req, resp);
            return;
        }

        try {
            if (utenteDAO.existsByEmail(email.trim())) {
                req.setAttribute("errore", "Esiste giÃ  un account con questa email.");
                req.setAttribute("nome", nome);
                req.setAttribute("cognome", cognome);
                forward(req, resp);
                return;
            }

            Utente nuovo = new Utente();
            nuovo.setNome(nome.trim());
            nuovo.setCognome(cognome.trim());
            nuovo.setEmail(email.trim().toLowerCase());
            nuovo.setPassword(password);
            nuovo.setUsernameSteam("");

            utenteDAO.insert(nuovo);

            resp.sendRedirect(req.getContextPath() + "/login?registrato=1");

        } catch (SQLException e) {
            throw new ServletException("Errore database durante la registrazione", e);
        }
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/view/auth/registrazione.jsp").forward(req, resp);
    }

    private boolean isBlank(String s) {
        return s == null || s.isBlank();
    }
}
