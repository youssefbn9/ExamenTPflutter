// Modele pour le top 3 des modules par heures d'absences cumulees (Examen TP Question 2)
class TopMatiereAbsence {
  final String codMat;
  final String intMat;
  final double totalNha;

  TopMatiereAbsence({
    required this.codMat,
    required this.intMat,
    required this.totalNha,
  });

  factory TopMatiereAbsence.fromJson(Map<String, dynamic> json) =>
      TopMatiereAbsence(
        codMat: (json['codMat'] ?? '') as String,
        intMat: (json['intMat'] ?? '') as String,
        totalNha: (json['totalNha'] as num?)?.toDouble() ?? 0.0,
      );
}
