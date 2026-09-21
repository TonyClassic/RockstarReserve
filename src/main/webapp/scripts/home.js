/* Scroll reveal per i pack */
(function () {
    const cards = document.querySelectorAll('.pack-card');
    if (!cards.length) return;
    const observer = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('revealed');
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.12 });
    cards.forEach(function (c) { observer.observe(c); });
})();

/* Smooth scroll per il link hero */
document.querySelector('[href="#edizioni"]')?.addEventListener('click', function (e) {
    e.preventDefault();
    document.getElementById('edizioni')?.scrollIntoView({ behavior: 'smooth' });
});

/* AJAX — Aggiungi al carrello */
function aggiungiCarrello(edizioneId) {
    fetch(CTX + '/carrello', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'action=aggiungi&edizioneId=' + edizioneId + '&quantita=1&ajax=true'
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (!data.success) return;
        document.querySelectorAll('.cart-badge').forEach(function(el) {
            el.textContent = data.cartCount;
            el.style.display = data.cartCount > 0 ? '' : 'none';
        });
    })
    .catch(function() {});
}
