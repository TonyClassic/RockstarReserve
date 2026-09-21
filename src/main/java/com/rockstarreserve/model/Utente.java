package com.rockstarreserve.model;

import java.io.Serializable;

public class Utente implements Serializable {

    private static final long serialVersionUID = 1L;

    private int     id;
    private String  nome;
    private String  cognome;
    private String  email;
    private String  password;
    private String  usernameSteam;
    private boolean attivo;

    public Utente() {}

    public Utente(int id, String nome, String cognome, String email,
                  String password, String usernameSteam, boolean attivo) {
        this.id            = id;
        this.nome          = nome;
        this.cognome       = cognome;
        this.email         = email;
        this.password      = password;
        this.usernameSteam = usernameSteam;
        this.attivo        = attivo;
    }

    public int     getId()            { return id; }
    public String  getNome()          { return nome; }
    public String  getCognome()       { return cognome; }
    public String  getEmail()         { return email; }
    public String  getPassword()      { return password; }
    public String  getUsernameSteam() { return usernameSteam; }
    public boolean isAttivo()         { return attivo; }

    public void setId(int id)                       { this.id = id; }
    public void setNome(String nome)                { this.nome = nome; }
    public void setCognome(String cognome)          { this.cognome = cognome; }
    public void setEmail(String email)              { this.email = email; }
    public void setPassword(String password)        { this.password = password; }
    public void setUsernameSteam(String u)          { this.usernameSteam = u; }
    public void setAttivo(boolean attivo)           { this.attivo = attivo; }

    public String getNomeCompleto() {
        return nome + " " + cognome;
    }
}
