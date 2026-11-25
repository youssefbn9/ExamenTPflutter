// Modele pour les moyennes des etudiants d'une classe (Examen TP Question 1)
class EtudiantMoyenne {
  final String nce;
  final String nom;
  final String prenom;
  final double moyenne;

  EtudiantMoyenne({
    required this.nce,
    required this.nom,
    required this.prenom,
    required this.moyenne,
  });

  factory EtudiantMoyenne.fromJson(Map<String, dynamic> json) => EtudiantMoyenne(
        nce: (json['nce'] ?? '') as String,
        nom: (json['nom'] ?? '') as String,
        prenom: (json['prenom'] ?? '') as String,
        moyenne: (json['moyenne'] as num?)?.toDouble() ?? 0.0,
      );
}
