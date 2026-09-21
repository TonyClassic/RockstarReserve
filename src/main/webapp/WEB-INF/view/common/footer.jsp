<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <footer class="footer">
        <div class="footer-inner">
            <span class="footer-logo">RockstarReserve</span>

            <span class="footer-copy">
                &copy; 2026 RockstarReserve &mdash; Piattaforma di preordine digitale GTA VI.
                Progetto universitario &mdash; Universit&agrave; degli Studi di Salerno.
            </span>

            <nav class="footer-links">
                <a href="<%= request.getContextPath() %>/catalogo">Catalogo</a>
                <a href="<%= request.getContextPath() %>/info">Info GTA VI</a>
                <a href="<%= request.getContextPath() %>/carrello">Carrello</a>
            </nav>
        </div>
    </footer>

</body>
</html>
