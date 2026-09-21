package com.rockstarreserve.dao;

import com.rockstarreserve.model.Ordine;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrdineDAO {

    /* ------------------------------------------------------------------ */
    /*  INSERT                                                              */
    /* ------------------------------------------------------------------ */

    public boolean insert(Ordine o) throws SQLException {
        String sql = "INSERT INTO ordini (utente_id, edizione_id, data_ordine, metodo_pagamento, prezzo_pagato) "
                   + "VALUES (?, ?, NOW(), ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, o.getUtenteId());
            ps.setInt(2, o.getEdizioneId());
            ps.setString(3, o.getMetodoPagamento());
            ps.setBigDecimal(4, o.getPrezzoEdizione() != null ?
                new java.math.BigDecimal(o.getPrezzoEdizione().replace("€","").replace(",",".").trim()) :
                java.math.BigDecimal.ZERO);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean esisteOrdine(int utenteId, int edizioneId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ordini WHERE utente_id = ? AND edizione_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, utenteId);
            ps.setInt(2, edizioneId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    /* ------------------------------------------------------------------ */
    /*  SELECT per utente (area "I miei preordini")                        */
    /* ------------------------------------------------------------------ */

    public List<Ordine> findByUtente(int utenteId) throws SQLException {
        List<Ordine> lista = new ArrayList<>();
        String sql = "SELECT o.*, u.nome, u.cognome, u.email, u.username_steam, "
                   + "       e.nome AS nome_edizione, e.prezzo "
                   + "FROM ordini o "
                   + "JOIN utenti u ON o.utente_id = u.id "
                   + "JOIN edizioni e ON o.edizione_id = e.id "
                   + "WHERE o.utente_id = ? "
                   + "ORDER BY o.data_ordine DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, utenteId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapJoin(rs));
            }
        }
        return lista;
    }

    /* ------------------------------------------------------------------ */
    /*  SELECT tutti (area admin, con filtri opzionali)                    */
    /* ------------------------------------------------------------------ */

    /**
     * Restituisce tutti gli ordini con filtri opzionali.
     * Passare null per i parametri che non si vogliono filtrare.
     *
     * @param dataInizio  es. "2025-01-01"  (può essere null)
     * @param dataFine    es. "2025-12-31"  (può essere null)
     * @param utenteId    ID utente (0 = nessun filtro)
     */
    public List<Ordine> findByFiltri(String dataInizio, String dataFine, int utenteId)
            throws SQLException {

        List<Ordine> lista = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT o.*, u.nome, u.cognome, u.email, u.username_steam, "
          + "       e.nome AS nome_edizione, e.prezzo "
          + "FROM ordini o "
          + "JOIN utenti u ON o.utente_id = u.id "
          + "JOIN edizioni e ON o.edizione_id = e.id "
          + "WHERE 1=1 ");

        if (dataInizio != null && !dataInizio.isEmpty())
            sql.append("AND DATE(o.data_ordine) >= ? ");
        if (dataFine != null && !dataFine.isEmpty())
            sql.append("AND DATE(o.data_ordine) <= ? ");
        if (utenteId > 0)
            sql.append("AND o.utente_id = ? ");

        sql.append("ORDER BY o.data_ordine DESC");

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {

            int idx = 1;
            if (dataInizio != null && !dataInizio.isEmpty()) ps.setString(idx++, dataInizio);
            if (dataFine   != null && !dataFine.isEmpty())   ps.setString(idx++, dataFine);
            if (utenteId > 0)                                ps.setInt(idx, utenteId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapJoin(rs));
            }
        }
        return lista;
    }

    /* ------------------------------------------------------------------ */
    /*  Mapping                                                             */
    /* ------------------------------------------------------------------ */

    private Ordine mapJoin(ResultSet rs) throws SQLException {
        Ordine o = new Ordine();
        o.setId(rs.getInt("id"));
        o.setUtenteId(rs.getInt("utente_id"));
        o.setEdizioneId(rs.getInt("edizione_id"));
        o.setDataOrdine(rs.getTimestamp("data_ordine"));
        o.setMetodoPagamento(rs.getString("metodo_pagamento"));
        o.setNomeUtente(rs.getString("nome"));
        o.setCognomeUtente(rs.getString("cognome"));
        o.setEmailUtente(rs.getString("email"));
        o.setUsernameSteam(rs.getString("username_steam"));
        o.setNomeEdizione(rs.getString("nome_edizione"));
        o.setPrezzoEdizione("€" + rs.getBigDecimal("prezzo").toPlainString().replace(".", ","));
        return o;
    }
}
