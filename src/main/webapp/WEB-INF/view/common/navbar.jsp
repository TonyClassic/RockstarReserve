<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="com.rockstarreserve.model.Utente" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rockstarreserve.model.CarrelloItem" %>
<%
    Utente utenteNav = (session != null) ? (Utente) session.getAttribute("utente") : null;
    boolean adminNav = (session != null) && Boolean.TRUE.equals(session.getAttribute("adminLoggato"));

    /* Conteggio item carrello per il badge */
    int cartCount = 0;
    List<com.rockstarreserve.model.CarrelloItem> navCart =
        (List<com.rockstarreserve.model.CarrelloItem>) session.getAttribute("carrello");
    if (navCart != null) {
        for (com.rockstarreserve.model.CarrelloItem ci : navCart) {
            cartCount += ci.getQuantita();
        }
    }

    String currentUri = request.getRequestURI();
%>
<nav class="navbar">
    <div class="navbar-inner">

        <!-- Logo -->
        <a href="<%= request.getContextPath() %>/catalogo" class="navbar-logo">RockstarReserve</a>

        <!-- Link navigazione (desktop) -->
        <div class="navbar-links">
            <a href="<%= request.getContextPath() %>/catalogo"
               class="<%= currentUri.contains("/catalogo") ? "active" : "" %>">Catalogo</a>

            <a href="<%= request.getContextPath() %>/info"
               class="<%= currentUri.contains("/info") ? "active" : "" %>">Info GTA VI</a>

            <div class="navbar-divider"></div>

            <!-- Carrello con badge -->
            <a href="<%= request.getContextPath() %>/carrello"
               class="navbar-cart <%= currentUri.contains("/carrello") ? "active" : "" %>">
                Carrello
                <span class="cart-badge" style="<%= cartCount == 0 ? "display:none;" : "" %>"><%= cartCount %></span>
            </a>

            <div class="navbar-divider"></div>

            <% if (adminNav) { %>
                <a href="<%= request.getContextPath() %>/admin/edizioni"
                   class="<%= currentUri.contains("/admin/") ? "active" : "" %>">&#9679; Admin</a>
                <a href="<%= request.getContextPath() %>/admin/logout" class="btn btn-secondary btn-sm">Esci</a>
            <% } else if (utenteNav != null) { %>
                <a href="<%= request.getContextPath() %>/miei-ordini"
                   class="<%= currentUri.contains("/miei-ordini") ? "active" : "" %>">I miei preordini</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-secondary btn-sm">Esci</a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login"
                   class="<%= currentUri.contains("/login") ? "active" : "" %>">Accedi</a>
                <a href="<%= request.getContextPath() %>/registrazione" class="btn btn-primary btn-sm">Registrati</a>
            <% } %>
        </div>

        <!-- Controlli mobile -->
        <div class="navbar-mobile-controls">
            <a href="<%= request.getContextPath() %>/carrello" class="navbar-mobile-cart">
                &#x1F6D2;
                <span class="cart-badge" style="<%= cartCount == 0 ? "display:none;" : "" %>"><%= cartCount %></span>
            </a>
            <button class="navbar-hamburger" id="navHamburger" aria-label="Apri menu">&#9776;</button>
        </div>
    </div>
</nav>

<!-- Overlay menu mobile -->
<div class="mobile-menu-overlay" id="mobileMenuOverlay" onclick="closeMobileMenu()"></div>
<div class="mobile-menu" id="mobileMenu">
    <button class="mobile-menu-close" onclick="closeMobileMenu()">&#10005;</button>
    <nav class="mobile-menu-links">
        <a href="<%= request.getContextPath() %>/catalogo" onclick="closeMobileMenu()">Catalogo</a>
        <a href="<%= request.getContextPath() %>/info" onclick="closeMobileMenu()">Info GTA VI</a>
        <a href="<%= request.getContextPath() %>/carrello" onclick="closeMobileMenu()">Carrello<% if (cartCount > 0) { %> (<%= cartCount %>)<% } %></a>
        <% if (adminNav) { %>
            <a href="<%= request.getContextPath() %>/admin/edizioni" onclick="closeMobileMenu()">&#9679; Admin</a>
            <a href="<%= request.getContextPath() %>/admin/logout" class="mobile-menu-logout">Esci</a>
        <% } else if (utenteNav != null) { %>
            <a href="<%= request.getContextPath() %>/miei-ordini" onclick="closeMobileMenu()">I miei preordini</a>
            <a href="<%= request.getContextPath() %>/logout" class="mobile-menu-logout">Esci</a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/login" onclick="closeMobileMenu()">Accedi</a>
            <a href="<%= request.getContextPath() %>/registrazione" class="mobile-menu-cta" onclick="closeMobileMenu()">Registrati</a>
        <% } %>
    </nav>
</div>

<script src="<%= request.getContextPath() %>/scripts/navbar.js"></script>
