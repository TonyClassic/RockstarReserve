<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rockstarreserve.model.Edizione" %>
<%@ page import="com.rockstarreserve.model.Utente" %>
<%
    request.setAttribute("pageTitle", "Preordina GTA VI");
    request.setAttribute("extraCss", "catalogo.css");
    List<Edizione> edizioni = (List<Edizione>) request.getAttribute("edizioni");
    Utente utenteHome = (session != null) ? (Utente) session.getAttribute("utente") : null;
    boolean isAdmin = (session != null) && Boolean.TRUE.equals(session.getAttribute("adminLoggato"));
%>
<%@ include file="/WEB-INF/view/common/header.jsp" %>
<%@ include file="/WEB-INF/view/common/navbar.jsp" %>

<main class="page-content">

    <!-- ============================================================
         HERO
         HERO IMAGE: inserire immagine 1920x1080px in formato JPG/PNG
         Percorso: webapp/images/hero-gtavi.jpg
         ============================================================ -->
    <section class="hero">
        <div class="hero-release">
            <div class="hero-release-label">Data di uscita</div>
            <div class="hero-release-date">19 NOV 2026</div>
        </div>

        <div class="hero-content">
            <div class="hero-eyebrow">Preordine digitale ufficiale</div>
            <h1 class="hero-title">
                Grand Theft<br><span>Auto VI</span>
            </h1>
            <p class="hero-sub">
                Il gioco pi&ugrave; atteso della generazione. Scegli la tua edizione,
                preordina ora e ricevi GTA&nbsp;VI direttamente sulla tua libreria Steam.
            </p>
            <div class="hero-actions">
                <a href="#edizioni" class="btn btn-primary btn-lg">Scegli la tua edizione</a>
                <a href="<%= request.getContextPath() %>/info" class="btn btn-secondary btn-lg">Scopri il gioco</a>
            </div>
        </div>

        <div class="hero-scroll">Scorri</div>
    </section>

    <!-- ============================================================
         SEZIONE PACK / EDIZIONI
         ============================================================ -->
    <section class="packs-section" id="edizioni">
        <div class="packs-header">
            <h2 class="section-title">Scegli la tua edizione</h2>
            <p class="section-subtitle">
                Tre edizioni digitali. Un solo obiettivo: essere pronto il 19 novembre 2026.
            </p>
        </div>

        <% if (isAdmin) { %>
        <div style="max-width:1200px; margin: 0 auto 24px; padding: 0 0 0 0;">
            <a href="<%= request.getContextPath() %>/admin/edizioni?action=nuova" class="btn btn-primary">
                + Aggiungi Nuova Edizione
            </a>
        </div>
        <% } %>

        <div class="packs-grid">
            <% if (edizioni == null || edizioni.isEmpty()) { %>
            <div class="no-editions" style="grid-column:1/-1;">
                <p>Nessuna edizione disponibile al momento.</p>
            </div>
            <% } else {
                int packIndex = 0;
                for (Edizione ed : edizioni) {
                    boolean isFeatured = (packIndex == 1);
                    packIndex++;
                    // Spezza contenuti su ";" o newline
                    String[] contenuti = ed.getContenuti() != null
                        ? ed.getContenuti().split("[;\n]")
                        : new String[]{};
            %>
            <div class="pack-card <%= isFeatured ? "featured" : "" %>">

                <!-- Header -->
                <div class="pack-card-header">
                    <div class="pack-edition-tag">GTA VI</div>
                    <h3 class="pack-name"><%= ed.getNome() %></h3>
                    <p class="pack-desc"><%= ed.getDescrizione() != null ? ed.getDescrizione() : "" %></p>
                    <div class="pack-price-block">
                        <span class="pack-price"><%= ed.getPrezzoFormattato() %></span>
                        <span class="pack-price-label">preordine digitale</span>
                    </div>
                </div>

                <!-- Contenuti -->
                <div class="pack-card-body">
                    <div class="pack-contents-title">Cosa include</div>
                    <div class="pack-contents-list">
                        <% for (String c : contenuti) {
                            String cTrim = c.trim();
                            if (!cTrim.isEmpty()) { %>
                        <div class="pack-content-item"><%= cTrim %></div>
                        <%  }
                        } %>
                    </div>
                </div>

                <!-- CTA -->
                <div class="pack-card-footer">
                    <form action="<%= request.getContextPath() %>/carrello" method="post">
                        <input type="hidden" name="action"     value="aggiungi">
                        <input type="hidden" name="edizioneId" value="<%= ed.getId() %>">
                        <input type="hidden" name="quantita"   value="1">
                        <button type="button" class="btn-pack-primary" onclick="aggiungiCarrello(<%= ed.getId() %>)">&#128722; Aggiungi al carrello</button>
                    </form>
                    <a href="<%= request.getContextPath() %>/carrello" class="btn-pack-secondary"
                       onclick="event.preventDefault();
                                fetch('<%= request.getContextPath() %>/carrello', {
                                    method:'POST',
                                    headers:{'Content-Type':'application/x-www-form-urlencoded'},
                                    body:'action=aggiungi&edizioneId=<%= ed.getId() %>&quantita=1'
                                }).then(()=>{ window.location='<%= request.getContextPath() %>/checkout'; })">
                        &#9889; Acquista ora
                    </a>
                </div>

                <!-- Pulsanti admin inline -->
                <% if (isAdmin) { %>
                <div class="pack-admin-actions">
                    <a href="<%= request.getContextPath() %>/admin/edizioni?action=modifica&id=<%= ed.getId() %>"
                       class="btn btn-secondary btn-sm">&#9998; Modifica</a>
                    <form action="<%= request.getContextPath() %>/admin/edizioni" method="post"
                          style="margin:0;"
                          onsubmit="return confirm('Eliminare l\'edizione <%= ed.getNome() %>?')">
                        <input type="hidden" name="action" value="elimina">
                        <input type="hidden" name="id"     value="<%= ed.getId() %>">
                        <button type="submit" class="btn btn-danger btn-sm">&#128465; Elimina</button>
                    </form>
                </div>
                <% } %>

            </div>
            <% } } %>
        </div>
    </section>

</main>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>

<script>var CTX = '<%= request.getContextPath() %>';</script>
<script src="<%= request.getContextPath() %>/scripts/home.js"></script>
