(function () {
    var form = document.querySelector('form[action*="/registrazione"]');
    if (!form) return;

    var RE_EMAIL  = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    var RE_PWD    = /^(?=.*[A-Z])(?=.*\d).{8,}$/;
    var RE_STEAM  = /^[a-zA-Z0-9_]{3,32}$/;

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

    function validateNome() {
        var v = form.querySelector('[name="nome"]').value.trim();
        if (!v) { showError('nome', 'Nome obbligatorio'); return false; }
        clearError('nome'); return true;
    }

    function validateCognome() {
        var v = form.querySelector('[name="cognome"]').value.trim();
        if (!v) { showError('cognome', 'Cognome obbligatorio'); return false; }
        clearError('cognome'); return true;
    }

    function validateEmail() {
        var v = form.querySelector('[name="email"]').value.trim();
        if (!v) { showError('email', 'Email obbligatoria'); return false; }
        if (!RE_EMAIL.test(v)) { showError('email', 'Formato email non valido'); return false; }
        clearError('email'); return true;
    }

    function validatePassword() {
        var v = form.querySelector('[name="password"]').value;
        if (!v) { showError('password', 'Password obbligatoria'); return false; }
        if (!RE_PWD.test(v)) { showError('password', 'Min 8 caratteri, una maiuscola e un numero'); return false; }
        clearError('password'); return true;
    }

    function validateConferma() {
        var pwd      = form.querySelector('[name="password"]').value;
        var conferma = form.querySelector('[name="confermaPassword"]').value;
        if (!conferma) { showError('confermaPassword', 'Conferma la password'); return false; }
        if (pwd !== conferma) { showError('confermaPassword', 'Le password non coincidono'); return false; }
        clearError('confermaPassword'); return true;
    }

    form.querySelector('[name="nome"]').addEventListener('change', validateNome);
    form.querySelector('[name="cognome"]').addEventListener('change', validateCognome);
    form.querySelector('[name="email"]').addEventListener('change', validateEmail);
    form.querySelector('[name="password"]').addEventListener('change', validatePassword);
    form.querySelector('[name="confermaPassword"]').addEventListener('change', validateConferma);
    form.addEventListener('submit', function (e) {
        var ok = validateNome() & validateCognome() & validateEmail() &
                 validatePassword() & validateConferma();
        if (!ok) e.preventDefault();
    });
})();
