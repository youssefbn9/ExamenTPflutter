package org.isetn.RestControllers;

import java.util.List;
import org.isetn.entities.Classe;
import org.isetn.repository.ClasseRepository;
import org.isetn.repository.DepartementRepository;
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

// Controleur REST pour les classes
@RestController
@RequestMapping("/classes")
@CrossOrigin("*")
public class ClasseController {

    @Autowired
    private ClasseRepository classeRepository;

    @Autowired
    private DepartementRepository departementRepository;

    @GetMapping
    public List<Classe> getAll(@RequestParam(required = false) String dept) {
        if (dept != null && !dept.isEmpty()) {
            return classeRepository.findByDepartementCodDept(dept);
        }
        return classeRepository.findAll();
    }

    @GetMapping("/{codClass}")
    public Classe getOne(@PathVariable String codClass) {
        return classeRepository.findById(codClass).orElse(null);
    }

    @PostMapping
    public Classe create(@RequestBody Classe classe) {
        resolveDepartement(classe);
        return classeRepository.save(classe);
    }

    @PutMapping("/{codClass}")
    public Classe update(@PathVariable String codClass, @RequestBody Classe classe) {
        classe.setCodClass(codClass);
        resolveDepartement(classe);
        return classeRepository.save(classe);
    }

    @DeleteMapping("/{codClass}")
    public void delete(@PathVariable String codClass) {
        classeRepository.deleteById(codClass);
    }

    private void resolveDepartement(Classe classe) {
        if (classe.getDepartement() != null && classe.getDepartement().getCodDept() != null) {
            departementRepository.findById(classe.getDepartement().getCodDept())
                    .ifPresent(classe::setDepartement);
        }
    }
}

