package com.rockstarreserve.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class CarrelloItem implements Serializable {

    private static final long serialVersionUID = 1L;

    private int     id;
    private int     utenteId;
    private int     edizioneId;
    private int     quantita;
    private String  sessionId;

    /* popolato via JOIN con la tabella edizioni */
    private Edizione edizione;

    public CarrelloItem() {}

    public int      getId()        { return id; }
    public int      getUtenteId()  { return utenteId; }
    public int      getEdizioneId(){ return edizioneId; }
    public int      getQuantita()  { return quantita; }
    public String   getSessionId() { return sessionId; }
    public Edizione getEdizione()  { return edizione; }

    public void setId(int id)               { this.id = id; }
    public void setUtenteId(int utenteId)   { this.utenteId = utenteId; }
    public void setEdizioneId(int eid)      { this.edizioneId = eid; }
    public void setQuantita(int quantita)   { this.quantita = quantita; }
    public void setSessionId(String sid)    { this.sessionId = sid; }
    public void setEdizione(Edizione e)     { this.edizione = e; }

    /** Subtotale riga: prezzo × quantità */
    public BigDecimal getSubtotale() {
        if (edizione == null || edizione.getPrezzo() == null) return BigDecimal.ZERO;
        return edizione.getPrezzo().multiply(BigDecimal.valueOf(quantita));
    }

    public String getSubtotaleFormattato() {
        return String.format("€%.2f", getSubtotale()).replace(".", ",");
    }
}
