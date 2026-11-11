import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/classe.dart';
import '../models/departement.dart';
import '../widgets/crud_page.dart';

// Ecran CRUD des classes avec selection du departement
class ClasseScreen extends StatefulWidget {
  const ClasseScreen({super.key});

  @override
  State<ClasseScreen> createState() => _ClasseScreenState();
}

class _ClasseScreenState extends State<ClasseScreen> {
  List<Departement> _depts = [];

  @override
  void initState() {
    super.initState();
    ApiService.getDepartements().then((list) {
      if (mounted) setState(() => _depts = list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CrudPage<Classe>(
      title: 'Gestion Classes',
      fetchItems: ApiService.getClasses,
      titleBuilder: (c) => '${c.codClass} - ${c.nomClass}',
      subtitleBuilder: (c) =>
          'Dept: ${c.departement?.codDept ?? "-"} | Effectif: ${c.nbrEtud}',
      formFieldsBuilder: (existing, values, setDialogState) {
        values['codClass'] = existing?.codClass ?? '';
        values['nomClass'] = existing?.nomClass ?? '';
        values['nbrEtud'] = existing?.nbrEtud.toString() ?? '0';
        values['codDept'] ??= existing?.departement?.codDept ??
            (_depts.isNotEmpty ? _depts.first.codDept : null);

        return [
          TextFormField(
            initialValue: values['codClass'] as String,
            enabled: existing == null,
            decoration: const InputDecoration(labelText: 'Code Classe'),
            validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
            onSaved: (v) => values['codClass'] = v!.trim(),
          ),
          TextFormField(
            initialValue: values['nomClass'] as String,
            decoration: const InputDecoration(labelText: 'Nom Classe'),
            validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
            onSaved: (v) => values['nomClass'] = v!.trim(),
          ),
          TextFormField(
            initialValue: values['nbrEtud'] as String,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Nombre Etudiants'),
            validator: (v) => (v == null || int.tryParse(v) == null)
                ? 'Entier requis'
                : null,
            onSaved: (v) => values['nbrEtud'] = v!.trim(),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: values['codDept'] as String?,
            decoration: const InputDecoration(labelText: 'Departement'),
            items: _depts
                .map(
                  (d) => DropdownMenuItem(
                    value: d.codDept,
                    child: Text('${d.codDept} - ${d.nomDept}'),
                  ),
                )
                .toList(),
            validator: (v) => v == null ? 'Requis' : null,
            onChanged: (v) => setDialogState(() => values['codDept'] = v),
            onSaved: (v) => values['codDept'] = v,
          ),
        ];
      },
      onSave: (existing, values) async {
        final codDept = values['codDept'] as String?;
        final classe = Classe(
          codClass: existing?.codClass ?? (values['codClass'] as String),
          nomClass: values['nomClass'] as String,
          nbrEtud: int.parse(values['nbrEtud'] as String),
          departement: codDept != null
              ? Departement(codDept: codDept, nomDept: '')
              : null,
        );
        if (existing == null) {
          await ApiService.postJson('/classes', classe.toJson());
        } else {
          await ApiService.putJson(
            '/classes/${Uri.encodeComponent(existing.codClass)}',
            classe.toJson(),
          );
        }
      },
      onDelete: (c) =>
          ApiService.delete('/classes/${Uri.encodeComponent(c.codClass)}'),
    );
  }
}
