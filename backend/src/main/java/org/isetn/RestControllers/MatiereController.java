package org.isetn.RestControllers;

import java.util.List;
import org.isetn.entities.Matiere;
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

// Controleur REST pour les matieres
@RestController
@RequestMapping("/matieres")
@CrossOrigin("*")
public class MatiereController {

    @Autowired
    private MatiereRepository matiereRepository;

    @GetMapping
    public List<Matiere> getAll() {
        return matiereRepository.findAll();
    }

    @GetMapping("/{codMat}")
    public Matiere getOne(@PathVariable String codMat) {
        return matiereRepository.findById(codMat).orElse(null);
    }

    @PostMapping
    public Matiere create(@RequestBody Matiere matiere) {
        return matiereRepository.save(matiere);
    }

    @PutMapping("/{codMat}")
    public Matiere update(@PathVariable String codMat, @RequestBody Matiere matiere) {
        matiere.setCodMat(codMat);
        return matiereRepository.save(matiere);
    }

    @DeleteMapping("/{codMat}")
    public void delete(@PathVariable String codMat) {
        matiereRepository.deleteById(codMat);
    }
}

