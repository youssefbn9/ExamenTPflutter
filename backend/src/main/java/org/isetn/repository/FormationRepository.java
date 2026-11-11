package org.isetn.repository;

import org.isetn.entities.Formation;
import org.springframework.data.jpa.repository.JpaRepository;

// Acces aux formations
public interface FormationRepository extends JpaRepository<Formation, Long> {
}

