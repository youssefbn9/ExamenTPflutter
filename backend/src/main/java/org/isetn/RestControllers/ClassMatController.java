package org.isetn.RestControllers;

import java.util.List;
import org.isetn.entities.ClassMat;
import org.isetn.repository.ClassMatRepository;
import org.isetn.repository.ClasseRepository;
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
import org.springframework.web.bind.annotation.RestController;

// Controleur REST pour les associations Classe-Matiere
@RestController
@RequestMapping("/classmats")
@CrossOrigin("*")
public class ClassMatController {

    @Autowired
    private ClassMatRepository classMatRepository;

    @Autowired
    private MatiereRepository matiereRepository;

    @Autowired
    private ClasseRepository classeRepository;

    @GetMapping
    public List<ClassMat> getAll() {
        return classMatRepository.findAll();
    }

    @GetMapping("/{id}")
    public ClassMat getOne(@PathVariable Long id) {
        return classMatRepository.findById(id).orElse(null);
    }

    @PostMapping
    public ClassMat create(@RequestBody ClassMat classMat) {
        resolveRelations(classMat);
        return classMatRepository.save(classMat);
    }

    @PutMapping("/{id}")
    public ClassMat update(@PathVariable Long id, @RequestBody ClassMat classMat) {
        classMat.setId(id);
        resolveRelations(classMat);
        return classMatRepository.save(classMat);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        classMatRepository.deleteById(id);
    }

    private void resolveRelations(ClassMat cm) {
        if (cm.getMatiere() != null && cm.getMatiere().getCodMat() != null) {
            matiereRepository.findById(cm.getMatiere().getCodMat()).ifPresent(cm::setMatiere);
        }
        if (cm.getClasse() != null && cm.getClasse().getCodClass() != null) {
            classeRepository.findById(cm.getClasse().getCodClass()).ifPresent(cm::setClasse);
        }
    }
}

