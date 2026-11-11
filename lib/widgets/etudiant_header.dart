import 'package:flutter/material.dart';
import '../models/classe.dart';
import '../models/departement.dart';
import '../models/etudiant.dart';

// En-tete commun affichant Classe, Departement et infos Etudiant
class EtudiantHeader extends StatelessWidget {
  final Departement? departement;
  final Classe? classe;
  final Etudiant? etudiant;

  const EtudiantHeader({
    super.key,
    this.departement,
    this.classe,
    this.etudiant,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              'Classe : ${classe?.codClass ?? "-"}   Departement : ${departement?.codDept ?? "-"}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Etudiant : ${etudiant?.nce ?? "-"}   Nom : ${etudiant?.nom ?? "-"}   Prenom : ${etudiant?.prenom ?? "-"}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
