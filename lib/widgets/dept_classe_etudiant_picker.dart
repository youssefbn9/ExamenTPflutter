import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/classe.dart';
import '../models/departement.dart';
import '../models/etudiant.dart';

// Selecteur en cascade: Departement -> Classe -> Etudiant
class DeptClasseEtudiantPicker extends StatefulWidget {
  final void Function(Departement? dept, Classe? classe, Etudiant? etudiant)
      onChanged;

  const DeptClasseEtudiantPicker({
    super.key,
    required this.onChanged,
  });

  @override
  State<DeptClasseEtudiantPicker> createState() =>
      _DeptClasseEtudiantPickerState();
}

class _DeptClasseEtudiantPickerState extends State<DeptClasseEtudiantPicker> {
  List<Departement> _depts = [];
  List<Classe> _classes = [];
  List<Etudiant> _etudiants = [];

  Departement? _selectedDept;
  Classe? _selectedClasse;
  Etudiant? _selectedEtudiant;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDepts();
  }

  Future<void> _loadDepts() async {
    try {
      final depts = await ApiService.getDepartements();
      if (!mounted) return;
      _depts = depts;
      _selectedDept = depts.isNotEmpty ? depts.first : null;
      await _loadClasses(_selectedDept);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadClasses(Departement? dept) async {
    if (dept == null) {
      setState(() {
        _classes = [];
        _selectedClasse = null;
        _etudiants = [];
        _selectedEtudiant = null;
        _loading = false;
      });
      widget.onChanged(null, null, null);
      return;
    }
    final classes = await ApiService.getClasses(dept: dept.codDept);
    if (!mounted) return;
    _classes = classes;
    _selectedClasse = classes.isNotEmpty ? classes.first : null;
    await _loadEtudiants(_selectedClasse);
  }

  Future<void> _loadEtudiants(Classe? classe) async {
    if (classe == null) {
      setState(() {
        _etudiants = [];
        _selectedEtudiant = null;
        _loading = false;
      });
      widget.onChanged(_selectedDept, null, null);
      return;
    }
    final etudiants = await ApiService.getEtudiants(classe: classe.codClass);
    if (!mounted) return;
    setState(() {
      _etudiants = etudiants;
      _selectedEtudiant = etudiants.isNotEmpty ? etudiants.first : null;
      _loading = false;
    });
    widget.onChanged(_selectedDept, _selectedClasse, _selectedEtudiant);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: LinearProgressIndicator(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<Departement>(
          value: _selectedDept,
          decoration: const InputDecoration(
            labelText: 'Departement',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items: _depts
              .map(
                (d) => DropdownMenuItem(
                  value: d,
                  child: Text('${d.codDept} - ${d.nomDept}'),
                ),
              )
              .toList(),
          onChanged: (d) async {
            setState(() => _selectedDept = d);
            await _loadClasses(d);
          },
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Classe>(
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
                  child: Text('${c.codClass} - ${c.nomClass}'),
                ),
              )
              .toList(),
          onChanged: (c) async {
            setState(() => _selectedClasse = c);
            await _loadEtudiants(c);
          },
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Etudiant>(
          value: _selectedEtudiant,
          decoration: const InputDecoration(
            labelText: 'Etudiant',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items: _etudiants
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text('${e.nce} - ${e.nom} ${e.prenom}'),
                ),
              )
              .toList(),
          onChanged: (e) {
            setState(() => _selectedEtudiant = e);
            widget.onChanged(_selectedDept, _selectedClasse, e);
          },
        ),
      ],
    );
  }
}
