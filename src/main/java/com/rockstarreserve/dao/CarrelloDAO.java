package com.rockstarreserve.dao;

import com.rockstarreserve.model.CarrelloItem;
import com.rockstarreserve.model.Edizione;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarrelloDAO {

    /* ------------------------------------------------------------------ */
    /*  Aggiunta al carrello                                                */
    /* ------------------------------------------------------------------ */

    /**
     * Aggiunge una riga al carrello oppure ne incrementa la quantità se esiste già.
     * Per gli utenti loggati usa utente_id; per i guest usa session_id.
     */
    public void aggiungi(int utenteId, String sessionId, int edizioneId, int quantita)
            throws SQLException {

        CarrelloItem esistente = findItem(utenteId, sessionId, edizioneId);

        if (esistente != null) {
            aggiornaQuantita(esistente.getId(), esistente.getQuantita() + quantita);
        } else {
            String sql = "INSERT INTO carrello (utente_id, edizione_id, quantita, session_id) "
                       + "VALUES (?, ?, ?, ?)";
            try (Connection c = DBConnection.getConnection();
                 PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setObject(1, utenteId > 0 ? utenteId : null);
                ps.setInt(2, edizioneId);
                ps.setInt(3, quantita);
                ps.setString(4, sessionId);
                ps.executeUpdate();
            }
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Rimozione                                                           */
    /* ------------------------------------------------------------------ */

    public boolean rimuovi(int itemId) throws SQLException {
        String sql = "DELETE FROM carrello WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Aggiornamento quantità                                              */
    /* ------------------------------------------------------------------ */

    public boolean aggiornaQuantita(int itemId, int nuovaQuantita) throws SQLException {
        if (nuovaQuantita <= 0) return rimuovi(itemId);
        String sql = "UPDATE carrello SET quantita = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, nuovaQuantita);
            ps.setInt(2, itemId);
            return ps.executeUpdate() > 0;
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Svuota carrello                                                     */
    /* ------------------------------------------------------------------ */

    public void svuota(int utenteId, String sessionId) throws SQLException {
        String sql = utenteId > 0
            ? "DELETE FROM carrello WHERE utente_id = ?"
            : "DELETE FROM carrello WHERE session_id = ? AND utente_id IS NULL";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (utenteId > 0) ps.setInt(1, utenteId);
            else               ps.setString(1, sessionId);
            ps.executeUpdate();
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Lettura carrello (con JOIN edizione)                                */
    /* ------------------------------------------------------------------ */

    public List<CarrelloItem> findByUtenteOSessione(int utenteId, String sessionId)
            throws SQLException {

        List<CarrelloItem> lista = new ArrayList<>();

        String sql = "SELECT c.*, e.nome, e.descrizione, e.prezzo, e.contenuti "
                   + "FROM carrello c "
                   + "JOIN edizioni e ON c.edizione_id = e.id "
                   + (utenteId > 0
                       ? "WHERE c.utente_id = ? "
                       : "WHERE c.session_id = ? AND c.utente_id IS NULL ")
                   + "ORDER BY c.id";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (utenteId > 0) ps.setInt(1, utenteId);
            else               ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapJoin(rs));
            }
        }
        return lista;
    }

    /* ------------------------------------------------------------------ */
    /*  Trasferimento sessione → utente (post-login)                       */
    /* ------------------------------------------------------------------ */

    /**
     * Dopo il login trasferisce le righe del carrello guest (session_id)
     * all'utente appena autenticato, evitando duplicati per edizione.
     */
    public void trasferisciSessioneAUtente(String sessionId, int utenteId) throws SQLException {
        if (sessionId == null || utenteId <= 0) return;

        List<CarrelloItem> items = findByUtenteOSessione(0, sessionId);
        for (CarrelloItem item : items) {
            CarrelloItem esistente = findItem(utenteId, null, item.getEdizioneId());
            if (esistente != null) {
                aggiornaQuantita(esistente.getId(), esistente.getQuantita() + item.getQuantita());
                rimuovi(item.getId());
            } else {
                String sql = "UPDATE carrello SET utente_id = ?, session_id = NULL WHERE id = ?";
                try (Connection c = DBConnection.getConnection();
                     PreparedStatement ps = c.prepareStatement(sql)) {
                    ps.setInt(1, utenteId);
                    ps.setInt(2, item.getId());
                    ps.executeUpdate();
                }
            }
        }
    }

    /* ------------------------------------------------------------------ */
    /*  Helper privato: cerca una riga specifica                            */
    /* ------------------------------------------------------------------ */

    private CarrelloItem findItem(int utenteId, String sessionId, int edizioneId)
            throws SQLException {

        String sql = utenteId > 0
            ? "SELECT c.*, e.nome, e.descrizione, e.prezzo, e.contenuti "
            + "FROM carrello c JOIN edizioni e ON c.edizione_id = e.id "
            + "WHERE c.utente_id = ? AND c.edizione_id = ?"
            : "SELECT c.*, e.nome, e.descrizione, e.prezzo, e.contenuti "
            + "FROM carrello c JOIN edizioni e ON c.edizione_id = e.id "
            + "WHERE c.session_id = ? AND c.utente_id IS NULL AND c.edizione_id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (utenteId > 0) ps.setInt(1, utenteId);
            else               ps.setString(1, sessionId);
            ps.setInt(2, edizioneId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapJoin(rs);
            }
        }
        return null;
    }

    /* ------------------------------------------------------------------ */
    /*  Mapping ResultSet → CarrelloItem                                    */
    /* ------------------------------------------------------------------ */

    private CarrelloItem mapJoin(ResultSet rs) throws SQLException {
        CarrelloItem item = new CarrelloItem();
        item.setId(rs.getInt("id"));
        item.setUtenteId(rs.getInt("utente_id"));
        item.setEdizioneId(rs.getInt("edizione_id"));
        item.setQuantita(rs.getInt("quantita"));
        item.setSessionId(rs.getString("session_id"));

        Edizione e = new Edizione();
        e.setId(rs.getInt("edizione_id"));
        e.setNome(rs.getString("nome"));
        e.setDescrizione(rs.getString("descrizione"));
        e.setPrezzo(rs.getBigDecimal("prezzo"));
        e.setContenuti(rs.getString("contenuti"));
        item.setEdizione(e);

        return item;
    }
}
