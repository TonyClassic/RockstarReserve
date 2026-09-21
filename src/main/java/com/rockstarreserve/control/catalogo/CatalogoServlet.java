package com.rockstarreserve.control.catalogo;

import com.rockstarreserve.dao.EdizioneDAO;
import com.rockstarreserve.model.Edizione;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class CatalogoServlet extends HttpServlet {

    private final EdizioneDAO edizioneDAO = new EdizioneDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            List<Edizione> edizioni = edizioneDAO.findAll();
            req.setAttribute("edizioni", edizioni);
            req.getRequestDispatcher("/WEB-INF/view/catalogo/home.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Errore nel caricamento delle edizioni", e);
        }
    }
}
