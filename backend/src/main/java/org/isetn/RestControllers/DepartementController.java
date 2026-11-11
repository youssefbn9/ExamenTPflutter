package org.isetn.RestControllers;

import java.util.List;
import org.isetn.entities.Departement;
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
import org.springframework.web.bind.annotation.RestController;

// Controleur REST pour les departements
@RestController
@RequestMapping("/departements")
@CrossOrigin("*")
public class DepartementController {

    @Autowired
    private DepartementRepository departementRepository;

    @GetMapping
    public List<Departement> getAll() {
        return departementRepository.findAll();
    }

    @GetMapping("/{codDept}")
    public Departement getOne(@PathVariable String codDept) {
        return departementRepository.findById(codDept).orElse(null);
    }

    @PostMapping
    public Departement create(@RequestBody Departement departement) {
        return departementRepository.save(departement);
    }

    @PutMapping("/{codDept}")
    public Departement update(@PathVariable String codDept, @RequestBody Departement departement) {
        departement.setCodDept(codDept);
        return departementRepository.save(departement);
    }

    @DeleteMapping("/{codDept}")
    public void delete(@PathVariable String codDept) {
        departementRepository.deleteById(codDept);
    }
}

