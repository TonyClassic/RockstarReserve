document.addEventListener('DOMContentLoaded', function () {
    var ctx = CTX;

    function updateUI(data) {
        var totalEl = document.querySelector('.summary-total-amount');
        if (totalEl) totalEl.textContent = data.totale;

        document.querySelectorAll('.cart-badge').forEach(function (el) {
            el.textContent = data.cartCount;
            el.style.display = data.cartCount > 0 ? '' : 'none';
        });

        if (data.items) {
            data.items.forEach(function (item) {
                var row = document.querySelector('tr[data-item-id="' + item.id + '"]');
                if (row) {
                    var sub = row.querySelector('.cart-subtotal');
                    if (sub) sub.textContent = item.subtotale;
                    var qtyInput = row.querySelector('.qty-input');
                    if (qtyInput) qtyInput.value = item.quantita;
                }
            });
        }

        var articoliEl = document.querySelector('.summary-row .value');
        if (articoliEl) articoliEl.textContent = data.cartCount;
    }

    function ajaxAction(form, row, isRemove) {
        var params = new URLSearchParams(new FormData(form));
        params.append('ajax', 'true');

        fetch(ctx + '/carrello', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
            .then(function (res) { return res.json(); })
            .then(function (data) {
                if (!data.success) { location.reload(); return; }
                if (isRemove && row) {
                    row.remove();
                    if (document.querySelectorAll('tr[data-item-id]').length === 0) {
                        location.reload(); return;
                    }
                }
                updateUI(data);
            })
            .catch(function () { location.reload(); });
    }

    // Aggiorna quantità — intercetta submit del form
    document.querySelectorAll('.qty-form').forEach(function (form) {
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            ajaxAction(form, form.closest('tr'), false);
        });
    });

    // Rimuovi — intercetta submit (il confirm sul bottone scatta prima, se annulla non arriva qui)
    document.querySelectorAll('form').forEach(function (form) {
        if (!form.querySelector('input[name="action"][value="rimuovi"]')) return;
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            ajaxAction(form, form.closest('tr'), true);
        });
    });
});
