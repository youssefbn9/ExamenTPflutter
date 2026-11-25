package org.isetn.repository;

import java.util.List;
import org.isetn.entities.Absence;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

// Acces aux absences
public interface AbsenceRepository extends JpaRepository<Absence, Long> {
    List<Absence> findByEtudiantNce(String nce);

    @Query("SELECT a.matiere.codMat, SUM(a.nha) FROM Absence a WHERE a.etudiant.nce = :nce GROUP BY a.matiere.codMat ORDER BY a.matiere.codMat")
    List<Object[]> findTotauxByNce(@Param("nce") String nce);

    @Query("SELECT a.matiere.codMat, a.matiere.intMat, SUM(a.nha) FROM Absence a GROUP BY a.matiere.codMat, a.matiere.intMat ORDER BY SUM(a.nha) DESC")
    List<Object[]> findTopMatieresAbsences(org.springframework.data.domain.Pageable pageable);
}

