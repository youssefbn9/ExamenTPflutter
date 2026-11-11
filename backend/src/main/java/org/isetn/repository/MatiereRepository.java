package org.isetn.repository;

import org.isetn.entities.Matiere;
import org.springframework.data.jpa.repository.JpaRepository;

// Acces aux matieres
public interface MatiereRepository extends JpaRepository<Matiere, String> {
}

