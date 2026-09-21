<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Admin Login");
    request.setAttribute("extraCss", "admin.css");
    String errore = (String) request.getAttribute("errore");
%>
<%@ include file="/WEB-INF/view/common/header.jsp" %>

<main>
<div class="admin-login-page">
    <div class="admin-login-box">

        <div class="admin-login-logo">
            <span>RockstarReserve</span>
        </div>
        <div class="admin-login-subtitle">Pannello Amministratore</div>

        <% if (errore != null) { %>
        <div class="alert alert-error"><%= errore %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/admin/login" method="post">

            <div class="form-group">
                <label class="form-label" for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control"
                       placeholder="admin" required autocomplete="username">
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control"
                       placeholder="••••••••" required autocomplete="current-password">
            </div>

            <button type="submit" class="btn btn-primary w-100" style="margin-top:8px;">
                Accedi al pannello
            </button>
        </form>

        <div style="text-align:center; margin-top:20px;">
            <a href="<%= request.getContextPath() %>/catalogo"
               style="font-size:0.8rem; color:var(--text-muted);">
                &#8592; Torna al sito
            </a>
        </div>

    </div>
</div>
</main>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
