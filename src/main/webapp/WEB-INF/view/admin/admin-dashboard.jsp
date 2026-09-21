<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Admin Dashboard");
    request.setAttribute("extraCss", "admin.css");
%>
<%@ include file="/WEB-INF/view/common/header.jsp" %>
<%@ include file="/WEB-INF/view/common/navbar.jsp" %>

<main class="page-content admin-page">

    <div class="admin-page-header">
        <div>
            <h1 class="admin-page-title">Dashboard</h1>
            <div class="admin-page-subtitle">Pannello di controllo RockstarReserve</div>
        </div>
        <a href="<%= request.getContextPath() %>/admin/logout" class="btn btn-danger btn-sm">
            Esci dal pannello
        </a>
    </div>

    <div class="admin-content">

        <!-- Navigazione rapida -->
        <div class="admin-nav">
            <a href="<%= request.getContextPath() %>/admin/edizioni" class="active">Edizioni</a>
            <a href="<%= request.getContextPath() %>/admin/ordini">Ordini</a>
            <a href="<%= request.getContextPath() %>/admin/utenti">Utenti</a>
            <a href="<%= request.getContextPath() %>/catalogo">Vai al sito &#8599;</a>
        </div>

        <!-- Card dashboard -->
        <div class="admin-dashboard-grid">

            <a href="<%= request.getContextPath() %>/admin/edizioni" class="admin-dash-card">
                <div class="admin-dash-icon">&#x1F4E6;</div>
                <div class="admin-dash-label">Catalogo</div>
                <div class="admin-dash-title">Gestisci edizioni</div>
                <div class="admin-dash-desc">
                    Aggiungi, modifica o elimina le edizioni di GTA VI disponibili.
                </div>
            </a>

            <a href="<%= request.getContextPath() %>/admin/ordini" class="admin-dash-card">
                <div class="admin-dash-icon">&#x1F4CB;</div>
                <div class="admin-dash-label">Preordini</div>
                <div class="admin-dash-title">Gestisci ordini</div>
                <div class="admin-dash-desc">
                    Visualizza e filtra tutti i preordini per data e cliente.
                </div>
            </a>

            <a href="<%= request.getContextPath() %>/admin/utenti" class="admin-dash-card">
                <div class="admin-dash-icon">&#x1F465;</div>
                <div class="admin-dash-label">Clienti</div>
                <div class="admin-dash-title">Gestisci utenti</div>
                <div class="admin-dash-desc">
                    Visualizza gli utenti registrati e gestisci lo stato dei loro account.
                </div>
            </a>

        </div>

    </div>
</main>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
