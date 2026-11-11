import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api_service.dart';
import '../models/absence.dart';
import '../models/etudiant.dart';
import '../models/matiere.dart';
import '../widgets/dept_classe_etudiant_picker.dart';

// Ecran de gestion des absences par etudiant
class AbsenceScreen extends StatefulWidget {
  const AbsenceScreen({super.key});

  @override
  State<AbsenceScreen> createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsenceScreen> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();

  Etudiant? _selectedEtudiant;
  List<Absence> _absences = [];
  List<Matiere> _matieres = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    ApiService.getMatieres().then((list) {
      if (mounted) setState(() => _matieres = list);
    });
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    super.dispose();
  }

  Future<void> _loadAbsences() async {
    final etu = _selectedEtudiant;
    if (etu == null) {
      setState(() => _absences = []);
      return;
    }
    setState(() => _loading = true);
    try {
      final list = await ApiService.getAbsences(nce: etu.nce);
      if (!mounted) return;
      setState(() {
        _absences = list;
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

  String _formatDateFr(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return DateFormat('dd-MM-yyyy').format(dt);
    } catch (_) {
      return isoDate;
    }
  }

  Future<void> _openAbsenceForm([Absence? existing]) async {
    final etu = _selectedEtudiant;
    if (etu == null) return;

    final formKey = GlobalKey<FormState>();
    DateTime selectedDate = existing != null
        ? (DateTime.tryParse(existing.dateA) ?? DateTime.now())
        : DateTime.now();
    String? codMat = existing?.matiere?.codMat ??
        (_matieres.isNotEmpty ? _matieres.first.codMat : null);
    String nhaText = existing?.nha.toString() ?? '1.5';

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(
            existing == null ? 'Ajouter Absence' : 'Modifier Absence',
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date: ${DateFormat('dd-MM-yyyy').format(selectedDate)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setDialogState(() => selectedDate = picked);
                        }
                      },
                      child: const Text('Choisir'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: codMat,
                  decoration: const InputDecoration(labelText: 'Matiere'),
                  items: _matieres
                      .map(
                        (m) => DropdownMenuItem(
                          value: m.codMat,
                          child: Text('${m.codMat} - ${m.intMat}'),
                        ),
                      )
                      .toList(),
                  validator: (v) => v == null ? 'Requis' : null,
                  onChanged: (v) => setDialogState(() => codMat = v),
                ),
                TextFormField(
                  initialValue: nhaText,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'NHA'),
                  validator: (v) => (v == null || double.tryParse(v) == null)
                      ? 'Nombre requis'
                      : null,
                  onSaved: (v) => nhaText = v!.trim(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState!.save();
                  Navigator.pop(ctx, true);
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );

    if (ok == true && codMat != null) {
      final absence = Absence(
        id: existing?.id,
        etudiant: Etudiant(nce: etu.nce, nom: etu.nom, prenom: etu.prenom),
        matiere: Matiere(codMat: codMat!, intMat: ''),
        dateA: DateFormat('yyyy-MM-dd').format(selectedDate),
        nha: double.parse(nhaText),
      );
      try {
        if (existing == null) {
          await ApiService.postJson('/absences', absence.toJson());
        } else {
          await ApiService.putJson(
            '/absences/${existing.id}',
            absence.toJson(),
          );
        }
        await _loadAbsences();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteAbsence(Absence absence) async {
    if (absence.id == null) return;
    try {
      await ApiService.delete('/absences/${absence.id}');
      await _loadAbsences();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des absences'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectedEtudiant == null ? null : () => _openAbsenceForm(),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DeptClasseEtudiantPicker(
              onChanged: (_, __, etudiant) {
                setState(() {
                  _selectedEtudiant = etudiant;
                  _nomController.text = etudiant?.nom ?? '';
                  _prenomController.text = etudiant?.prenom ?? '';
                });
                _loadAbsences();
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nomController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _prenomController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Prenom',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('DateA')),
                            DataColumn(label: Text('CodMat')),
                            DataColumn(label: Text('NHA')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: _absences.map((a) {
                            return DataRow(
                              cells: [
                                DataCell(Text(_formatDateFr(a.dateA))),
                                DataCell(Text(a.matiere?.codMat ?? '')),
                                DataCell(Text(a.nha.toString())),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () => _openAbsenceForm(a),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => _deleteAbsence(a),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
