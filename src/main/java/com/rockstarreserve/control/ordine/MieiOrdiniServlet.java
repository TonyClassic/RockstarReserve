package com.rockstarreserve.control.ordine;

import com.rockstarreserve.dao.OrdineDAO;
import com.rockstarreserve.model.Ordine;
import com.rockstarreserve.model.Utente;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class MieiOrdiniServlet extends HttpServlet {

    private final OrdineDAO ordineDAO = new OrdineDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utente utente = getUtenteLoggato(req);
        if (utente == null) {
            req.getSession(true).setAttribute("redirectAfterLogin",
                    req.getContextPath() + "/miei-ordini");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            List<Ordine> ordini = ordineDAO.findByUtente(utente.getId());
            req.setAttribute("ordini", ordini);
            req.setAttribute("dataUscita",
                    getServletContext().getInitParameter("dataUscitaGtaVI"));
            req.getRequestDispatcher("/WEB-INF/view/utente/miei-ordini.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Errore nel caricamento degli ordini", e);
        }
    }

    private Utente getUtenteLoggato(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        return (Utente) session.getAttribute("utente");
    }
}
