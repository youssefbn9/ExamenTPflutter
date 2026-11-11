import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/etudiant.dart';
import '../models/matiere.dart';
import '../models/note.dart';
import '../widgets/crud_page.dart';

// Ecran CRUD des notes avec selection etudiant et matiere
class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  List<Etudiant> _etudiants = [];
  List<Matiere> _matieres = [];

  @override
  void initState() {
    super.initState();
    ApiService.getEtudiants().then((list) {
      if (mounted) setState(() => _etudiants = list);
    });
    ApiService.getMatieres().then((list) {
      if (mounted) setState(() => _matieres = list);
    });
  }

  double? _parseNullableDouble(String? text) {
    if (text == null || text.trim().isEmpty) return null;
    return double.tryParse(text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return CrudPage<Note>(
      title: 'Gestion Notes',
      fetchItems: ApiService.getNotes,
      titleBuilder: (n) =>
          '${n.etudiant?.nce ?? "-"} | ${n.matiere?.codMat ?? "-"}',
      subtitleBuilder: (n) =>
          'TP1: ${n.tp1 ?? "-"}  TP2: ${n.tp2 ?? "-"}  DS: ${n.ds ?? "-"}  Exam: ${n.examen ?? "-"}',
      formFieldsBuilder: (existing, values, setDialogState) {
        values['nce'] ??= existing?.etudiant?.nce ??
            (_etudiants.isNotEmpty ? _etudiants.first.nce : null);
        values['codMat'] ??= existing?.matiere?.codMat ??
            (_matieres.isNotEmpty ? _matieres.first.codMat : null);
        values['tp1'] = existing?.tp1?.toString() ?? '';
        values['tp2'] = existing?.tp2?.toString() ?? '';
        values['ds'] = existing?.ds?.toString() ?? '';
        values['examen'] = existing?.examen?.toString() ?? '';

        return [
          DropdownButtonFormField<String>(
            value: values['nce'] as String?,
            decoration: const InputDecoration(labelText: 'Etudiant'),
            items: _etudiants
                .map(
                  (e) => DropdownMenuItem(
                    value: e.nce,
                    child: Text('${e.nce} - ${e.nom} ${e.prenom}'),
                  ),
                )
                .toList(),
            validator: (v) => v == null ? 'Requis' : null,
            onChanged: (v) => setDialogState(() => values['nce'] = v),
            onSaved: (v) => values['nce'] = v,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: values['codMat'] as String?,
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
            onChanged: (v) => setDialogState(() => values['codMat'] = v),
            onSaved: (v) => values['codMat'] = v,
          ),
          TextFormField(
            initialValue: values['tp1'] as String,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'TP1'),
            onSaved: (v) => values['tp1'] = v ?? '',
          ),
          TextFormField(
            initialValue: values['tp2'] as String,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'TP2'),
            onSaved: (v) => values['tp2'] = v ?? '',
          ),
          TextFormField(
            initialValue: values['ds'] as String,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'DS'),
            onSaved: (v) => values['ds'] = v ?? '',
          ),
          TextFormField(
            initialValue: values['examen'] as String,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Examen'),
            onSaved: (v) => values['examen'] = v ?? '',
          ),
        ];
      },
      onSave: (existing, values) async {
        final nce = values['nce'] as String;
        final codMat = values['codMat'] as String;
        final note = Note(
          id: existing?.id,
          etudiant: Etudiant(nce: nce, nom: '', prenom: ''),
          matiere: Matiere(codMat: codMat, intMat: ''),
          tp1: _parseNullableDouble(values['tp1'] as String?),
          tp2: _parseNullableDouble(values['tp2'] as String?),
          ds: _parseNullableDouble(values['ds'] as String?),
          examen: _parseNullableDouble(values['examen'] as String?),
        );
        if (existing == null) {
          await ApiService.postJson('/notes', note.toJson());
        } else {
          await ApiService.putJson('/notes/${existing.id}', note.toJson());
        }
      },
      onDelete: (n) => ApiService.delete('/notes/${n.id}'),
    );
  }
}
