package org.isetn.RestControllers;

import java.util.List;
import org.isetn.entities.User;
import org.isetn.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

// Controleur d'authentification et CRUD utilisateurs
@RestController
@CrossOrigin("*")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/register")
    public User Register(@RequestBody User user) {
        return userRepository.save(user);
    }

    @PostMapping("/login")
    public User Login(@RequestBody User user) {
        User oldUSer = userRepository.findByEmailAndPassword(user.getEmail(), user.getPassword());
        return oldUSer;
    }

    @GetMapping("/users")
    public List<User> getAll() {
        return userRepository.findAll();
    }

    @GetMapping("/users/{id}")
    public User getOne(@PathVariable Integer id) {
        return userRepository.findById(id).orElse(null);
    }

    @PostMapping("/users")
    public User create(@RequestBody User user) {
        return userRepository.save(user);
    }

    @PutMapping("/users/{id}")
    public User update(@PathVariable Integer id, @RequestBody User user) {
        user.setId(id);
        return userRepository.save(user);
    }

    @DeleteMapping("/users/{id}")
    public void delete(@PathVariable Integer id) {
        userRepository.deleteById(id);
    }
}

