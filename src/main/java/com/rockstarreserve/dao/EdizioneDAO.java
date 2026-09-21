package com.rockstarreserve.dao;

import com.rockstarreserve.model.Edizione;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EdizioneDAO {

    /* ------------------------------------------------------------------ */
    /*  SELECT                                                              */
    /* ------------------------------------------------------------------ */

    public List<Edizione> findAll() throws SQLException {
        List<Edizione> lista = new ArrayList<>();
        String sql = "SELECT * FROM edizioni ORDER BY prezzo ASC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(map(rs));
        }
        return lista;
    }

    public Edizione findById(int id) throws SQLException {
        String sql = "SELECT * FROM edizioni WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    /* ------------------------------------------------------------------ */
    /*  INSERT                                                              */
    /* ------------------------------------------------------------------ */

    public boolean insert(Edizione e) throws SQLException {
        String sql = "INSERT INTO edizioni (nome, descrizione, prezzo, contenuti) VALUES (?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, e.getNome());
            ps.setString(2, e.getDescrizione());
            ps.setBigDecimal(3, e.getPrezzo());
            ps.setString(4, e.getContenuti());
            return ps.executeUpdate() > 0;
        }
    }

    /* ------------------------------------------------------------------ */
    /*  UPDATE                                                              */
    /* ------------------------------------------------------------------ */

    public boolean update(Edizione e) throws SQLException {
        String sql = "UPDATE edizioni SET nome=?, descrizione=?, prezzo=?, contenuti=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, e.getNome());
            ps.setString(2, e.getDescrizione());
            ps.setBigDecimal(3, e.getPrezzo());
            ps.setString(4, e.getContenuti());
            ps.setInt(5, e.getId());
            return ps.executeUpdate() > 0;
        }
    }

    /* ------------------------------------------------------------------ */
    /*  DELETE                                                              */
    /* ------------------------------------------------------------------ */

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM edizioni WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Mapping ResultSet → Edizione                                        */
    /* ------------------------------------------------------------------ */

    private Edizione map(ResultSet rs) throws SQLException {
        Edizione e = new Edizione();
        e.setId(rs.getInt("id"));
        e.setNome(rs.getString("nome"));
        e.setDescrizione(rs.getString("descrizione"));
        e.setPrezzo(rs.getBigDecimal("prezzo"));
        e.setContenuti(rs.getString("contenuti"));
        return e;
    }
}
