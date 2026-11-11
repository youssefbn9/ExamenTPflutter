package org.isetn.repository;

import java.util.List;
import org.isetn.entities.Etudiant;
import org.springframework.data.jpa.repository.JpaRepository;

// Acces aux etudiants
public interface EtudiantRepository extends JpaRepository<Etudiant, String> {
    List<Etudiant> findByClasseCodClass(String codClass);
}

