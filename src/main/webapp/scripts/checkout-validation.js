(function () {
    var form = document.getElementById('checkoutForm');
    if (!form) return;

    var RE_CARTA = /^\d{16}$/;
    var RE_SCAD  = /^(0[1-9]|1[0-2])\/\d{2}$/;
    var RE_CVV   = /^\d{3,4}$/;

    function showError(name, msg) {
        var input = form.querySelector('[name="' + name + '"]');
        var err = document.getElementById('err-' + name);
        if (!err) {
            err = document.createElement('span');
            err.id = 'err-' + name;
            err.className = 'field-error';
            err.style.cssText = 'color:#ff2d78;font-size:0.8rem;display:block;margin-top:4px;';
            if (input) input.parentNode.appendChild(err);
        }
        err.textContent = msg;
        if (input) input.style.borderColor = '#ff2d78';
    }

    function clearError(name) {
        var input = form.querySelector('[name="' + name + '"]');
        var err = document.getElementById('err-' + name);
        if (err) err.textContent = '';
        if (input) input.style.borderColor = '';
    }

    function getMetodo() {
        var r = form.querySelector('[name="metodoPagamento"]:checked');
        return r ? r.value : null;
    }

    function validateSteam() {
        var input = form.querySelector('[name="usernameSteam"]');
        if (!input) return true;
        var v = input.value.trim();
        if (!v) { showError('usernameSteam', 'Username Steam obbligatorio'); return false; }
        clearError('usernameSteam'); return true;
    }

    function validateCarta() {
        if (getMetodo() !== 'carta') return true;
        var numero = form.querySelector('[name="numeroCarta"]');
        var scad   = form.querySelector('[name="scadenza"]');
        var cvv    = form.querySelector('[name="cvv"]');
        var nome   = form.querySelector('[name="intestatario"]');
        var ok = true;

        if (!numero || !RE_CARTA.test(numero.value.replace(/\s/g,''))) {
            showError('numeroCarta', 'Numero carta non valido (16 cifre)'); ok = false;
        } else clearError('numeroCarta');

        if (!scad || !RE_SCAD.test(scad.value)) {
            showError('scadenza', 'Formato MM/AA richiesto'); ok = false;
        } else clearError('scadenza');

        if (!cvv || !RE_CVV.test(cvv.value)) {
            showError('cvv', 'CVV non valido (3-4 cifre)'); ok = false;
        } else clearError('cvv');

        if (!nome || !nome.value.trim()) {
            showError('intestatario', 'Intestatario obbligatorio'); ok = false;
        } else clearError('intestatario');

        return ok;
    }

    if (form.querySelector('[name="usernameSteam"]'))
        form.querySelector('[name="usernameSteam"]').addEventListener('change', validateSteam);
    ['numeroCarta','scadenza','cvv','intestatario'].forEach(function(n) {
        var el = form.querySelector('[name="' + n + '"]');
        if (el) el.addEventListener('change', validateCarta);
    });

    /* Formattazione automatica scadenza MM/AA */
    var scadEl = document.getElementById('scadenza');
    if (scadEl) {
        scadEl.addEventListener('input', function(e) {
            var value = e.target.value.replace(/\D/g, '');
            if (value.length >= 2) {
                value = value.substring(0, 2) + '/' + value.substring(2, 4);
            }
            e.target.value = value;
        });
    }

    /* Controllo metodo di pagamento — sostituisce il vecchio alert */
    function validateMetodo() {
        var radios = document.querySelectorAll('input[name="metodoPagamento"]');
        var checked = Array.from(radios).some(function(r){ return r.checked; });
        var err = document.getElementById('err-metodoPagamento');
        if (!err) {
            err = document.createElement('span');
            err.id = 'err-metodoPagamento';
            err.style.cssText = 'color:#ff2d78;font-size:0.8rem;display:block;margin-top:8px;';
            var paymentSection = document.querySelector('.payment-methods');
            if (paymentSection) paymentSection.appendChild(err);
        }
        if (!checked) {
            err.textContent = 'Seleziona un metodo di pagamento';
            return false;
        }
        err.textContent = '';
        return true;
    }

    form.addEventListener('submit', function (e) {
        var ok = validateMetodo() & validateSteam() & validateCarta();
        if (!ok) e.preventDefault();
    });
})();
