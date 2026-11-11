package org.isetn.repository;

import java.util.List;
import java.util.Optional;
import org.isetn.entities.ClassMat;
import org.springframework.data.jpa.repository.JpaRepository;

// Acces aux associations classe-matiere
public interface ClassMatRepository extends JpaRepository<ClassMat, Long> {
    List<ClassMat> findByClasseCodClass(String codClass);
    Optional<ClassMat> findByClasseCodClassAndMatiereCodMat(String codClass, String codMat);
}

