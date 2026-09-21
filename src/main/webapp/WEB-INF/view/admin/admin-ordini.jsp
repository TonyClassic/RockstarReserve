<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rockstarreserve.model.Ordine" %>
<%@ page import="com.rockstarreserve.model.Utente" %>
<%
    request.setAttribute("pageTitle", "Admin — Ordini");
    request.setAttribute("extraCss", "admin.css");

    List<Ordine> ordini  = (List<Ordine>) request.getAttribute("ordini");
    List<Utente> utenti  = (List<Utente>) request.getAttribute("utenti");
    String dataInizio    = (String) request.getAttribute("dataInizio");
    String dataFine      = (String) request.getAttribute("dataFine");
    int utenteIdSel      = (Integer) (request.getAttribute("utenteIdSel") != null
                              ? request.getAttribute("utenteIdSel") : 0);
    boolean hasOrdini    = ordini != null && !ordini.isEmpty();
%>
<%@ include file="/WEB-INF/view/common/header.jsp" %>
<%@ include file="/WEB-INF/view/common/navbar.jsp" %>

<main class="page-content admin-page">

    <div class="admin-page-header">
        <div>
            <h1 class="admin-page-title">Gestione ordini</h1>
            <div class="admin-page-subtitle">Tutti i preordini di GTA VI</div>
        </div>
    </div>

    <div class="admin-content">

        <div class="admin-nav">
            <a href="<%= request.getContextPath() %>/admin/edizioni">Edizioni</a>
            <a href="<%= request.getContextPath() %>/admin/ordini" class="active">Ordini</a>
            <a href="<%= request.getContextPath() %>/admin/utenti">Utenti</a>
            <a href="<%= request.getContextPath() %>/catalogo">Vai al sito &#8599;</a>
        </div>

        <!-- Filtri -->
        <form action="<%= request.getContextPath() %>/admin/ordini" method="get"
              class="admin-filter-form">
            <div class="admin-filter-group">
                <label class="admin-filter-label">Data da</label>
                <input type="date" name="dataInizio" class="form-control"
                       value="<%= dataInizio != null ? dataInizio : "" %>">
            </div>
            <div class="admin-filter-group">
                <label class="admin-filter-label">Data a</label>
                <input type="date" name="dataFine" class="form-control"
                       value="<%= dataFine != null ? dataFine : "" %>">
            </div>
            <div class="admin-filter-group">
                <label class="admin-filter-label">Cliente</label>
                <select name="utenteId" class="form-control">
                    <option value="0">Tutti i clienti</option>
                    <% if (utenti != null) { for (Utente u : utenti) { %>
                    <option value="<%= u.getId() %>" <%= u.getId() == utenteIdSel ? "selected" : "" %>>
                        <%= u.getNomeCompleto() %> &lt;<%= u.getEmail() %>&gt;
                    </option>
                    <% } } %>
                </select>
            </div>
            <div style="display:flex; gap:8px; align-items:flex-end;">
                <button type="submit" class="btn btn-primary btn-sm">Filtra</button>
                <a href="<%= request.getContextPath() %>/admin/ordini" class="btn btn-secondary btn-sm">Reset</a>
            </div>
        </form>

        <!-- Contatore -->
        <div class="admin-count-info">
            <%= hasOrdini ? ordini.size() + " ordine/i trovate" : "Nessun ordine trovato" %>
        </div>

        <!-- Tabella ordini -->
        <div class="admin-table-wrap">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Cliente</th>
                        <th>Edizione</th>
                        <th>Importo</th>
                        <th>Pagamento</th>
                        <th>Steam</th>
                        <th>Data ordine</th>
                    </tr>
                </thead>
                <tbody>
                <% if (!hasOrdini) { %>
                <tr>
                    <td colspan="7" style="text-align:center; padding:40px;
                                           color:var(--text-muted);">
                        Nessun ordine trovato con i filtri selezionati.
                    </td>
                </tr>
                <% } else {
                    int rn = 1;
                    for (Ordine o : ordini) { %>
                <tr>
                    <td style="color:var(--text-muted);"><%= rn++ %></td>
                    <td>
                        <div class="primary"><%= o.getNomeCompletoUtente() %></div>
                        <div style="font-size:0.78rem; color:var(--text-muted);"><%= o.getEmailUtente() %></div>
                    </td>
                    <td class="primary"><%= o.getNomeEdizione() %></td>
                    <td style="font-weight:700; color:var(--accent-orange);"><%= o.getPrezzoEdizione() %></td>
                    <td>
                        <% if ("paypal".equalsIgnoreCase(o.getMetodoPagamento())) { %>
                            <span class="badge badge-orange">PayPal</span>
                        <% } else { %>
                            <span class="badge badge-gray">Carta</span>
                        <% } %>
                    </td>
                    <td style="color:var(--accent-orange); font-size:0.85rem;">
                        <%= o.getUsernameSteam() != null && !o.getUsernameSteam().isBlank()
                            ? o.getUsernameSteam() : "—" %>
                    </td>
                    <td style="font-size:0.82rem; white-space:nowrap;">
                        <%= o.getDataOrdine() != null
                            ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(o.getDataOrdine())
                            : "—" %>
                    </td>
                </tr>
                <% } } %>
                </tbody>
            </table>
        </div>

    </div>
</main>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
