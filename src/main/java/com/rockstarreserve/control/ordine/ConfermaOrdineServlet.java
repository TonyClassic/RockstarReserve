package com.rockstarreserve.control.ordine;

import com.rockstarreserve.model.Utente;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

public class ConfermaOrdineServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utente utente = getUtenteLoggato(req);
        if (utente == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("confermaItems") == null) {
            /* Nessun ordine appena confermato: manda ai miei ordini */
            resp.sendRedirect(req.getContextPath() + "/miei-ordini");
            return;
        }

        /* I dati sono stati messi in sessione da CheckoutServlet */
        req.setAttribute("items",  session.getAttribute("confermaItems"));
        req.setAttribute("metodo", session.getAttribute("confermaMetodo"));
        req.setAttribute("steam",  session.getAttribute("confermaSteam"));
        req.setAttribute("dataUscita",
                getServletContext().getInitParameter("dataUscitaGtaVI"));

        /* Rimuovi i dati dalla sessione */
        session.removeAttribute("confermaItems");
        session.removeAttribute("confermaMetodo");
        session.removeAttribute("confermaSteam");

        req.getRequestDispatcher("/WEB-INF/view/ordine/conferma-ordine.jsp").forward(req, resp);
    }

    private Utente getUtenteLoggato(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        return (Utente) session.getAttribute("utente");
    }
}
