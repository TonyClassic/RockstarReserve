<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Info GTA VI");
    request.setAttribute("extraCss", "info.css");
%>
<%@ include file="/WEB-INF/view/common/header.jsp" %>
<%@ include file="/WEB-INF/view/common/navbar.jsp" %>

<main class="page-content info-page">

    <!-- ===========================
         HERO INFO
         =========================== -->
    <section class="info-hero">
        <div class="info-eyebrow">Rockstar Games &bull; 2026</div>
        <h1 class="info-hero-title">Grand Theft Auto VI</h1>
        <p class="info-hero-sub">
            Il capitolo più ambizioso della saga. Vice City si trasforma in un mondo aperto
            senza precedenti, dove ogni scelta ha conseguenze reali.
        </p>
        <div class="info-release-pill">
            <span class="dot"></span>
            Uscita ufficiale: 19 novembre 2026
        </div>
    </section>

    <!-- ===========================
         ABOUT / DESCRIZIONE
         =========================== -->
    <section style="padding:80px 24px; max-width:1100px; margin:0 auto;">
        <div class="info-about" style="all:unset; display:grid; grid-template-columns:1fr 1fr;
             gap:80px; align-items:center;">

            <div class="info-about-text">
                <h2 class="section-title">Il gioco</h2>
                <p>
                    <strong>Grand Theft Auto VI</strong> riporta i giocatori nella soleggiata,
                    corrotta e vibrante <strong>Vice City</strong> — reimmaginata per la nuova
                    generazione con una densità di dettagli mai vista prima.
                </p>
                <p>
                    Per la prima volta nella storia della saga, il gioco presenta
                    <strong>due protagonisti giocabili</strong>: <em>Jason</em> e <em>Lucia</em>,
                    la prima protagonista femminile principale di GTA. Una storia d'amore, di
                    sopravvivenza e di criminalità sullo sfondo della Florida contemporanea.
                </p>
                <p>
                    Un mondo open world dinamico in cui le città crescono, le notizie si propagano
                    sui social media virtuali e ogni angolo nasconde qualcosa di nuovo.
                </p>
            </div>

            <div class="info-stats">
                <div class="info-stat">
                    <span class="info-stat-number">2</span>
                    <span class="info-stat-label">Protagonisti giocabili</span>
                </div>
                <div class="info-stat">
                    <span class="info-stat-number">12+</span>
                    <span class="info-stat-label">Anni di sviluppo</span>
                </div>
                <div class="info-stat">
                    <span class="info-stat-number">Vice City</span>
                    <span class="info-stat-label">Location principale</span>
                </div>
                <div class="info-stat">
                    <span class="info-stat-number">Next Gen</span>
                    <span class="info-stat-label">Tecnologia grafica</span>
                </div>
            </div>

        </div>
    </section>

    <!-- ===========================
         PERSONAGGI
         =========================== -->
    <section class="info-characters">
        <div class="info-characters-inner">
            <h2 class="section-title">I protagonisti</h2>
            <p class="section-subtitle">
                Due vite intrecciate in una storia di crime e sopravvivenza
            </p>

            <div class="characters-grid">
                <div class="character-card" data-initial="J">
                    <div class="character-role">Protagonista</div>
                    <h3 class="character-name">Jason</h3>
                    <p class="character-desc">
                        Un uomo del Sud cresciuto tra povertà e criminalità, Jason cerca un modo
                        per uscire dalla spirale in cui è intrappolato. Pragmatico, leale e
                        pericoloso quando serve, è il motore della storia.
                    </p>
                </div>

                <div class="character-card" data-initial="L">
                    <div class="character-role">Prima protagonista femminile GTA</div>
                    <h3 class="character-name">Lucia</h3>
                    <p class="character-desc">
                        Appena uscita di prigione, Lucia sa che il mondo non le farà sconti.
                        Intelligente, determinata e con un passato che la insegue, è la vera forza
                        trainante di Grand Theft Auto VI.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- ===========================
         TRAILER YOUTUBE
         =========================== -->
    <section class="info-trailer">
        <h2 class="section-title">Trailer ufficiale</h2>
        <p class="section-subtitle">Grand Theft Auto VI — Trailer 1 (Rockstar Games)</p>

        <div class="trailer-embed">
            <iframe width="100%" height="100%" src="https://www.youtube.com/embed/eOrb93UZfPU" title="Grand Theft Auto VI — Trailer 1" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
        </div>
    </section>

    <!-- ===========================
         CTA PREORDINE
         =========================== -->
    <section class="info-cta">
        <h2 class="section-title">Pronto per il 19 novembre?</h2>
        <p>
            Preordina ora la tua edizione digitale di GTA VI e ricevila direttamente su Steam.
        </p>
        <a href="<%= request.getContextPath() %>/catalogo#edizioni" class="btn btn-primary btn-lg">
            Scegli la tua edizione &#8594;
        </a>
    </section>

</main>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
