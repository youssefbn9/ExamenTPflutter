package org.isetn.RestControllers;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.isetn.entities.ClassMat;
import org.isetn.entities.Etudiant;
import org.isetn.entities.Note;
import org.isetn.repository.ClassMatRepository;
import org.isetn.repository.EtudiantRepository;
import org.isetn.repository.MatiereRepository;
import org.isetn.repository.NoteRepository;
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

// Controleur REST pour les notes et le calcul des moyennes
@RestController
@RequestMapping("/notes")
@CrossOrigin("*")
public class NoteController {

    @Autowired
    private NoteRepository noteRepository;

    @Autowired
    private EtudiantRepository etudiantRepository;

    @Autowired
    private MatiereRepository matiereRepository;

    @Autowired
    private ClassMatRepository classMatRepository;

    @GetMapping
    public List<Note> getAll(@RequestParam(required = false) String nce) {
        if (nce != null && !nce.isEmpty()) {
            return noteRepository.findByEtudiantNce(nce);
        }
        return noteRepository.findAll();
    }

    @GetMapping("/{id}")
    public Note getOne(@PathVariable Long id) {
        return noteRepository.findById(id).orElse(null);
    }

    @PostMapping
    public Note create(@RequestBody Note note) {
        resolveRelations(note);
        return noteRepository.save(note);
    }

    @PutMapping("/{id}")
    public Note update(@PathVariable Long id, @RequestBody Note note) {
        note.setId(id);
        resolveRelations(note);
        return noteRepository.save(note);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        noteRepository.deleteById(id);
    }

    // Calcul des moyennes par matiere et de la moyenne generale ponderee
    @GetMapping("/moyennes/{nce}")
    public Map<String, Object> getMoyennes(@PathVariable String nce) {
        Etudiant etudiant = etudiantRepository.findById(nce).orElse(null);
        String codClass = (etudiant != null && etudiant.getClasse() != null)
                ? etudiant.getClasse().getCodClass()
                : null;

        List<Note> notes = noteRepository.findByEtudiantNce(nce);
        List<Map<String, Object>> lignes = new ArrayList<>();
        double sommePonderee = 0.0;
        double sommeCoef = 0.0;

        for (Note n : notes) {
            double moyenne = calculerMoyenneMatiere(n);
            String codMat = n.getMatiere() != null ? n.getMatiere().getCodMat() : "";

            double coef = 1.0;
            if (codClass != null && !codMat.isEmpty()) {
                coef = classMatRepository.findByClasseCodClassAndMatiereCodMat(codClass, codMat)
                        .map(ClassMat::getCoef)
                        .orElse(1.0);
            }

            Map<String, Object> ligne = new LinkedHashMap<>();
            ligne.put("codMat", codMat);
            ligne.put("tp1", n.getTp1());
            ligne.put("tp2", n.getTp2());
            ligne.put("ds", n.getDs());
            ligne.put("examen", n.getExamen());
            ligne.put("moyenne", moyenne);
            lignes.add(ligne);

            sommePonderee += moyenne * coef;
            sommeCoef += coef;
        }

        double moyenneGenerale = sommeCoef > 0
                ? Math.round((sommePonderee / sommeCoef) * 100.0) / 100.0
                : 0.0;

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("lignes", lignes);
        result.put("moyenneGenerale", moyenneGenerale);
        return result;
    }

    // Moyennes de tous les etudiants d'une classe donnee (Question 1 Examen TP)
    @GetMapping("/moyennes-classe/{codClass}")
    public List<Map<String, Object>> getMoyennesClasse(@PathVariable String codClass) {
        List<Etudiant> etudiants = etudiantRepository.findByClasseCodClass(codClass);
        List<Map<String, Object>> result = new ArrayList<>();

        for (Etudiant etudiant : etudiants) {
            Map<String, Object> moyData = getMoyennes(etudiant.getNce());
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("nce", etudiant.getNce());
            item.put("nom", etudiant.getNom());
            item.put("prenom", etudiant.getPrenom());
            item.put("moyenne", moyData.get("moyenneGenerale"));
            result.add(item);
        }
        return result;
    }

    // Formule unique de moyenne: module TP si tp1 ou tp2 non nul, sinon cours (DS + Examen) / 2
    private double calculerMoyenneMatiere(Note note) {
        boolean isTp = note.getTp1() != null || note.getTp2() != null;
        double raw = isTp
                ? ((note.getTp1() != null ? note.getTp1() : 0.0) + (note.getTp2() != null ? note.getTp2() : 0.0)) / 2.0
                : ((note.getDs() != null ? note.getDs() : 0.0) + (note.getExamen() != null ? note.getExamen() : 0.0)) / 2.0;
        return Math.round(raw * 100.0) / 100.0;
    }

    private void resolveRelations(Note note) {
        if (note.getEtudiant() != null && note.getEtudiant().getNce() != null) {
            etudiantRepository.findById(note.getEtudiant().getNce()).ifPresent(note::setEtudiant);
        }
        if (note.getMatiere() != null && note.getMatiere().getCodMat() != null) {
            matiereRepository.findById(note.getMatiere().getCodMat()).ifPresent(note::setMatiere);
        }
    }
}

