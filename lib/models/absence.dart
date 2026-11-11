import 'etudiant.dart';
import 'matiere.dart';

// Modele Absence
class Absence {
  final int? id;
  final Matiere? matiere;
  final Etudiant? etudiant;
  final String dateA;
  final double nha;

  Absence({
    this.id,
    this.matiere,
    this.etudiant,
    required this.dateA,
    required this.nha,
  });

  factory Absence.fromJson(Map<String, dynamic> json) => Absence(
        id: (json['id'] as num?)?.toInt(),
        matiere: json['matiere'] != null
            ? Matiere.fromJson(json['matiere'] as Map<String, dynamic>)
            : null,
        etudiant: json['etudiant'] != null
            ? Etudiant.fromJson(json['etudiant'] as Map<String, dynamic>)
            : null,
        dateA: (json['dateA'] ?? '') as String,
        nha: (json['nha'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (matiere != null) 'matiere': {'codMat': matiere!.codMat},
        if (etudiant != null) 'etudiant': {'nce': etudiant!.nce},
        'dateA': dateA,
        'nha': nha,
      };
}

// Total des absences par matiere
class AbsenceTotal {
  final String codMat;
  final double total;

  AbsenceTotal({required this.codMat, required this.total});

  factory AbsenceTotal.fromJson(Map<String, dynamic> json) => AbsenceTotal(
        codMat: (json['codMat'] ?? '') as String,
        total: (json['total'] as num?)?.toDouble() ?? 0.0,
      );
}

