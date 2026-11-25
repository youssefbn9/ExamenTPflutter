-- Donnees initiales Workshop 7 et Suite TP7
INSERT INTO departement (cod_dept, nom_dept) VALUES ('TI', 'Technologies de l''Informatique');

INSERT INTO classe (cod_class, nom_class, nbr_etud, cod_dept) VALUES ('DSI33', 'DSI33', 25, 'TI');

INSERT INTO etudiant (nce, nom, prenom, date_nais, lieu_nais, cod_class) VALUES ('E1', 'Ben Foulen1', 'Foulen1', '2003-05-15', 'Nabeul', 'DSI33');
INSERT INTO etudiant (nce, nom, prenom, date_nais, lieu_nais, cod_class) VALUES ('E2', 'Ben Foulen2', 'Foulen2', '2003-08-20', 'Tunis', 'DSI33');

INSERT INTO matiere (cod_mat, int_mat, description) VALUES ('AFCP', 'Atelier Framework Cross-Platform', 'Module TP Flutter et Spring Boot');
INSERT INTO matiere (cod_mat, int_mat, description) VALUES ('SOA', 'Architecture Orientee Services', 'Module Cours Services Web');
INSERT INTO matiere (cod_mat, int_mat, description) VALUES ('BD', 'Bases de Donnees Avancees', 'Module SGBD');
INSERT INTO matiere (cod_mat, int_mat, description) VALUES ('DEV', 'Developpement Web', 'Module Web');

INSERT INTO class_mat (cod_mat, cod_class, coef, chsm) VALUES ('AFCP', 'DSI33', 1.0, 42.0);
INSERT INTO class_mat (cod_mat, cod_class, coef, chsm) VALUES ('SOA', 'DSI33', 2.0, 42.0);
INSERT INTO class_mat (cod_mat, cod_class, coef, chsm) VALUES ('BD', 'DSI33', 1.5, 30.0);

INSERT INTO absence (cod_mat, nce, date_a, nha) VALUES ('AFCP', 'E1', '2025-11-11', 1.5);
INSERT INTO absence (cod_mat, nce, date_a, nha) VALUES ('AFCP', 'E1', '2025-10-04', 4.5);
INSERT INTO absence (cod_mat, nce, date_a, nha) VALUES ('AFCP', 'E2', '2025-11-15', 2.0);
INSERT INTO absence (cod_mat, nce, date_a, nha) VALUES ('SOA', 'E1', '2025-10-20', 1.5);
INSERT INTO absence (cod_mat, nce, date_a, nha) VALUES ('SOA', 'E1', '2025-10-23', 3.0);
INSERT INTO absence (cod_mat, nce, date_a, nha) VALUES ('SOA', 'E1', '2025-10-16', 3.0);
INSERT INTO absence (cod_mat, nce, date_a, nha) VALUES ('SOA', 'E2', '2025-10-25', 3.0);
INSERT INTO absence (cod_mat, nce, date_a, nha) VALUES ('BD', 'E1', '2025-11-05', 4.5);
INSERT INTO absence (cod_mat, nce, date_a, nha) VALUES ('DEV', 'E2', '2025-11-08', 1.5);

INSERT INTO note (nce, cod_mat, tp1, tp2, ds, examen) VALUES ('E1', 'AFCP', 12.0, 14.0, NULL, NULL);
INSERT INTO note (nce, cod_mat, tp1, tp2, ds, examen) VALUES ('E1', 'SOA', NULL, NULL, 10.0, 14.0);
INSERT INTO note (nce, cod_mat, tp1, tp2, ds, examen) VALUES ('E2', 'AFCP', 14.0, 16.0, NULL, NULL);
INSERT INTO note (nce, cod_mat, tp1, tp2, ds, examen) VALUES ('E2', 'SOA', NULL, NULL, 12.0, 15.0);

INSERT INTO users (email, password) VALUES ('admin@gmail.com', 'admin');
INSERT INTO users (email, password) VALUES ('foulen@gmail.com', 'foulen');

INSERT INTO formation (nom, duree) VALUES ('Flutter & Spring Boot', 42);

