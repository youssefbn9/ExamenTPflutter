import 'classe.dart';
import 'matiere.dart';

// Modele ClassMat (association Classe - Matiere)
class ClassMat {
  final int? id;
  final Matiere? matiere;
  final Classe? classe;
  final double coef;
  final double chsm;

  ClassMat({
    this.id,
    this.matiere,
    this.classe,
    required this.coef,
    required this.chsm,
  });

  factory ClassMat.fromJson(Map<String, dynamic> json) => ClassMat(
        id: (json['id'] as num?)?.toInt(),
        matiere: json['matiere'] != null
            ? Matiere.fromJson(json['matiere'] as Map<String, dynamic>)
            : null,
        classe: json['classe'] != null
            ? Classe.fromJson(json['classe'] as Map<String, dynamic>)
            : null,
        coef: (json['coef'] as num?)?.toDouble() ?? 1.0,
        chsm: (json['chsm'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (matiere != null) 'matiere': {'codMat': matiere!.codMat},
        if (classe != null) 'classe': {'codClass': classe!.codClass},
        'coef': coef,
        'chsm': chsm,
      };
}
