(function () {
    var form   = document.querySelector('form[action*="/login"]');
    if (!form) return;

    var emailInput = form.querySelector('input[name="email"]');
    var pwdInput   = form.querySelector('input[name="password"]');

    var RE_EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    function showError(input, msg) {
        var err = document.getElementById('err-' + input.name);
        if (!err) {
            err = document.createElement('span');
            err.id = 'err-' + input.name;
            err.className = 'field-error';
            err.style.cssText = 'color:#ff2d78;font-size:0.8rem;display:block;margin-top:4px;';
            input.parentNode.appendChild(err);
        }
        err.textContent = msg;
        input.style.borderColor = '#ff2d78';
    }

    function clearError(input) {
        var err = document.getElementById('err-' + input.name);
        if (err) err.textContent = '';
        input.style.borderColor = '';
    }

    function validateEmail() {
        var v = emailInput.value.trim();
        if (!v) { showError(emailInput, 'Email obbligatoria'); return false; }
        if (!RE_EMAIL.test(v)) { showError(emailInput, 'Formato email non valido'); return false; }
        clearError(emailInput); return true;
    }

    function validatePassword() {
        if (!pwdInput.value) { showError(pwdInput, 'Password obbligatoria'); return false; }
        clearError(pwdInput); return true;
    }

    emailInput.addEventListener('change', validateEmail);
    pwdInput.addEventListener('change', validatePassword);

    form.addEventListener('submit', function (e) {
        var ok = validateEmail() & validatePassword();
        if (!ok) e.preventDefault();
    });
})();
