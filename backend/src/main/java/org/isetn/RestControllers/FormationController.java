package org.isetn.RestControllers;

import java.util.List;
import org.isetn.entities.Formation;
import org.isetn.repository.FormationRepository;
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

// Controleur REST pour les formations
@RestController
@RequestMapping("/formations")
@CrossOrigin("*")
public class FormationController {

    @Autowired
    private FormationRepository formationRepository;

    @GetMapping
    public List<Formation> getAll() {
        return formationRepository.findAll();
    }

    @GetMapping("/{id}")
    public Formation getOne(@PathVariable Long id) {
        return formationRepository.findById(id).orElse(null);
    }

    @PostMapping
    public Formation create(@RequestBody Formation formation) {
        return formationRepository.save(formation);
    }

    @PutMapping("/{id}")
    public Formation update(@PathVariable Long id, @RequestBody Formation formation) {
        formation.setId(id);
        return formationRepository.save(formation);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        formationRepository.deleteById(id);
    }
}

