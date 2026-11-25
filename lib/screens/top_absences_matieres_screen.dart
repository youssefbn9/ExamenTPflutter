import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/top_matiere_absence.dart';

// Examen TP (Question 2) : Les 3 modules avec le plus d'heures d'absences cumulees
class TopAbsencesMatieresScreen extends StatefulWidget {
  const TopAbsencesMatieresScreen({super.key});

  @override
  State<TopAbsencesMatieresScreen> createState() =>
      _TopAbsencesMatieresScreenState();
}

class _TopAbsencesMatieresScreenState extends State<TopAbsencesMatieresScreen> {
  List<TopMatiereAbsence> _top3 = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTop3();
  }

  Future<void> _loadTop3() async {
    setState(() => _loading = true);
    try {
      final list = await ApiService.getTop3MatieresAbsences();
      if (!mounted) return;
      setState(() {
        _top3 = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Color _getBadgeColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // Or
      case 1:
        return const Color(0xFFC0C0C0); // Argent
      case 2:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top 3 Absences / Modules'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: Colors.purple.shade50,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Les 3 modules ayant enregistré le plus grand nombre d\'heures d\'absences (NHA) cumulées, toutes classes confondues.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.purple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_top3.isEmpty)
                    const Center(child: Text('Aucune donnée d\'absence enregistrée'))
                  else ...[
                    // Affichage sous forme de cartes classees
                    ..._top3.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: _getBadgeColor(index),
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getBadgeColor(index),
                            foregroundColor: Colors.black87,
                            child: Text(
                              '#${index + 1}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            '${item.codMat} - ${item.intMat}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${item.totalNha} h',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.red,
                                ),
                              ),
                              const Text(
                                'NHA cumulées',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    // Tableau recapitulatif conforme
                    Card(
                      elevation: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor:
                              WidgetStateProperty.all(Colors.purple.shade100),
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Rang',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Code Module',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Intitulé',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Total NHA',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: _top3.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final item = entry.value;
                            return DataRow(
                              cells: [
                                DataCell(Text('#${idx + 1}')),
                                DataCell(Text(item.codMat)),
                                DataCell(Text(item.intMat)),
                                DataCell(
                                  Text(
                                    '${item.totalNha} h',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
