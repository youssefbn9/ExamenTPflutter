package org.isetn.RestControllers;

import java.util.List;
import org.isetn.entities.Etudiant;
import org.isetn.repository.ClasseRepository;
import org.isetn.repository.EtudiantRepository;
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

// Controleur REST pour les etudiants
@RestController
@RequestMapping("/etudiants")
@CrossOrigin("*")
public class EtudiantController {

    @Autowired
    private EtudiantRepository etudiantRepository;

    @Autowired
    private ClasseRepository classeRepository;

    @GetMapping
    public List<Etudiant> getAll(@RequestParam(required = false) String classe) {
        if (classe != null && !classe.isEmpty()) {
            return etudiantRepository.findByClasseCodClass(classe);
        }
        return etudiantRepository.findAll();
    }

    @GetMapping("/{nce}")
    public Etudiant getOne(@PathVariable String nce) {
        return etudiantRepository.findById(nce).orElse(null);
    }

    @PostMapping
    public Etudiant create(@RequestBody Etudiant etudiant) {
        resolveClasse(etudiant);
        return etudiantRepository.save(etudiant);
    }

    @PutMapping("/{nce}")
    public Etudiant update(@PathVariable String nce, @RequestBody Etudiant etudiant) {
        etudiant.setNce(nce);
        resolveClasse(etudiant);
        return etudiantRepository.save(etudiant);
    }

    @DeleteMapping("/{nce}")
    public void delete(@PathVariable String nce) {
        etudiantRepository.deleteById(nce);
    }

    private void resolveClasse(Etudiant etudiant) {
        if (etudiant.getClasse() != null && etudiant.getClasse().getCodClass() != null) {
            classeRepository.findById(etudiant.getClasse().getCodClass())
                    .ifPresent(etudiant::setClasse);
        }
    }
}

