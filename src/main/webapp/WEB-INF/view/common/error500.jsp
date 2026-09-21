<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" isErrorPage="true" %>
<%
    request.setAttribute("pageTitle", "Errore interno");
    request.setAttribute("extraCss", "");
%>
<%@ include file="/WEB-INF/view/common/header.jsp" %>
<%@ include file="/WEB-INF/view/common/navbar.jsp" %>

<main class="page-content">
<div style="max-width:600px; margin:0 auto; padding:120px 24px; text-align:center;">
    <div style="font-family:var(--font-title); font-size:8rem;
                background:linear-gradient(135deg,var(--danger),var(--accent-pink));
                -webkit-background-clip:text; -webkit-text-fill-color:transparent;
                background-clip:text; line-height:1;">500</div>
    <h1 style="font-size:2rem; text-transform:uppercase; margin-bottom:16px;">Errore interno</h1>
    <p style="color:var(--text-muted); margin-bottom:36px;">
        Si è verificato un errore sul server. Riprova tra qualche istante.
    </p>
    <a href="<%= request.getContextPath() %>/catalogo" class="btn btn-primary">Torna alla home</a>
</div>
</main>

<%@ include file="/WEB-INF/view/common/footer.jsp" %>
