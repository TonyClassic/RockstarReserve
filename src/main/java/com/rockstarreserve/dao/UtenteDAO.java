package com.rockstarreserve.dao;

import com.rockstarreserve.model.Utente;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UtenteDAO {

    /* ------------------------------------------------------------------ */
    /*  SELECT                                                              */
    /* ------------------------------------------------------------------ */

    public Utente findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM utenti WHERE email = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    public Utente findById(int id) throws SQLException {
        String sql = "SELECT * FROM utenti WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    public List<Utente> findAll() throws SQLException {
        List<Utente> lista = new ArrayList<>();
        String sql = "SELECT * FROM utenti ORDER BY cognome, nome";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(map(rs));
        }
        return lista;
    }

    /* ------------------------------------------------------------------ */
    /*  INSERT                                                              */
    /* ------------------------------------------------------------------ */

    public boolean insert(Utente u) throws SQLException {
        String sql = "INSERT INTO utenti (nome, cognome, email, password, username_steam, attivo) "
                   + "VALUES (?, ?, ?, ?, ?, 1)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, u.getNome());
            ps.setString(2, u.getCognome());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPassword());
            ps.setString(5, u.getUsernameSteam());
            return ps.executeUpdate() > 0;
        }
    }

    /* ------------------------------------------------------------------ */
    /*  UPDATE                                                              */
    /* ------------------------------------------------------------------ */

    public boolean setAttivo(int id, boolean attivo) throws SQLException {
        String sql = "UPDATE utenti SET attivo = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setBoolean(1, attivo);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    /** Aggiorna lo username Steam dell'utente (usato al checkout) */
    public boolean updateUsernameSteam(int id, String usernameSteam) throws SQLException {
        String sql = "UPDATE utenti SET username_steam = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, usernameSteam);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Verifica email duplicata                                            */
    /* ------------------------------------------------------------------ */

    public boolean existsByEmail(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM utenti WHERE email = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Mapping ResultSet → Utente                                          */
    /* ------------------------------------------------------------------ */

    private Utente map(ResultSet rs) throws SQLException {
        Utente u = new Utente();
        u.setId(rs.getInt("id"));
        u.setNome(rs.getString("nome"));
        u.setCognome(rs.getString("cognome"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setUsernameSteam(rs.getString("username_steam"));
        u.setAttivo(rs.getBoolean("attivo"));
        return u;
    }
}
