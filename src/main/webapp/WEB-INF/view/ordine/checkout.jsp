<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rockstarreserve.model.CarrelloItem" %>
<%@ page import="com.rockstarreserve.model.Utente" %>
<%@ page import="java.math.BigDecimal" %>
<%
    request.setAttribute("pageTitle", "Checkout");
    request.setAttribute("extraCss", "checkout.css");

    String fase                = (String) request.getAttribute("fase");
    List<CarrelloItem> items   = (List<CarrelloItem>) request.getAttribute("items");
    Utente utenteChk           = (Utente) request.getAttribute("utente");
    String errore              = (String) request.getAttribute("errore");

    BigDecimal totaleChk = BigDecimal.ZERO;
    if (items != null) {
        for (CarrelloItem i : items) totaleChk = totaleChk.add(i.getSubtotale());
    }
    String totaleStr = "€" + totaleChk.setScale(2, java.math.RoundingMode.HALF_UP)
                                       .toPlainString().replace(".", ",");

    /* Username Steam pre-compilato dal profilo */
    String steamPrecomp = (utenteChk != null && utenteChk.getUsernameSteam() != null
            && !utenteChk.getUsernameSteam().isBlank())
            ? utenteChk.getUsernameSteam() : "";

    /* Recupera dati da sessione per la pagina PayPal */
    String sessSteam  = (String) session.getAttribute("checkoutUsernameSteam");
    String sessMetodo = (String) session.getAttribute("checkoutMetodoPagamento");
%>

<% if ("paypal".equals(fase)) { %>
    <%-- ================================================================
         PAGINA SIMULAZIONE PAYPAL — niente navbar/footer standard
         ================================================================ --%>
    <%@ include file="/WEB-INF/view/common/header.jsp" %>
    <main>
    <div class="paypal-page">
        <div class="paypal-container">

            <!-- Header PayPal -->
            <div class="paypal-header">
                <div class="paypal-logo">Pay<span>Pal</span></div>
            </div>

            <div class="paypal-body">
                <!-- Merchant info -->
                <div class="paypal-merchant">
                    <div class="paypal-merchant-name">Pagamento a RockstarReserve</div>
                    <div class="paypal-amount">
                        <span class="paypal-currency">EUR</span> <%= totaleStr %>
                    </div>
                </div>

                <div class="paypal-divider"></div>

                <!-- Form PayPal simulato -->
                <form action="<%= request.getContextPath() %>/checkout" method="post">
                    <input type="hidden" name="fase" value="paypal-conferma">

                    <div class="paypal-field">
                        <label class="paypal-label">Indirizzo email PayPal</label>
                        <input type="email" class="paypal-input" name="paypalEmail"
                               placeholder="tuoemail@esempio.com" required>
                    </div>

                    <div class="paypal-field">
                        <label class="paypal-label">Password PayPal</label>
                        <input type="password" class="paypal-input" name="paypalPwd"
                               placeholder="••••••••••" required>
                    </div>

                    <button type="submit" class="paypal-btn">Accedi e paga</button>
                </form>
            </div>

            <div class="paypal-footer">
                <div>Acquistando, accetti le <a href="#">Condizioni d'uso</a> di PayPal.</div>
                <div class="paypal-secure">&#128274; Connessione sicura SSL/TLS</div>
            </div>
        </div>

        <a href="<%= request.getContextPath() %>/checkout" class="paypal-cancel-link">
            &#8592; Torna al checkout
        </a>
    </div>
    </main>
    </body></html>

<% } else { %>
    <%-- ================================================================
         CHECKOUT STANDARD
         ================================================================ --%>
    <%@ include file="/WEB-INF/view/common/header.jsp" %>
    <%@ include file="/WEB-INF/view/common/navbar.jsp" %>

    <main class="page-content">
    <div class="checkout-page">

        <h1 class="checkout-page-title">Checkout</h1>
        <p class="checkout-subtitle">Completa il tuo preordine di GTA VI</p>

        <% if (errore != null) { %>
        <div class="alert alert-error"><%= errore %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/checkout" method="post" id="checkoutForm">
            <input type="hidden" name="fase" value="scelta">

            <div class="checkout-layout">

                <!-- Colonna sinistra: form -->
                <div>
                    <!-- Sezione 1: Steam -->
                    <div class="checkout-form-box" style="margin-bottom:24px;">
                        <div class="checkout-section-title">
                            <span class="step-num">1</span>
                            Username Steam
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="usernameSteam">Il tuo username Steam</label>
                            <input type="text" id="usernameSteam" name="usernameSteam"
                                   class="form-control"
                                   placeholder="es. GamerXYZ2000"
                                   value="<%= steamPrecomp %>" required>
                            <div style="font-size:0.78rem; color:var(--text-muted); margin-top:6px;">
                                &#x1F3AE; GTA VI verrà consegnato su questo account Steam dopo il 19 novembre 2026.
                            </div>
                        </div>
                    </div>

                    <!-- Sezione 2: Metodo pagamento -->
                    <div class="checkout-form-box">
                        <div class="checkout-section-title">
                            <span class="step-num">2</span>
                            Metodo di pagamento
                        </div>

                        <div class="payment-methods">

                            <!-- Carta di credito -->
                            <label class="payment-method-card" id="card-carta"
                                   onclick="selectPayment(this, 'carta')">
                                <input type="radio" name="metodoPagamento" value="carta">
                                <div class="payment-method-radio" id="radio-carta"></div>
                                <div class="payment-method-icon">&#x1F4B3;</div>
                                <div class="payment-method-label">
                                    <div class="payment-method-name">Carta di credito / debito</div>
                                    <div class="payment-method-desc">Visa, Mastercard, American Express</div>
                                </div>
                            </label>

                            <!-- PayPal -->
                            <label class="payment-method-card" id="card-paypal"
                                   onclick="selectPayment(this, 'paypal')">
                                <input type="radio" name="metodoPagamento" value="paypal">
                                <div class="payment-method-radio" id="radio-paypal"></div>
                                <div class="payment-method-icon">&#x1F4B0;</div>
                                <div class="payment-method-label">
                                    <div class="payment-method-name">PayPal</div>
                                    <div class="payment-method-desc">Accedi al tuo account PayPal</div>
                                </div>
                                <span class="payment-method-badge">Rapido</span>
                            </label>

                        </div>

                        <!-- Campi carta (mostrati solo se carta selezionata) -->
                        <div id="carta-fields" style="display:none;">
                            <div class="form-group">
                                <label class="form-label">Numero carta</label>
                                <input type="text" class="form-control" name="numeroCarta" placeholder="1234 5678 9012 3456"
                                       maxlength="19" oninput="formatCard(this)">
                            </div>
                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:14px;">
                                <div class="form-group">
                                    <label class="form-label">Scadenza</label>
                                    <input type="text" id="scadenza" name="scadenza" class="form-control" placeholder="MM/AA" maxlength="5">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">CVV</label>
                                    <input type="text" class="form-control" name="cvv" placeholder="•••" maxlength="4">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Intestatario</label>
                                <input type="text" class="form-control" name="intestatario" placeholder="MARIO ROSSI">
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary btn-lg w-100 mt-3"
                                style="margin-top:24px;">
                            Conferma preordine &#8594;
                        </button>

                        <div class="checkout-secure-note">
                            &#128274; Pagamento sicuro &mdash; i tuoi dati sono protetti
                        </div>
                    </div>
                </div>

                <!-- Colonna destra: riepilogo -->
                <div>
                    <div class="checkout-summary">
                        <div class="checkout-summary-title">Riepilogo ordine</div>

                        <div class="summary-items">
                            <% if (items != null) { for (CarrelloItem ci : items) { %>
                            <div class="summary-item">
                                <div class="summary-item-info">
                                    <span class="summary-item-name"><%= ci.getEdizione().getNome() %></span>
                                    <span class="summary-item-qty">Qtà: <%= ci.getQuantita() %></span>
                                </div>
                                <span class="summary-item-price"><%= ci.getSubtotaleFormattato() %></span>
                            </div>
                            <% } } %>
                        </div>

                        <div class="summary-separator"></div>
                        <div class="summary-row" style="margin-top:12px;">
                            <span style="font-size:0.82rem;color:var(--text-muted);">Spedizione digitale</span>
                            <span style="color:var(--success);font-size:0.82rem;font-weight:600;">Gratuita</span>
                        </div>
                        <div class="summary-grand-total">
                            <span class="summary-grand-label">Totale</span>
                            <span class="summary-grand-amount"><%= totaleStr %></span>
                        </div>

                        <div class="checkout-secure-note" style="margin-top:12px;">
                            &#x1F3AE; Consegna su Steam il 19 novembre 2026
                        </div>
                    </div>
                </div>

            </div>
        </form>

    </div>
    </main>

    <script src="<%= request.getContextPath() %>/scripts/checkout-validation.js"></script>
    <%@ include file="/WEB-INF/view/common/footer.jsp" %>

    <script>
    function selectPayment(card, method) {
        document.querySelectorAll('.payment-method-card').forEach(function(c){ c.classList.remove('selected'); });
        card.classList.add('selected');
        card.querySelector('input[type="radio"]').checked = true;
        document.getElementById('carta-fields').style.display = (method === 'carta') ? 'block' : 'none';
    }
    function formatCard(input) {
        var val = input.value.replace(/\D/g,'').substring(0,16);
        input.value = val.replace(/(.{4})/g,'$1 ').trim();
    }
    </script>
<% } %>
