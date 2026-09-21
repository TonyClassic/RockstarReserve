package com.rockstarreserve.control.admin;

import com.rockstarreserve.dao.OrdineDAO;
import com.rockstarreserve.dao.UtenteDAO;
import com.rockstarreserve.model.Ordine;
import com.rockstarreserve.model.Utente;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class AdminOrdiniServlet extends HttpServlet {

    private final OrdineDAO  ordineDAO  = new OrdineDAO();
    private final UtenteDAO  utenteDAO  = new UtenteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }

        try {
            String dataInizio  = req.getParameter("dataInizio");
            String dataFine    = req.getParameter("dataFine");
            String utenteParam = req.getParameter("utenteId");
            int    utenteId    = 0;
            try {
                if (utenteParam != null && !utenteParam.isBlank())
                    utenteId = Integer.parseInt(utenteParam);
            } catch (NumberFormatException ignored) {}

            List<Ordine> ordini = ordineDAO.findByFiltri(dataInizio, dataFine, utenteId);
            List<Utente> utenti = utenteDAO.findAll();  /* per il filtro select */

            req.setAttribute("ordini",      ordini);
            req.setAttribute("utenti",      utenti);
            req.setAttribute("dataInizio",  dataInizio);
            req.setAttribute("dataFine",    dataFine);
            req.setAttribute("utenteIdSel", utenteId);

            req.getRequestDispatcher("/WEB-INF/view/admin/admin-ordini.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Errore nel caricamento degli ordini", e);
        }
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && Boolean.TRUE.equals(session.getAttribute("adminLoggato"));
    }
}
