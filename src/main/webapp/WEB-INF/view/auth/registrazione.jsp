<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Registrati");
    request.setAttribute("extraCss", "auth.css");
    String errore   = (String) request.getAttribute("errore");
    String nome     = (String) request.getAttribute("nome");
    String cognome  = (String) request.getAttribute("cognome");
    String email    = (String) request.getAttribute("email");
%>
<%@ include file="/WEB-INF/view/common/header.jsp" %>
<%@ include file="/WEB-INF/view/common/navbar.jsp" %>

<main class="page-content">
    <div class="auth-page">
        <div class="auth-container">

            <div class="auth-header">
                <div class="auth-logo">RockstarReserve</div>
                <h1 class="auth-title">Crea account</h1>
                <p class="auth-subtitle">Preordina GTA VI con un click</p>
            </div>

            <div class="auth-card">
                <% if (errore != null) { %>
                <div class="alert alert-error"><%= errore %></div>
                <% } %>

                <form action="<%= request.getContextPath() %>/registrazione" method="post" novalidate>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="nome">Nome</label>
                            <input type="text" id="nome" name="nome" class="form-control"
                                   placeholder="Mario" required
                                   value="<%= nome != null ? nome : "" %>">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="cognome">Cognome</label>
                            <input type="text" id="cognome" name="cognome" class="form-control"
                                   placeholder="Rossi" required
                                   value="<%= cognome != null ? cognome : "" %>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="email">Email</label>
                        <input type="email" id="email" name="email" class="form-control"
                               placeholder="la.tua@email.com" required autocomplete="email"
                               value="<%= email != null ? email : "" %>">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="password">Password</label>
                        <div class="input-group">
                            <input type="password" id="password" name="password" class="form-control"
                                   placeholder="Min. 6 caratteri" required minlength="6"
                                   autocomplete="new-password" oninput="checkStrength(this)">
                            <button type="button" class="input-toggle-eye" onclick="togglePwd(this)">&#128065;</button>
                        </div>
                        <div class="password-hints" id="pwdHints"></div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="confermaPassword">Conferma password</label>
                        <div class="input-group">
                            <input type="password" id="confermaPassword" name="confermaPassword"
                                   class="form-control" placeholder="Ripeti la password" required
                                   autocomplete="new-password">
                            <button type="button" class="input-toggle-eye" onclick="togglePwd(this)">&#128065;</button>
                        </div>
                    </div>

                    <div class="alert alert-info" style="font-size:0.82rem; margin-bottom:20px;">
                        &#x1F3AE; Potrai aggiungere il tuo username Steam durante il checkout.
                    </div>

                    <button type="submit" class="btn btn-primary btn-auth">Crea account</button>
                </form>

                <div class="auth-divider">hai già un account?</div>

                <p class="auth-footer-text">
                    <a href="<%= request.getContextPath() %>/login">Accedi qui</a>
                </p>
            </div>

        </div>
    </div>
</main>

<script src="<%= request.getContextPath() %>/scripts/registrazione-validation.js"></script>
<%@ include file="/WEB-INF/view/common/footer.jsp" %>
<script>
function togglePwd(btn) {
    var input = btn.previousElementSibling;
    input.type = input.type === 'password' ? 'text' : 'password';
    btn.textContent = input.type === 'password' ? '👁' : '🙈';
}
function checkStrength(input) {
    var hints = document.getElementById('pwdHints');
    var val = input.value;
    if (!val) { hints.textContent = ''; return; }
    if (val.length < 6) {
        hints.style.color = '#ff4444';
        hints.textContent = 'Troppo corta (min. 6 caratteri)';
    } else if (val.length < 10) {
        hints.style.color = '#ffcc00';
        hints.textContent = 'Password accettabile';
    } else {
        hints.style.color = '#00d084';
        hints.textContent = 'Password robusta ✓';
    }
}
</script>
