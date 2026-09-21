<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rockstarreserve.model.CarrelloItem" %>
<%@ page import="java.math.BigDecimal" %>
<%
    request.setAttribute("pageTitle", "Preordine Confermato");
    request.setAttribute("extraCss", "checkout.css");

    List<CarrelloItem> items = (List<CarrelloItem>) request.getAttribute("items");
    String metodo    = (String) request.getAttribute("metodo");
    String steam     = (String) request.getAttribute("steam");
    String dataUscita = (String) request.getAttribute("dataUscita");
    if (dataUscita == null) dataUscita = "19 novembre 2026";

    BigDecimal totaleConf = BigDecimal.ZERO;
    if (items != null) {
        for (CarrelloItem i : items) totaleConf = totaleConf.add(i.getSubtotale());
    }
    String totaleConfStr = "€" + totaleConf.setScale(2, java.math.RoundingMode.HALF_UP)
                                            .toPlainString().replace(".", ",");

    String metodoPretty = "Carta di credito";
    if ("paypal".equalsIgnoreCase(metodo)) metodoPretty = "PayPal";
%>
<%@ include file="/WEB-INF/view/common/header.jsp" %>
<%@ include file="/WEB-INF/view/common/navbar.jsp" %>

<main class="page-content">
<div style="max-width:680px; margin:0 auto; padding:60px 24px 100px;">

    <!-- Header conferma -->
    <div style="text-align:center; margin-bottom:48px;">
        <div style="font-size:4rem; margin-bottom:20px;">&#x2705;</div>
        <h1 style="font-size:clamp(2.5rem,7vw,4.5rem); text-transform:uppercase; margin-bottom:12px;">
            Preordine confermato!
        </h1>
        <p style="color:var(--text-secondary); font-size:1rem; line-height:1.7;">
            Grazie per il tuo preordine di <strong>Grand Theft Auto VI</strong>.
            Riceverai il gioco direttamente sulla tua libreria Steam il <strong><%= dataUscita %></strong>.
        </p>
    </div>

    <!-- Card riepilogo -->
    <div class="card" style="margin-bottom:24px;">
        <h2 style="font-size:1.1rem; text-transform:uppercase; letter-spacing:0.08em;
                   color:var(--text-muted); margin-bottom:24px; font-family:var(--font-body); font-weight:700;">
            Riepilogo preordine
        </h2>

        <!-- Edizioni ordinate -->
        <% if (items != null) { for (CarrelloItem ci : items) { %>
        <div style="display:flex; justify-content:space-between; align-items:center;
                    padding:14px 0; border-bottom:1px solid var(--border);">
            <div>
                <div style="font-weight:600; font-size:0.95rem;"><%= ci.getEdizione().getNome() %></div>
                <div style="font-size:0.78rem; color:var(--text-muted);">
                    Qtà: <%= ci.getQuantita() %> &bull; Digitale
                </div>
            </div>
            <span style="font-weight:700; color:var(--accent-orange);"><%= ci.getSubtotaleFormattato() %></span>
        </div>
        <% } } %>

        <!-- Totale -->
        <div style="display:flex; justify-content:space-between; align-items:baseline;
                    padding-top:20px; margin-top:4px;">
            <span style="font-size:0.85rem; font-weight:700; letter-spacing:0.06em;
                         text-transform:uppercase; color:var(--text-muted);">Totale pagato</span>
            <span style="font-family:var(--font-title); font-size:2rem;"><%= totaleConfStr %></span>
        </div>
    </div>

    <!-- Dettagli consegna -->
    <div class="card" style="margin-bottom:24px;">
        <h2 style="font-size:1.1rem; text-transform:uppercase; letter-spacing:0.08em;
                   color:var(--text-muted); margin-bottom:20px; font-family:var(--font-body); font-weight:700;">
            Dettagli consegna
        </h2>

        <div style="display:flex; flex-direction:column; gap:14px;">
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <span style="color:var(--text-muted); font-size:0.88rem;">Piattaforma</span>
                <span style="font-weight:600;">&#x1F3AE; Steam</span>
            </div>
            <div style="height:1px; background:var(--border);"></div>
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <span style="color:var(--text-muted); font-size:0.88rem;">Username Steam</span>
                <span style="font-weight:600; color:var(--accent-orange);"><%= steam != null ? steam : "—" %></span>
            </div>
            <div style="height:1px; background:var(--border);"></div>
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <span style="color:var(--text-muted); font-size:0.88rem;">Metodo di pagamento</span>
                <span style="font-weight:600;"><%= metodoPretty %></span>
            </div>
            <div style="height:1px; background:var(--border);"></div>
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <span style="color:var(--text-muted); font-size:0.88rem;">Data di consegna prevista</span>
                <span style="font-weight:700; color:var(--accent-pink);"><%= dataUscita %></span>
            </div>
        </div>
    </div>

    <!-- Info box countdown -->
    <div style="background:rgba(255,107,53,0.06); border:1px solid rgba(255,107,53,0.25);
                border-radius:var(--radius-lg); padding:24px; text-align:center; margin-bottom:32px;">
        <div style="font-family:var(--font-title); font-size:2rem; color:var(--accent-orange);
                    margin-bottom:8px;">19 NOVEMBRE 2026</div>
        <div style="font-size:0.88rem; color:var(--text-secondary);">
            GTA VI sarà disponibile sulla tua libreria Steam alle 00:01 (ora italiana).
        </div>
    </div>

    <!-- Azioni -->
    <div style="display:flex; gap:12px; flex-wrap:wrap; justify-content:center;">
        <a href="<%= request.getContextPath() %>/miei-ordini" class="btn btn-primary">
            &#x1F4CB; I miei preordini
        </a>
        <a href="<%= request.getContextPath() %>/catalogo" class="btn btn-secondary">
            Torna al catalogo
        </a>
    </div>

</div>
</main>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
