<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rockstarreserve.model.Utente" %>
<%
    request.setAttribute("pageTitle", "Admin — Utenti");
    request.setAttribute("extraCss", "admin.css");

    List<Utente> utenti = (List<Utente>) request.getAttribute("utenti");
    String msg          = request.getParameter("msg");
    boolean hasUtenti   = utenti != null && !utenti.isEmpty();
%>
<%@ include file="/WEB-INF/view/common/header.jsp" %>
<%@ include file="/WEB-INF/view/common/navbar.jsp" %>

<main class="page-content admin-page">

    <div class="admin-page-header">
        <div>
            <h1 class="admin-page-title">Gestione utenti</h1>
            <div class="admin-page-subtitle">Utenti registrati alla piattaforma</div>
        </div>
    </div>

    <div class="admin-content">

        <div class="admin-nav">
            <a href="<%= request.getContextPath() %>/admin/edizioni">Edizioni</a>
            <a href="<%= request.getContextPath() %>/admin/ordini">Ordini</a>
            <a href="<%= request.getContextPath() %>/admin/utenti" class="active">Utenti</a>
            <a href="<%= request.getContextPath() %>/catalogo">Vai al sito &#8599;</a>
        </div>

        <% if (msg != null && !msg.isBlank()) { %>
        <div class="admin-msg">&#x2713; <%= msg %></div>
        <% } %>

        <div class="admin-count-info">
            <%= hasUtenti ? utenti.size() + " utente/i registrati" : "Nessun utente registrato" %>
        </div>

        <div class="admin-table-wrap">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Nome</th>
                        <th>Email</th>
                        <th>Username Steam</th>
                        <th>Stato</th>
                        <th>Azioni</th>
                    </tr>
                </thead>
                <tbody>
                <% if (!hasUtenti) { %>
                <tr>
                    <td colspan="6" style="text-align:center; padding:40px; color:var(--text-muted);">
                        Nessun utente registrato.
                    </td>
                </tr>
                <% } else {
                    int rn = 1;
                    for (Utente u : utenti) { %>
                <tr>
                    <td style="color:var(--text-muted);"><%= rn++ %></td>
                    <td class="primary"><%= u.getNomeCompleto() %></td>
                    <td style="color:var(--text-secondary)"><%= u.getEmail() %></td>
                    <td style="color:var(--accent-orange); font-size:0.85rem;">
                        <%= u.getUsernameSteam() != null && !u.getUsernameSteam().isBlank()
                            ? u.getUsernameSteam() : "—" %>
                    </td>
                    <td>
                        <% if (u.isAttivo()) { %>
                        <span class="badge badge-green">&#10003; Attivo</span>
                        <% } else { %>
                        <span class="badge badge-red">&#10005; Disattivato</span>
                        <% } %>
                    </td>
                    <td>
                        <div class="table-actions">
                            <% if (u.isAttivo()) { %>
                            <form action="<%= request.getContextPath() %>/admin/utenti" method="post"
                                  onsubmit="return confirm('Disattivare l\'account di <%= u.getNomeCompleto() %>?')">
                                <input type="hidden" name="action" value="disattiva">
                                <input type="hidden" name="id"     value="<%= u.getId() %>">
                                <button type="submit" class="btn btn-danger btn-sm">
                                    &#10005; Disattiva
                                </button>
                            </form>
                            <% } else { %>
                            <form action="<%= request.getContextPath() %>/admin/utenti" method="post">
                                <input type="hidden" name="action" value="attiva">
                                <input type="hidden" name="id"     value="<%= u.getId() %>">
                                <button type="submit" class="btn btn-success btn-sm">
                                    &#10003; Riattiva
                                </button>
                            </form>
                            <% } %>
                        </div>
                    </td>
                </tr>
                <% } } %>
                </tbody>
            </table>
        </div>

    </div>
</main>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
