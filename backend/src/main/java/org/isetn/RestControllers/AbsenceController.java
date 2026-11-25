package org.isetn.RestControllers;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.isetn.entities.Absence;
import org.isetn.repository.AbsenceRepository;
import org.isetn.repository.EtudiantRepository;
import org.isetn.repository.MatiereRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

// Controleur REST pour les absences et leurs totaux
@RestController
@RequestMapping("/absences")
@CrossOrigin("*")
public class AbsenceController {

    @Autowired
    private AbsenceRepository absenceRepository;

    @Autowired
    private MatiereRepository matiereRepository;

    @Autowired
    private EtudiantRepository etudiantRepository;

    @GetMapping
    public List<Absence> getAll(@RequestParam(required = false) String nce) {
        if (nce != null && !nce.isEmpty()) {
            return absenceRepository.findByEtudiantNce(nce);
        }
        return absenceRepository.findAll();
    }

    @GetMapping("/{id}")
    public Absence getOne(@PathVariable Long id) {
        return absenceRepository.findById(id).orElse(null);
    }

    @PostMapping
    public Absence create(@RequestBody Absence absence) {
        resolveRelations(absence);
        return absenceRepository.save(absence);
    }

    @PutMapping("/{id}")
    public Absence update(@PathVariable Long id, @RequestBody Absence absence) {
        absence.setId(id);
        resolveRelations(absence);
        return absenceRepository.save(absence);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        absenceRepository.deleteById(id);
    }

    // Somme des heures d'absence par matiere pour un etudiant
    @GetMapping("/totaux/{nce}")
    public List<Map<String, Object>> getTotaux(@PathVariable String nce) {
        List<Object[]> rows = absenceRepository.findTotauxByNce(nce);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Object[] row : rows) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("codMat", row[0]);
            item.put("total", row[1] != null ? ((Number) row[1]).doubleValue() : 0.0);
            result.add(item);
        }
        return result;
    }

    // Top 3 modules avec le plus d'heures d'absences cumulees (Question 2 Examen TP)
    @GetMapping("/top3-matieres")
    public List<Map<String, Object>> getTop3Matieres() {
        List<Object[]> rows = absenceRepository.findTopMatieresAbsences(
                org.springframework.data.domain.PageRequest.of(0, 3));
        List<Map<String, Object>> result = new ArrayList<>();
        for (Object[] row : rows) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("codMat", row[0]);
            item.put("intMat", row[1]);
            item.put("totalNha", row[2] != null ? ((Number) row[2]).doubleValue() : 0.0);
            result.add(item);
        }
        return result;
    }

    private void resolveRelations(Absence absence) {
        if (absence.getMatiere() != null && absence.getMatiere().getCodMat() != null) {
            matiereRepository.findById(absence.getMatiere().getCodMat()).ifPresent(absence::setMatiere);
        }
        if (absence.getEtudiant() != null && absence.getEtudiant().getNce() != null) {
            etudiantRepository.findById(absence.getEtudiant().getNce()).ifPresent(absence::setEtudiant);
        }
    }
}

