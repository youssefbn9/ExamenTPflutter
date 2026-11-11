import 'departement.dart';

// Modele Classe
class Classe {
  final String codClass;
  final String nomClass;
  final int nbrEtud;
  final Departement? departement;

  Classe({
    required this.codClass,
    required this.nomClass,
    required this.nbrEtud,
    this.departement,
  });

  factory Classe.fromJson(Map<String, dynamic> json) => Classe(
        codClass: (json['codClass'] ?? '') as String,
        nomClass: (json['nomClass'] ?? '') as String,
        nbrEtud: (json['nbrEtud'] as num?)?.toInt() ?? 0,
        departement: json['departement'] != null
            ? Departement.fromJson(json['departement'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'codClass': codClass,
        'nomClass': nomClass,
        'nbrEtud': nbrEtud,
        if (departement != null) 'departement': {'codDept': departement!.codDept},
      };
}
