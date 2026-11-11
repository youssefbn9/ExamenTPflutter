import 'classe.dart';

// Modele Etudiant
class Etudiant {
  final String nce;
  final String nom;
  final String prenom;
  final String? dateNais;
  final String? lieuNais;
  final Classe? classe;

  Etudiant({
    required this.nce,
    required this.nom,
    required this.prenom,
    this.dateNais,
    this.lieuNais,
    this.classe,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) => Etudiant(
        nce: (json['nce'] ?? '') as String,
        nom: (json['nom'] ?? '') as String,
        prenom: (json['prenom'] ?? '') as String,
        dateNais: json['dateNais'] as String?,
        lieuNais: json['lieuNais'] as String?,
        classe: json['classe'] != null
            ? Classe.fromJson(json['classe'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'nce': nce,
        'nom': nom,
        'prenom': prenom,
        if (dateNais != null && dateNais!.isNotEmpty) 'dateNais': dateNais,
        if (lieuNais != null) 'lieuNais': lieuNais,
        if (classe != null) 'classe': {'codClass': classe!.codClass},
      };
}

