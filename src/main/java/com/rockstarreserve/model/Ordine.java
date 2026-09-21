package com.rockstarreserve.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Ordine implements Serializable {

    private static final long serialVersionUID = 1L;

    private int       id;
    private int       utenteId;
    private int       edizioneId;
    private Timestamp dataOrdine;
    private String    metodoPagamento;

    /* campi popolati via JOIN — non mappati su colonne dirette */
    private String  nomeUtente;
    private String  cognomeUtente;
    private String  emailUtente;
    private String  nomeEdizione;
    private String  prezzoEdizione;
    private String  usernameSteam;

    public Ordine() {}

    public int       getId()              { return id; }
    public int       getUtenteId()        { return utenteId; }
    public int       getEdizioneId()      { return edizioneId; }
    public Timestamp getDataOrdine()      { return dataOrdine; }
    public String    getMetodoPagamento() { return metodoPagamento; }
    public String    getNomeUtente()      { return nomeUtente; }
    public String    getCognomeUtente()   { return cognomeUtente; }
    public String    getEmailUtente()     { return emailUtente; }
    public String    getNomeEdizione()    { return nomeEdizione; }
    public String    getPrezzoEdizione()  { return prezzoEdizione; }
    public String    getUsernameSteam()   { return usernameSteam; }

    public void setId(int id)                         { this.id = id; }
    public void setUtenteId(int utenteId)             { this.utenteId = utenteId; }
    public void setEdizioneId(int edizioneId)         { this.edizioneId = edizioneId; }
    public void setDataOrdine(Timestamp dataOrdine)   { this.dataOrdine = dataOrdine; }
    public void setMetodoPagamento(String m)          { this.metodoPagamento = m; }
    public void setNomeUtente(String nomeUtente)      { this.nomeUtente = nomeUtente; }
    public void setCognomeUtente(String cognomeUtente){ this.cognomeUtente = cognomeUtente; }
    public void setEmailUtente(String emailUtente)    { this.emailUtente = emailUtente; }
    public void setNomeEdizione(String nomeEdizione)  { this.nomeEdizione = nomeEdizione; }
    public void setPrezzoEdizione(String p)           { this.prezzoEdizione = p; }
    public void setUsernameSteam(String u)            { this.usernameSteam = u; }

    public String getNomeCompletoUtente() {
        return nomeUtente + " " + cognomeUtente;
    }
}
