package com.rockstarreserve.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class Edizione implements Serializable {

    private static final long serialVersionUID = 1L;

    private int        id;
    private String     nome;
    private String     descrizione;
    private BigDecimal prezzo;
    private String     contenuti;

    public Edizione() {}

    public Edizione(int id, String nome, String descrizione,
                    BigDecimal prezzo, String contenuti) {
        this.id          = id;
        this.nome        = nome;
        this.descrizione = descrizione;
        this.prezzo      = prezzo;
        this.contenuti   = contenuti;
    }

    public int        getId()          { return id; }
    public String     getNome()        { return nome; }
    public String     getDescrizione() { return descrizione; }
    public BigDecimal getPrezzo()      { return prezzo; }
    public String     getContenuti()   { return contenuti; }

    public void setId(int id)                    { this.id = id; }
    public void setNome(String nome)             { this.nome = nome; }
    public void setDescrizione(String d)         { this.descrizione = d; }
    public void setPrezzo(BigDecimal prezzo)     { this.prezzo = prezzo; }
    public void setContenuti(String contenuti)   { this.contenuti = contenuti; }

    /**
     * Restituisce il prezzo formattato con simbolo euro, es. "€69,99"
     */
    public String getPrezzoFormattato() {
        if (prezzo == null) return "€0,00";
        return String.format("€%.2f", prezzo).replace(".", ",");
    }
}
