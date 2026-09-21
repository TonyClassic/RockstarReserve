function closeMobileMenu() {
    var m = document.getElementById('mobileMenu');
    var o = document.getElementById('mobileMenuOverlay');
    if (m) m.classList.remove('open');
    if (o) o.classList.remove('open');
    document.body.style.overflow = '';
}
document.addEventListener('DOMContentLoaded', function() {
    var btn = document.getElementById('navHamburger');
    if (btn) {
        btn.addEventListener('click', function() {
            document.getElementById('mobileMenu').classList.add('open');
            document.getElementById('mobileMenuOverlay').classList.add('open');
            document.body.style.overflow = 'hidden';
        });
    }
});
