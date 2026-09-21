<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rockstarreserve.model.Edizione" %>
<%
    request.setAttribute("pageTitle", "Admin — Edizioni");
    request.setAttribute("extraCss", "admin.css");

    List<Edizione> edizioni       = (List<Edizione>) request.getAttribute("edizioni");
    Edizione edizioneModifica     = (Edizione) request.getAttribute("edizioneModifica");
    String   actionParam          = request.getParameter("action");
    String   msg                  = request.getParameter("msg");
    boolean  showForm             = "nuova".equals(actionParam) || edizioneModifica != null;
%>
<%@ include file="/WEB-INF/view/common/header.jsp" %>
<%@ include file="/WEB-INF/view/common/navbar.jsp" %>

<main class="page-content admin-page">

    <div class="admin-page-header">
        <div>
            <h1 class="admin-page-title">Gestione edizioni</h1>
            <div class="admin-page-subtitle">CRUD catalogo &mdash; le modifiche si riflettono immediatamente sul sito</div>
        </div>
        <a href="<%= request.getContextPath() %>/admin/edizioni?action=nuova" class="btn btn-primary">
            + Nuova edizione
        </a>
    </div>

    <div class="admin-content">

        <!-- Nav admin -->
        <div class="admin-nav">
            <a href="<%= request.getContextPath() %>/admin/edizioni" class="active">Edizioni</a>
            <a href="<%= request.getContextPath() %>/admin/ordini">Ordini</a>
            <a href="<%= request.getContextPath() %>/admin/utenti">Utenti</a>
            <a href="<%= request.getContextPath() %>/catalogo">Vai al sito &#8599;</a>
        </div>

        <!-- Messaggio feedback -->
        <% if (msg != null && !msg.isBlank()) { %>
        <div class="admin-msg">&#x2713; <%= msg %></div>
        <% } %>

        <!-- ============================================================
             FORM INSERIMENTO / MODIFICA
             ============================================================ -->
        <% if (showForm) { %>
        <div class="admin-form-card">
            <div class="admin-form-title">
                &#9998;
                <%= edizioneModifica != null ? "Modifica edizione: " + edizioneModifica.getNome() : "Nuova edizione" %>
            </div>

            <form action="<%= request.getContextPath() %>/admin/edizioni" method="post">
                <input type="hidden" name="action" value="<%= edizioneModifica != null ? "modifica" : "inserisci" %>">
                <% if (edizioneModifica != null) { %>
                <input type="hidden" name="id" value="<%= edizioneModifica.getId() %>">
                <% } %>

                <div class="admin-form-row">
                    <div class="form-group">
                        <label class="form-label" for="nome">Nome edizione</label>
                        <input type="text" id="nome" name="nome" class="form-control"
                               placeholder="es. Premium Edition" required
                               value="<%= edizioneModifica != null ? edizioneModifica.getNome() : "" %>">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="prezzo">Prezzo (€)</label>
                        <input type="number" id="prezzo" name="prezzo" class="form-control"
                               placeholder="69.99" step="0.01" min="0" required
                               value="<%= edizioneModifica != null ? edizioneModifica.getPrezzo() : "" %>">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="descrizione">Descrizione breve</label>
                    <textarea id="descrizione" name="descrizione" class="form-control"
                              rows="3" placeholder="Descrizione mostrata sulla card..."><%= edizioneModifica != null ? edizioneModifica.getDescrizione() : "" %></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label" for="contenuti">Contenuti inclusi</label>
                    <textarea id="contenuti" name="contenuti" class="form-control"
                              rows="5" placeholder="Separa i contenuti con ';'  es: Accesso anticipato 7 giorni; Armi bonus; Risorse extra"><%= edizioneModifica != null ? edizioneModifica.getContenuti() : "" %></textarea>
                    <div style="font-size:0.75rem; color:var(--text-muted); margin-top:6px;">
                        Separa ogni voce con un punto e virgola <code>;</code> — verranno visualizzati come lista.
                    </div>
                </div>

                <div class="admin-form-actions">
                    <button type="submit" class="btn btn-primary">
                        <%= edizioneModifica != null ? "&#x2713; Salva modifiche" : "+ Crea edizione" %>
                    </button>
                    <a href="<%= request.getContextPath() %>/admin/edizioni" class="btn btn-secondary">
                        Annulla
                    </a>
                </div>
            </form>
        </div>
        <% } %>

        <!-- ============================================================
             LISTA EDIZIONI — clone vista utente con pulsanti admin
             ============================================================ -->
        <div style="margin-bottom:16px; font-size:0.82rem; color:var(--text-muted);">
            <%= edizioni != null ? edizioni.size() : 0 %> edizione/i nel catalogo
        </div>

        <% if (edizioni == null || edizioni.isEmpty()) { %>
        <div class="card text-center" style="padding:60px;">
            <p style="color:var(--text-muted);">Nessuna edizione nel catalogo. Creane una con il pulsante in alto.</p>
        </div>
        <% } else { %>
        <div style="display:grid; grid-template-columns:repeat(auto-fill, minmax(300px,1fr)); gap:20px;">
            <% for (Edizione ed : edizioni) {
                String[] contenuti = ed.getContenuti() != null ? ed.getContenuti().split("[;\n]") : new String[]{};
            %>
            <div class="card" style="padding:0; overflow:hidden; display:flex; flex-direction:column;">

                <!-- Header pack -->
                <div style="padding:24px 24px 16px; border-bottom:1px solid var(--border);">
                    <div style="font-size:0.7rem; font-weight:700; letter-spacing:0.16em;
                                text-transform:uppercase; color:var(--accent-orange); margin-bottom:8px;">GTA VI</div>
                    <div style="font-family:var(--font-title); font-size:1.6rem;
                                text-transform:uppercase; margin-bottom:6px;"><%= ed.getNome() %></div>
                    <div style="font-size:0.85rem; color:var(--text-secondary);"><%= ed.getDescrizione() %></div>
                    <div style="font-family:var(--font-title); font-size:2rem;
                                color:var(--text-primary); margin-top:12px;"><%= ed.getPrezzoFormattato() %></div>
                </div>

                <!-- Contenuti -->
                <div style="padding:16px 24px; flex:1;">
                    <div style="font-size:0.7rem; font-weight:700; letter-spacing:0.1em;
                                text-transform:uppercase; color:var(--text-muted); margin-bottom:10px;">Contenuti</div>
                    <% for (String c : contenuti) { String ct = c.trim(); if (!ct.isEmpty()) { %>
                    <div style="font-size:0.85rem; color:var(--text-secondary);
                                margin-bottom:6px; display:flex; gap:8px;">
                        <span style="color:var(--accent-orange); flex-shrink:0;">&#10003;</span>
                        <%= ct %>
                    </div>
                    <% } } %>
                </div>

                <!-- Azioni admin -->
                <div class="pack-admin-actions">
                    <a href="<%= request.getContextPath() %>/admin/edizioni?action=modifica&id=<%= ed.getId() %>"
                       class="btn btn-secondary btn-sm">&#9998; Modifica</a>
                    <form action="<%= request.getContextPath() %>/admin/edizioni" method="post" style="margin:0;"
                          onsubmit="return confirm('Eliminare <%= ed.getNome() %>? Questa azione è irreversibile.')">
                        <input type="hidden" name="action" value="elimina">
                        <input type="hidden" name="id"     value="<%= ed.getId() %>">
                        <button type="submit" class="btn btn-danger btn-sm">&#128465; Elimina</button>
                    </form>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>

    </div>
</main>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
