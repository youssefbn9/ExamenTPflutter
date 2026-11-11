package org.isetn.repository;

import org.isetn.entities.Departement;
import org.springframework.data.jpa.repository.JpaRepository;

// Acces aux departements
public interface DepartementRepository extends JpaRepository<Departement, String> {
}

