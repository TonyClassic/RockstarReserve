<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Accedi");
    request.setAttribute("extraCss", "auth.css");
    String errore = (String) request.getAttribute("errore");
    String registrato = request.getParameter("registrato");
%>
<%@ include file="/WEB-INF/view/common/header.jsp" %>
<%@ include file="/WEB-INF/view/common/navbar.jsp" %>

<main class="page-content">
    <div class="auth-page">
        <div class="auth-container">

            <div class="auth-header">
                <div class="auth-logo">RockstarReserve</div>
                <h1 class="auth-title">Accedi</h1>
                <p class="auth-subtitle">Bentornato nel mondo di GTA VI</p>
            </div>

            <% if ("1".equals(registrato)) { %>
            <div class="auth-success-banner">
                &#10003; Registrazione completata! Accedi con le tue credenziali.
            </div>
            <% } %>

            <div class="auth-card">
                <% if (errore != null) { %>
                <div class="alert alert-error"><%= errore %></div>
                <% } %>

                <form action="<%= request.getContextPath() %>/login" method="post" novalidate>

                    <div class="form-group">
                        <label class="form-label" for="email">Email</label>
                        <input type="email" id="email" name="email" class="form-control"
                               placeholder="la.tua@email.com" required autocomplete="email">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="password">Password</label>
                        <div class="input-group">
                            <input type="password" id="password" name="password" class="form-control"
                                   placeholder="••••••••" required autocomplete="current-password">
                            <button type="button" class="input-toggle-eye" onclick="togglePwd(this)"
                                    aria-label="Mostra/nascondi password">&#128065;</button>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-auth">Accedi</button>
                </form>

                <div class="auth-divider">oppure</div>

                <p class="auth-footer-text">
                    Non hai un account?
                    <a href="<%= request.getContextPath() %>/registrazione">Registrati gratis</a>
                </p>
            </div>

            <p class="auth-footer-text">
                Sei l'amministratore?
                <a href="<%= request.getContextPath() %>/admin/login">Area admin</a>
            </p>

        </div>
    </div>
</main>

<script src="<%= request.getContextPath() %>/scripts/login-validation.js"></script>
<%@ include file="/WEB-INF/view/common/footer.jsp" %>
<script>
function togglePwd(btn) {
    var input = btn.previousElementSibling;
    input.type = input.type === 'password' ? 'text' : 'password';
    btn.textContent = input.type === 'password' ? '👁' : '🙈';
}
</script>
