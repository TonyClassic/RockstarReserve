package com.rockstarreserve.control.ordine;

import com.rockstarreserve.control.carrello.CarrelloServlet;
import com.rockstarreserve.dao.OrdineDAO;
import com.rockstarreserve.dao.UtenteDAO;
import com.rockstarreserve.model.CarrelloItem;
import com.rockstarreserve.model.Ordine;
import com.rockstarreserve.model.Utente;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class CheckoutServlet extends HttpServlet {

    private final OrdineDAO ordineDAO = new OrdineDAO();
    private final UtenteDAO utenteDAO = new UtenteDAO();

    /* ------------------------------------------------------------------ */
    /*  GET â€” mostra checkout (richiede login)                             */
    /* ------------------------------------------------------------------ */

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utente utente = getUtenteLoggato(req);
        if (utente == null) {
            req.getSession(true).setAttribute("redirectAfterLogin",
                    req.getContextPath() + "/checkout");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<CarrelloItem> items = CarrelloServlet.getCarrello(req);

        if (items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/carrello");
            return;
        }

        req.setAttribute("items", items);
        req.setAttribute("utente", utente);

        String fase = req.getParameter("fase");
        if ("paypal".equals(fase)) {
            req.setAttribute("fase", "paypal");
        } else {
            req.setAttribute("fase", "scelta");
        }

        req.getRequestDispatcher("/WEB-INF/view/ordine/checkout.jsp").forward(req, resp);
    }

    /* ------------------------------------------------------------------ */
    /*  POST â€” crea ordine per ogni item nel carrello                      */
    /* ------------------------------------------------------------------ */

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        Utente utente = getUtenteLoggato(req);
        if (utente == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String usernameSteam    = req.getParameter("usernameSteam");
        String metodoPagamento  = req.getParameter("metodoPagamento");
        String fase             = req.getParameter("fase");

        /* --- Fase 1: scelta metodo â†’ se PayPal mostra pagina simulazione --- */
        if ("scelta".equals(fase)) {
            if (isBlank(usernameSteam)) {
                req.setAttribute("errore", "Inserisci il tuo username Steam.");
                doGet(req, resp);
                return;
            }
            if (isBlank(metodoPagamento)) {
                req.setAttribute("errore", "Seleziona un metodo di pagamento.");
                doGet(req, resp);
                return;
            }

            /* Salva dati in sessione per usarli dopo la simulazione PayPal */
            HttpSession session = req.getSession();
            session.setAttribute("checkoutUsernameSteam", usernameSteam.trim());
            session.setAttribute("checkoutMetodoPagamento", metodoPagamento);

            if ("paypal".equals(metodoPagamento)) {
                resp.sendRedirect(req.getContextPath() + "/checkout?fase=paypal");
            } else {
                /* Carta: processa direttamente */
                processaOrdini(req, resp, utente, usernameSteam.trim(), metodoPagamento);
            }
            return;
        }

        /* --- Fase 2: conferma PayPal simulata â†’ processa ordini --- */
        if ("paypal-conferma".equals(fase)) {
            HttpSession session = req.getSession(false);
            String steam  = session != null ? (String) session.getAttribute("checkoutUsernameSteam") : null;
            String metodo = session != null ? (String) session.getAttribute("checkoutMetodoPagamento") : null;

            if (steam == null || metodo == null) {
                resp.sendRedirect(req.getContextPath() + "/checkout");
                return;
            }
            processaOrdini(req, resp, utente, steam, metodo);
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Helper â€” processa gli ordini e redirect a conferma                 */
    /* ------------------------------------------------------------------ */

    private void processaOrdini(HttpServletRequest req, HttpServletResponse resp,
                                  Utente utente, String usernameSteam, String metodoPagamento)
            throws ServletException, IOException {

        try {
            List<CarrelloItem> items = CarrelloServlet.getCarrello(req);

            if (items.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/carrello");
                return;
            }

            /* Aggiorna username Steam dell'utente */
            utenteDAO.updateUsernameSteam(utente.getId(), usernameSteam);
            utente.setUsernameSteam(usernameSteam);
            req.getSession().setAttribute("utente", utente);

            /* Controlla se l'utente ha già ordinato una delle edizioni nel carrello */
            for (CarrelloItem item : items) {
                if (ordineDAO.esisteOrdine(utente.getId(), item.getEdizioneId())) {
                    req.setAttribute("errore", "Hai già preordinato l'edizione \""
                        + item.getEdizione().getNome() + "\". Non è possibile acquistarla due volte.");
                    req.setAttribute("fase", "scelta");
                    req.setAttribute("items", items);
                    req.setAttribute("utente", utente);
                    req.getRequestDispatcher("/WEB-INF/view/ordine/checkout.jsp").forward(req, resp);
                    return;
                }
            }

            /* Crea un ordine per ogni edizione nel carrello */
            for (CarrelloItem item : items) {
                for (int i = 0; i < item.getQuantita(); i++) {
                    Ordine ordine = new Ordine();
                    ordine.setUtenteId(utente.getId());
                    ordine.setEdizioneId(item.getEdizioneId());
                    ordine.setMetodoPagamento(metodoPagamento);
                    ordine.setPrezzoEdizione(item.getEdizione().getPrezzoFormattato());
                    ordineDAO.insert(ordine);
                }
            }

            /* Svuota carrello */
            CarrelloServlet.salvaCarrello(req, new java.util.ArrayList<>());

            /* Pulisci attributi sessione checkout */
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("checkoutUsernameSteam");
                session.removeAttribute("checkoutMetodoPagamento");
            }

            /* Passa dati riepilogo alla pagina di conferma */
            req.getSession().setAttribute("confermaItems", items);
            req.getSession().setAttribute("confermaMetodo", metodoPagamento);
            req.getSession().setAttribute("confermaSteam", usernameSteam);

            resp.sendRedirect(req.getContextPath() + "/conferma-ordine");

        } catch (SQLException e) {
            throw new ServletException("Errore durante la creazione dell'ordine", e);
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Helper                                                              */
    /* ------------------------------------------------------------------ */

    private Utente getUtenteLoggato(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        return (Utente) session.getAttribute("utente");
    }

    private boolean isBlank(String s) {
        return s == null || s.isBlank();
    }
}
