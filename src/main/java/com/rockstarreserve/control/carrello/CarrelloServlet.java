package com.rockstarreserve.control.carrello;

import com.rockstarreserve.dao.EdizioneDAO;
import com.rockstarreserve.model.CarrelloItem;
import com.rockstarreserve.model.Edizione;
import com.rockstarreserve.model.Utente;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CarrelloServlet extends HttpServlet {

    private final EdizioneDAO edizioneDAO = new EdizioneDAO();

    /* ------------------------------------------------------------------ */
    /*  GET - visualizza carrello                                           */
    /* ------------------------------------------------------------------ */

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<CarrelloItem> items = getCarrello(req);

        BigDecimal totale = items.stream()
                .map(CarrelloItem::getSubtotale)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        req.setAttribute("items", items);
        req.setAttribute("totale", String.format("€%.2f", totale.setScale(2, RoundingMode.HALF_UP))
                                         .replace(".", ","));
        req.setAttribute("totaleRaw", totale);

        req.getRequestDispatcher("/WEB-INF/view/carrello/carrello.jsp").forward(req, resp);
    }

    /* ------------------------------------------------------------------ */
    /*  POST - azioni sul carrello                                          */
    /* ------------------------------------------------------------------ */

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "";

        List<CarrelloItem> items = getCarrello(req);

        try {
            switch (action) {
                case "aggiungi" -> {
                    int edizioneId = parseInt(req.getParameter("edizioneId"), 0);
                    int quantita   = parseInt(req.getParameter("quantita"), 1);
                    if (edizioneId > 0 && quantita > 0) {
                        aggiungi(items, edizioneId, quantita);
                    }
                }
                case "rimuovi" -> {
                    int edizioneId = parseInt(req.getParameter("edizioneId"), 0);
                    if (edizioneId > 0) rimuovi(items, edizioneId);
                }
                case "aggiorna" -> {
                    int edizioneId    = parseInt(req.getParameter("edizioneId"), 0);
                    int nuovaQuantita = parseInt(req.getParameter("quantita"), 1);
                    if (edizioneId > 0) aggiorna(items, edizioneId, nuovaQuantita);
                }
                case "svuota" -> items.clear();
                default -> {}
            }
        } catch (SQLException e) {
            throw new ServletException("Errore nel carrello", e);
        }

        salvaCarrello(req, items);

        boolean isAjax = "true".equals(req.getParameter("ajax"));
        if (isAjax) {
            BigDecimal nuovoTotale = items.stream()
                    .map(CarrelloItem::getSubtotale)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            int cartCount = items.stream().mapToInt(CarrelloItem::getQuantita).sum();

            StringBuilder json = new StringBuilder();
            json.append("{\"success\":true,");
            json.append("\"totale\":\"")
                .append(String.format("€%.2f", nuovoTotale.setScale(2, RoundingMode.HALF_UP))
                        .replace(".", ","))
                .append("\",");
            json.append("\"cartCount\":").append(cartCount).append(",");
            json.append("\"items\":[");
            for (int i = 0; i < items.size(); i++) {
                if (i > 0) json.append(",");
                CarrelloItem ci = items.get(i);
                json.append("{\"id\":").append(ci.getEdizioneId())
                    .append(",\"subtotale\":\"").append(ci.getSubtotaleFormattato())
                    .append("\",\"quantita\":").append(ci.getQuantita()).append("}");
            }
            json.append("]}");

            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write(json.toString());
        } else {
            resp.sendRedirect(req.getContextPath() + "/carrello");
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Logica carrello in sessione                                         */
    /* ------------------------------------------------------------------ */

    @SuppressWarnings("unchecked")
    public static List<CarrelloItem> getCarrello(HttpServletRequest req) {
        HttpSession session = req.getSession(true);
        List<CarrelloItem> items = (List<CarrelloItem>) session.getAttribute("carrello");
        if (items == null) {
            items = new ArrayList<>();
            session.setAttribute("carrello", items);
        }
        return items;
    }

    public static void salvaCarrello(HttpServletRequest req, List<CarrelloItem> items) {
        req.getSession(true).setAttribute("carrello", items);
    }

    private void aggiungi(List<CarrelloItem> items, int edizioneId, int quantita)
            throws SQLException {
        for (CarrelloItem item : items) {
            if (item.getEdizioneId() == edizioneId) {
                item.setQuantita(item.getQuantita() + quantita);
                return;
            }
        }
        Edizione e = edizioneDAO.findById(edizioneId);
        if (e != null) {
            CarrelloItem item = new CarrelloItem();
            item.setEdizioneId(edizioneId);
            item.setQuantita(quantita);
            item.setEdizione(e);
            items.add(item);
        }
    }

    private void rimuovi(List<CarrelloItem> items, int edizioneId) {
        items.removeIf(i -> i.getEdizioneId() == edizioneId);
    }

    private void aggiorna(List<CarrelloItem> items, int edizioneId, int nuovaQuantita) {
        if (nuovaQuantita <= 0) { rimuovi(items, edizioneId); return; }
        for (CarrelloItem item : items) {
            if (item.getEdizioneId() == edizioneId) {
                item.setQuantita(nuovaQuantita);
                return;
            }
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Helper                                                              */
    /* ------------------------------------------------------------------ */

    private int parseInt(String val, int fallback) {
        try {
            return Integer.parseInt(val);
        } catch (NumberFormatException | NullPointerException e) {
            return fallback;
        }
    }
}
