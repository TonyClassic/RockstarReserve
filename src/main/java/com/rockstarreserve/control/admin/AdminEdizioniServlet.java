package com.rockstarreserve.control.admin;

import com.rockstarreserve.dao.EdizioneDAO;
import com.rockstarreserve.model.Edizione;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class AdminEdizioniServlet extends HttpServlet {

    private final EdizioneDAO edizioneDAO = new EdizioneDAO();

    /* ------------------------------------------------------------------ */
    /*  GET â€” lista edizioni + eventuale form modifica                     */
    /* ------------------------------------------------------------------ */

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }

        try {
            List<Edizione> edizioni = edizioneDAO.findAll();
            req.setAttribute("edizioni", edizioni);

            /* Se action=modifica carica anche l'edizione da modificare */
            String action    = req.getParameter("action");
            String idParam   = req.getParameter("id");
            if ("modifica".equals(action) && idParam != null) {
                Edizione da = edizioneDAO.findById(Integer.parseInt(idParam));
                req.setAttribute("edizioneModifica", da);
            }

            req.getRequestDispatcher("/WEB-INF/view/admin/admin-edizioni.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Errore nel caricamento delle edizioni", e);
        }
    }

    /* ------------------------------------------------------------------ */
    /*  POST â€” inserisci / modifica / elimina                              */
    /* ------------------------------------------------------------------ */

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            switch (action == null ? "" : action) {
                case "inserisci" -> {
                    Edizione e = buildFromForm(req);
                    edizioneDAO.insert(e);
                    redirect(resp, req, "Edizione inserita con successo.");
                }
                case "modifica" -> {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Edizione e = buildFromForm(req);
                    e.setId(id);
                    edizioneDAO.update(e);
                    redirect(resp, req, "Edizione aggiornata con successo.");
                }
                case "elimina" -> {
                    int id = Integer.parseInt(req.getParameter("id"));
                    edizioneDAO.delete(id);
                    redirect(resp, req, "Edizione eliminata.");
                }
                default -> resp.sendRedirect(req.getContextPath() + "/admin/edizioni");
            }
        } catch (SQLException | NumberFormatException e) {
            throw new ServletException("Errore nell'operazione sull'edizione", e);
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Helper                                                              */
    /* ------------------------------------------------------------------ */

    private Edizione buildFromForm(HttpServletRequest req) {
        Edizione e = new Edizione();
        e.setNome(req.getParameter("nome").trim());
        e.setDescrizione(req.getParameter("descrizione").trim());
        e.setPrezzo(new BigDecimal(req.getParameter("prezzo").replace(",", ".")));
        e.setContenuti(req.getParameter("contenuti").trim());
        return e;
    }

    private void redirect(HttpServletResponse resp, HttpServletRequest req, String msg)
            throws IOException {
        resp.sendRedirect(req.getContextPath() + "/admin/edizioni?msg=" +
                java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8));
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && Boolean.TRUE.equals(session.getAttribute("adminLoggato"));
    }
}
