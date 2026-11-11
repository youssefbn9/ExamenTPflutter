package org.isetn.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// Matiere enseignee
@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Matiere {
    @Id
    @Column(name = "cod_mat", length = 30)
    private String codMat;

    @Column(name = "int_mat")
    private String intMat;

    private String description;
}

