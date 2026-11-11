package org.isetn.repository;

import java.util.List;
import org.isetn.entities.Classe;
import org.springframework.data.jpa.repository.JpaRepository;

// Acces aux classes
public interface ClasseRepository extends JpaRepository<Classe, String> {
    List<Classe> findByDepartementCodDept(String codDept);
}

