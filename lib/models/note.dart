import 'etudiant.dart';
import 'matiere.dart';

// Modele Note
class Note {
  final int? id;
  final Etudiant? etudiant;
  final Matiere? matiere;
  final double? tp1;
  final double? tp2;
  final double? ds;
  final double? examen;

  Note({
    this.id,
    this.etudiant,
    this.matiere,
    this.tp1,
    this.tp2,
    this.ds,
    this.examen,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: (json['id'] as num?)?.toInt(),
        etudiant: json['etudiant'] != null
            ? Etudiant.fromJson(json['etudiant'] as Map<String, dynamic>)
            : null,
        matiere: json['matiere'] != null
            ? Matiere.fromJson(json['matiere'] as Map<String, dynamic>)
            : null,
        tp1: (json['tp1'] as num?)?.toDouble(),
        tp2: (json['tp2'] as num?)?.toDouble(),
        ds: (json['ds'] as num?)?.toDouble(),
        examen: (json['examen'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (etudiant != null) 'etudiant': {'nce': etudiant!.nce},
        if (matiere != null) 'matiere': {'codMat': matiere!.codMat},
        'tp1': tp1,
        'tp2': tp2,
        'ds': ds,
        'examen': examen,
      };
}

// Ligne de moyenne par module
class MoyenneLigne {
  final String codMat;
  final double? tp1;
  final double? tp2;
  final double? ds;
  final double? examen;
  final double moyenne;

  MoyenneLigne({
    required this.codMat,
    this.tp1,
    this.tp2,
    this.ds,
    this.examen,
    required this.moyenne,
  });

  factory MoyenneLigne.fromJson(Map<String, dynamic> json) => MoyenneLigne(
        codMat: (json['codMat'] ?? '') as String,
        tp1: (json['tp1'] as num?)?.toDouble(),
        tp2: (json['tp2'] as num?)?.toDouble(),
        ds: (json['ds'] as num?)?.toDouble(),
        examen: (json['examen'] as num?)?.toDouble(),
        moyenne: (json['moyenne'] as num?)?.toDouble() ?? 0.0,
      );
}

// Bulletin des moyennes d'un etudiant
class MoyenneBulletin {
  final List<MoyenneLigne> lignes;
  final double moyenneGenerale;

  MoyenneBulletin({required this.lignes, required this.moyenneGenerale});

  factory MoyenneBulletin.fromJson(Map<String, dynamic> json) {
    final rawList = (json['lignes'] as List<dynamic>? ?? []);
    return MoyenneBulletin(
      lignes: rawList
          .map((e) => MoyenneLigne.fromJson(e as Map<String, dynamic>))
          .toList(),
      moyenneGenerale: (json['moyenneGenerale'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

