<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rockstarreserve.model.CarrelloItem" %>
<%@ page import="com.rockstarreserve.model.Utente" %>
<%
    request.setAttribute("pageTitle", "Carrello");
    request.setAttribute("extraCss", "carrello.css");
    List<CarrelloItem> items  = (List<CarrelloItem>) request.getAttribute("items");
    String totale             = (String) request.getAttribute("totale");
    Utente utenteCarr         = (session != null) ? (Utente) session.getAttribute("utente") : null;
    boolean isEmpty = (items == null || items.isEmpty());
%>
<%@ include file="/WEB-INF/view/common/header.jsp" %>
<%@ include file="/WEB-INF/view/common/navbar.jsp" %>

<main class="page-content">
<div class="carrello-page">

    <h1 class="carrello-page-title">Carrello</h1>
    <p class="carrello-page-subtitle">
        <% if (!isEmpty) { %>
            <%= items.size() %> edizione<%= items.size() > 1 ? "i" : "" %> selezionata<%= items.size() > 1 ? "e" : "" %>
        <% } else { %>
            Il tuo carrello è vuoto
        <% } %>
    </p>

    <% if (isEmpty) { %>
    <div class="carrello-empty">
        <div class="carrello-empty-icon">&#128722;</div>
        <h2>Nessun articolo nel carrello</h2>
        <p>Scegli la tua edizione di GTA VI e aggiungila qui.</p>
        <a href="<%= request.getContextPath() %>/catalogo" class="btn btn-primary btn-lg">Vai al catalogo</a>
    </div>

    <% } else { %>

    <!-- Azioni testa -->
    <div class="carrello-actions-top">
        <a href="<%= request.getContextPath() %>/catalogo" class="btn btn-secondary">&#8592; Continua gli acquisti</a>
        <form action="<%= request.getContextPath() %>/carrello" method="post">
            <input type="hidden" name="action" value="svuota">
            <button type="submit" class="btn btn-danger btn-sm"
                    onclick="return confirm('Svuotare il carrello?')">&#128465; Svuota carrello</button>
        </form>
    </div>

    <!-- Tabella -->
    <div class="carrello-table-wrap">
        <table class="carrello-table">
            <thead>
                <tr>
                    <th>Edizione</th>
                    <th>Prezzo</th>
                    <th>Quantità</th>
                    <th>Subtotale</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
            <% for (CarrelloItem item : items) { %>
                <tr data-item-id="<%= item.getEdizioneId() %>">
                    <!-- Prodotto -->
                    <td>
                        <div class="cart-product-info">
                            <span class="cart-product-name"><%= item.getEdizione().getNome() %></span>
                            <span class="cart-product-desc"><%= item.getEdizione().getDescrizione() != null
                                ? (item.getEdizione().getDescrizione().length() > 80
                                    ? item.getEdizione().getDescrizione().substring(0, 80) + "…"
                                    : item.getEdizione().getDescrizione())
                                : "" %></span>
                            <span class="badge badge-orange" style="width:fit-content;margin-top:4px;">Digitale</span>
                        </div>
                    </td>

                    <!-- Prezzo unitario -->
                    <td class="cart-price"><%= item.getEdizione().getPrezzoFormattato() %></td>

                    <!-- Quantità con aggiornamento -->
                    <td>
                        <form action="<%= request.getContextPath() %>/carrello" method="post" class="qty-form">
                            <input type="hidden" name="action" value="aggiorna">
                            <input type="hidden" name="edizioneId" value="<%= item.getEdizioneId() %>">
                            <input type="number" name="quantita" class="qty-input"
                                   value="<%= item.getQuantita() %>" min="1" max="10">
                            <button type="submit" class="qty-update-btn">Aggiorna</button>
                        </form>
                    </td>

                    <!-- Subtotale -->
                    <td class="cart-subtotal"><%= item.getSubtotaleFormattato() %></td>

                    <!-- Rimuovi -->
                    <td>
                        <form action="<%= request.getContextPath() %>/carrello" method="post">
                            <input type="hidden" name="action" value="rimuovi">
                            <input type="hidden" name="edizioneId" value="<%= item.getEdizioneId() %>">
                            <button type="submit" class="cart-remove-btn"
                                    onclick="return confirm('Rimuovere questo articolo?')"
                                    title="Rimuovi">&#215;</button>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <!-- Nota digitale -->
    <div class="digital-note">
        <span class="icon">&#x1F3AE;</span>
        Il gioco è digitale. Alla conferma del preordine, GTA VI verrà consegnato sulla libreria Steam
        associata al tuo username Steam. Nessuna spedizione fisica.
    </div>

    <!-- Riepilogo totale -->
    <div class="carrello-summary">
        <div class="carrello-summary-box">
            <div class="summary-row">
                <span class="label">Articoli</span>
                <span class="value"><%= items.size() %></span>
            </div>
            <div class="summary-row">
                <span class="label">Spedizione</span>
                <span class="value" style="color: var(--success);">Digitale — gratuita</span>
            </div>
            <div class="summary-divider"></div>
            <div class="summary-total-row">
                <span class="summary-total-label">Totale</span>
                <span class="summary-total-amount"><%= totale %></span>
            </div>
            <div class="summary-actions">
                <% if (utenteCarr != null) { %>
                <a href="<%= request.getContextPath() %>/checkout" class="btn btn-primary btn-lg">
                    Procedi al checkout &#8594;
                </a>
                <% } else { %>
                <a href="<%= request.getContextPath() %>/login" class="btn btn-primary btn-lg">
                    Accedi per il checkout &#8594;
                </a>
                <a href="<%= request.getContextPath() %>/registrazione" class="btn btn-secondary">
                    Registrati gratis
                </a>
                <% } %>
            </div>
        </div>
    </div>

    <% } %>
</div>
</main>

<script>var CTX = '<%= request.getContextPath() %>';</script>
<script src="<%= request.getContextPath() %>/scripts/carrello.js"></script>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
