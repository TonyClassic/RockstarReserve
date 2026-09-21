<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%--
    header.jsp — include nel <head> di ogni pagina.
    Parametri attesi (impostati con request.setAttribute prima del forward):
      pageTitle  → titolo della pagina (String)
      extraCss   → nome del file CSS aggiuntivo senza path, es. "catalogo.css" (String, opzionale)
--%>
<%
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "RockstarReserve";
    String extraCss = (String) request.getAttribute("extraCss");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> | RockstarReserve</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- CSS globale -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/style.css">

    <!-- CSS specifico della pagina -->
    <% if (extraCss != null && !extraCss.isEmpty()) { %>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/<%= extraCss %>">
    <% } %>
</head>
<body>
