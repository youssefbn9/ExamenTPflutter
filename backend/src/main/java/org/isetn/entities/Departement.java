package org.isetn.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// Departement academique
@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Departement {
    @Id
    @Column(name = "cod_dept", length = 30)
    private String codDept;

    @Column(name = "nom_dept")
    private String nomDept;
}

