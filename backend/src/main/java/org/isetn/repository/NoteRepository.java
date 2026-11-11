package org.isetn.repository;

import java.util.List;
import org.isetn.entities.Note;
import org.springframework.data.jpa.repository.JpaRepository;

// Acces aux notes
public interface NoteRepository extends JpaRepository<Note, Long> {
    List<Note> findByEtudiantNce(String nce);
}

