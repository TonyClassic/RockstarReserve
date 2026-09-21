package com.rockstarreserve.control.admin;

import com.rockstarreserve.dao.UtenteDAO;
import com.rockstarreserve.model.Utente;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class AdminUtentiServlet extends HttpServlet {

    private final UtenteDAO utenteDAO = new UtenteDAO();

    /* ------------------------------------------------------------------ */
    /*  GET â€” lista utenti                                                  */
    /* ------------------------------------------------------------------ */

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }

        try {
            List<Utente> utenti = utenteDAO.findAll();
            req.setAttribute("utenti", utenti);
            req.getRequestDispatcher("/WEB-INF/view/admin/admin-utenti.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Errore nel caricamento degli utenti", e);
        }
    }

    /* ------------------------------------------------------------------ */
    /*  POST â€” attiva / disattiva account                                   */
    /* ------------------------------------------------------------------ */

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }

        req.setCharacterEncoding("UTF-8");
        String action   = req.getParameter("action");
        String idParam  = req.getParameter("id");

        try {
            if (idParam != null && ("attiva".equals(action) || "disattiva".equals(action))) {
                int     id     = Integer.parseInt(idParam);
                boolean stato  = "attiva".equals(action);
                utenteDAO.setAttivo(id, stato);
            }
            String msg = "attiva".equals(action) ? "Account attivato." : "Account disattivato.";
            resp.sendRedirect(req.getContextPath() + "/admin/utenti?msg=" +
                    java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8));

        } catch (SQLException | NumberFormatException e) {
            throw new ServletException("Errore nella gestione dell'utente", e);
        }
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && Boolean.TRUE.equals(session.getAttribute("adminLoggato"));
    }
}
