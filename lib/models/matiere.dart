// Modele Matiere
class Matiere {
  final String codMat;
  final String intMat;
  final String? description;

  Matiere({
    required this.codMat,
    required this.intMat,
    this.description,
  });

  factory Matiere.fromJson(Map<String, dynamic> json) => Matiere(
        codMat: (json['codMat'] ?? '') as String,
        intMat: (json['intMat'] ?? '') as String,
        description: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'codMat': codMat,
        'intMat': intMat,
        'description': description ?? '',
      };
}
