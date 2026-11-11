package org.isetn.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// Classe d'etudiants rattachee a un departement
@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Classe {
    @Id
    @Column(name = "cod_class", length = 30)
    private String codClass;

    @Column(name = "nom_class")
    private String nomClass;

    @Column(name = "nbr_etud")
    private Integer nbrEtud;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "cod_dept")
    private Departement departement;
}

