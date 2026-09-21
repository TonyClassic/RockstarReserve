<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rockstarreserve.model.Ordine" %>
<%@ page import="com.rockstarreserve.model.Utente" %>
<%
    request.setAttribute("pageTitle", "I miei preordini");
    request.setAttribute("extraCss", "carrello.css");

    List<Ordine> ordini   = (List<Ordine>) request.getAttribute("ordini");
    String dataUscita     = (String) request.getAttribute("dataUscita");
    if (dataUscita == null) dataUscita = "19 novembre 2026";
    Utente utenteOrd      = (Utente) session.getAttribute("utente");
    boolean hasOrdini     = ordini != null && !ordini.isEmpty();
%>
<%@ include file="/WEB-INF/view/common/header.jsp" %>
<%@ include file="/WEB-INF/view/common/navbar.jsp" %>

<main class="page-content">
<div style="max-width:900px; margin:0 auto; padding:60px 24px 100px;">

    <h1 style="font-size:clamp(2.5rem,6vw,4rem); text-transform:uppercase; margin-bottom:8px;">
        I miei preordini
    </h1>
    <p style="color:var(--text-muted); font-size:0.9rem; margin-bottom:48px;">
        Ciao, <strong style="color:var(--text-primary);"><%= utenteOrd.getNomeCompleto() %></strong>
        &mdash; questi sono i tuoi preordini di GTA VI.
    </p>

    <% if (!hasOrdini) { %>
    <div class="carrello-empty">
        <div class="carrello-empty-icon">&#x1F4CB;</div>
        <h2>Nessun preordine effettuato</h2>
        <p>Non hai ancora preordinato nessuna edizione di GTA VI.</p>
        <a href="<%= request.getContextPath() %>/catalogo" class="btn btn-primary btn-lg">
            Vai al catalogo
        </a>
    </div>

    <% } else { %>

    <!-- Info globale -->
    <div style="background:rgba(255,107,53,0.06); border:1px solid rgba(255,107,53,0.25);
                border-radius:var(--radius); padding:14px 20px; margin-bottom:28px;
                display:flex; align-items:center; gap:12px; font-size:0.88rem;">
        <span style="color:var(--accent-orange); font-size:1.1rem;">&#x1F3AE;</span>
        <span style="color:var(--text-secondary);">
            Tutti i tuoi preordini saranno consegnati su Steam il
            <strong style="color:var(--accent-orange);"><%= dataUscita %></strong>.
        </span>
    </div>

    <!-- Tabella ordini -->
    <div class="carrello-table-wrap">
        <table class="carrello-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Edizione</th>
                    <th>Data ordine</th>
                    <th>Pagamento</th>
                    <th>Steam</th>
                    <th>Stato</th>
                    <th>Importo</th>
                </tr>
            </thead>
            <tbody>
            <% int rowNum = 1; for (Ordine o : ordini) { %>
                <tr>
                    <td style="color:var(--text-muted); font-size:0.82rem;"><%= rowNum++ %></td>
                    <td>
                        <div style="font-weight:600; color:var(--text-primary);">
                            <%= o.getNomeEdizione() %>
                        </div>
                        <span class="badge badge-orange">Digitale</span>
                    </td>
                    <td style="color:var(--text-secondary); font-size:0.85rem; white-space:nowrap;">
                        <%= o.getDataOrdine() != null
                            ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(o.getDataOrdine())
                            : "—" %>
                    </td>
                    <td style="color:var(--text-secondary);">
                        <% if ("paypal".equalsIgnoreCase(o.getMetodoPagamento())) { %>
                            &#x1F4B0; PayPal
                        <% } else { %>
                            &#x1F4B3; Carta
                        <% } %>
                    </td>
                    <td style="color:var(--accent-orange); font-weight:600;">
                        <%= o.getUsernameSteam() != null && !o.getUsernameSteam().isBlank()
                            ? o.getUsernameSteam() : "—" %>
                    </td>
                    <td>
                        <span class="badge badge-orange">In attesa del <%= dataUscita %></span>
                    </td>
                    <td style="font-weight:700; color:var(--text-primary);">
                        <%= o.getPrezzoEdizione() %>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <div style="margin-top:32px; display:flex; gap:12px;">
        <a href="<%= request.getContextPath() %>/catalogo" class="btn btn-secondary">
            &#8592; Torna al catalogo
        </a>
    </div>

    <% } %>
</div>
</main>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
