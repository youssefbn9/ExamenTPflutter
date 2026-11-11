package org.isetn.repository;

import org.isetn.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

// Acces aux utilisateurs
public interface UserRepository extends JpaRepository<User, Integer> {
    User findByEmailAndPassword(String email, String password);
}

