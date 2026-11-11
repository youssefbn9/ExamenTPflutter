package org.isetn.entities;

import java.time.LocalDate;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// Etudiant inscrit dans une classe
@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Etudiant {
    @Id
    @Column(name = "nce", length = 30)
    private String nce;

    private String nom;
    private String prenom;

    @Column(name = "date_nais")
    private LocalDate dateNais;

    @Column(name = "lieu_nais")
    private String lieuNais;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "cod_class")
    private Classe classe;
}

