// Modele Departement
class Departement {
  final String codDept;
  final String nomDept;

  Departement({required this.codDept, required this.nomDept});

  factory Departement.fromJson(Map<String, dynamic> json) => Departement(
        codDept: (json['codDept'] ?? '') as String,
        nomDept: (json['nomDept'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
        'codDept': codDept,
        'nomDept': nomDept,
      };
}
