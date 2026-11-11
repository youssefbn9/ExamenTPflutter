import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/absence.dart';
import '../models/classe.dart';
import '../models/departement.dart';
import '../models/etudiant.dart';
import '../widgets/dept_classe_etudiant_picker.dart';
import '../widgets/etudiant_header.dart';

// Ecran des totaux d'absences par matiere et courbe fl_chart
class TotauxAbsencesScreen extends StatefulWidget {
  const TotauxAbsencesScreen({super.key});

  @override
  State<TotauxAbsencesScreen> createState() => _TotauxAbsencesScreenState();
}

class _TotauxAbsencesScreenState extends State<TotauxAbsencesScreen> {
  Departement? _dept;
  Classe? _classe;
  Etudiant? _etudiant;
  List<AbsenceTotal> _totaux = [];
  double? _totalSemestre;
  bool _loading = false;

  Future<void> _loadTotaux() async {
    final etu = _etudiant;
    if (etu == null) {
      setState(() {
        _totaux = [];
        _totalSemestre = null;
      });
      return;
    }
    setState(() {
      _loading = true;
      _totalSemestre = null;
    });
    try {
      final list = await ApiService.getAbsenceTotaux(etu.nce);
      if (!mounted) return;
      setState(() {
        _totaux = list;
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

  void _calculerTotalSemestre() {
    final sum = _totaux.fold<double>(0.0, (acc, item) => acc + item.total);
    setState(() => _totalSemestre = sum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Totaux des absences'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DeptClasseEtudiantPicker(
              onChanged: (d, c, e) {
                setState(() {
                  _dept = d;
                  _classe = c;
                  _etudiant = e;
                });
                _loadTotaux();
              },
            ),
            const SizedBox(height: 10),
            EtudiantHeader(
              departement: _dept,
              classe: _classe,
              etudiant: _etudiant,
            ),
            const SizedBox(height: 10),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else ...[
              DataTable(
                columns: const [
                  DataColumn(label: Text('CodMat')),
                  DataColumn(label: Text('Total NHA')),
                ],
                rows: _totaux
                    .map(
                      (t) => DataRow(
                        cells: [
                          DataCell(Text(t.codMat)),
                          DataCell(Text(t.total.toString())),
                        ],
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _totaux.isEmpty ? null : _calculerTotalSemestre,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Calculer'),
              ),
              if (_totalSemestre != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Total des absences / semestre : $_totalSemestre',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              if (_totaux.isNotEmpty)
                SizedBox(
                  height: 220,
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (value != idx.toDouble() ||
                                  idx < 0 ||
                                  idx >= _totaux.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  _totaux[idx].codMat,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            _totaux.length,
                            (i) => FlSpot(i.toDouble(), _totaux[i].total),
                          ),
                          isCurved: false,
                          color: Colors.purple,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                        ),
                      ],
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
