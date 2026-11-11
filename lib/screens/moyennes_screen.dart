import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/classe.dart';
import '../models/departement.dart';
import '../models/etudiant.dart';
import '../models/note.dart';
import '../widgets/dept_classe_etudiant_picker.dart';
import '../widgets/etudiant_header.dart';

// Ecran d'affichage des notes et moyennes d'un etudiant
class MoyennesScreen extends StatefulWidget {
  const MoyennesScreen({super.key});

  @override
  State<MoyennesScreen> createState() => _MoyennesScreenState();
}

class _MoyennesScreenState extends State<MoyennesScreen> {
  Departement? _dept;
  Classe? _classe;
  Etudiant? _etudiant;
  MoyenneBulletin? _bulletin;
  bool _loading = false;

  Future<void> _loadMoyennes() async {
    final etu = _etudiant;
    if (etu == null) {
      setState(() => _bulletin = null);
      return;
    }
    setState(() => _loading = true);
    try {
      final bulletin = await ApiService.getMoyennes(etu.nce);
      if (!mounted) return;
      setState(() {
        _bulletin = bulletin;
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

  String _fmt(double? val) => val == null ? '' : val.toString();

  @override
  Widget build(BuildContext context) {
    final lignes = _bulletin?.lignes ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moyennes'),
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
                _loadMoyennes();
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Module')),
                    DataColumn(label: Text('TP1')),
                    DataColumn(label: Text('TP2')),
                    DataColumn(label: Text('DS')),
                    DataColumn(label: Text('Exam')),
                    DataColumn(label: Text('Moyenne')),
                  ],
                  rows: lignes
                      .map(
                        (l) => DataRow(
                          cells: [
                            DataCell(Text(l.codMat)),
                            DataCell(Text(_fmt(l.tp1))),
                            DataCell(Text(_fmt(l.tp2))),
                            DataCell(Text(_fmt(l.ds))),
                            DataCell(Text(_fmt(l.examen))),
                            DataCell(Text(l.moyenne.toString())),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Moyenne generale : ${_bulletin?.moyenneGenerale ?? 0}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.purple,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

