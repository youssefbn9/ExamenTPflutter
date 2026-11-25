import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api_service.dart';
import '../models/classe.dart';
import '../models/departement.dart';
import '../models/etudiant_moyenne.dart';

// Examen TP (Question 1) : Moyennes de tous les etudiants d'une classe
class MoyennesClasseScreen extends StatefulWidget {
  const MoyennesClasseScreen({super.key});

  @override
  State<MoyennesClasseScreen> createState() => _MoyennesClasseScreenState();
}

class _MoyennesClasseScreenState extends State<MoyennesClasseScreen> {
  List<Departement> _departements = [];
  List<Classe> _classes = [];
  Departement? _selectedDept;
  Classe? _selectedClasse;

  List<EtudiantMoyenne> _moyennes = [];
  bool _loading = true;
  String _dateDuJour = '';

  @override
  void initState() {
    super.initState();
    _dateDuJour = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _initData();
  }

  Future<void> _initData() async {
    try {
      final depts = await ApiService.getDepartements();
      if (!mounted) return;
      _departements = depts;
      _selectedDept = depts.isNotEmpty ? depts.first : null;
      if (_selectedDept != null) {
        final classes = await ApiService.getClasses(dept: _selectedDept!.codDept);
        if (!mounted) return;
        _classes = classes;
        _selectedClasse = classes.isNotEmpty ? classes.first : null;
        if (_selectedClasse != null) {
          await _loadMoyennesClasse(_selectedClasse!.codClass);
        }
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadClassesForDept(Departement dept) async {
    setState(() => _loading = true);
    try {
      final classes = await ApiService.getClasses(dept: dept.codDept);
      if (!mounted) return;
      setState(() {
        _classes = classes;
        _selectedClasse = classes.isNotEmpty ? classes.first : null;
      });
      if (_selectedClasse != null) {
        await _loadMoyennesClasse(_selectedClasse!.codClass);
      } else {
        setState(() => _moyennes = []);
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMoyennesClasse(String codClass) async {
    setState(() => _loading = true);
    try {
      final list = await ApiService.getMoyennesClasse(codClass);
      if (!mounted) return;
      setState(() {
        _moyennes = list;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moyennes par classe'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Selecteurs Departement et Classe
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Departement>(
                    value: _selectedDept,
                    decoration: const InputDecoration(
                      labelText: 'Departement',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: _departements
                        .map(
                          (d) => DropdownMenuItem(
                            value: d,
                            child: Text(d.codDept),
                          ),
                        )
                        .toList(),
                    onChanged: (d) {
                      if (d != null) {
                        setState(() => _selectedDept = d);
                        _loadClassesForDept(d);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<Classe>(
                    value: _selectedClasse,
                    decoration: const InputDecoration(
                      labelText: 'Classe',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: _classes
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.codClass),
                          ),
                        )
                        .toList(),
                    onChanged: (c) {
                      if (c != null) {
                        setState(() => _selectedClasse = c);
                        _loadMoyennesClasse(c.codClass);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // En-tete conforme au sujet de l'examen
            Card(
              elevation: 2,
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Classe : ${_selectedClasse?.codClass ?? "-"}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      'Departement : ${_selectedDept?.codDept ?? "-"}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      'Date : $_dateDuJour',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Tableau des moyennes des etudiants
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_moyennes.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text('Aucun etudiant dans cette classe'),
                ),
              )
            else
              Card(
                elevation: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(Colors.purple.shade100),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Nom',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Prenom',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Moyenne',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: _moyennes
                        .map(
                          (item) => DataRow(
                            cells: [
                              DataCell(Text(item.nom)),
                              DataCell(Text(item.prenom)),
                              DataCell(
                                Text(
                                  item.moyenne.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
