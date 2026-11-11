import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/departement.dart';
import '../widgets/crud_page.dart';

// Ecran CRUD des departements
class DepartementScreen extends StatelessWidget {
  const DepartementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CrudPage<Departement>(
      title: 'Gestion Departements',
      fetchItems: ApiService.getDepartements,
      titleBuilder: (d) => '${d.codDept} - ${d.nomDept}',
      formFieldsBuilder: (existing, values, _) {
        values['codDept'] = existing?.codDept ?? '';
        values['nomDept'] = existing?.nomDept ?? '';
        return [
          TextFormField(
            initialValue: values['codDept'] as String,
            enabled: existing == null,
            decoration: const InputDecoration(labelText: 'Code Departement'),
            validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
            onSaved: (v) => values['codDept'] = v!.trim(),
          ),
          TextFormField(
            initialValue: values['nomDept'] as String,
            decoration: const InputDecoration(labelText: 'Nom Departement'),
            validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
            onSaved: (v) => values['nomDept'] = v!.trim(),
          ),
        ];
      },
      onSave: (existing, values) async {
        final dept = Departement(
          codDept: existing?.codDept ?? (values['codDept'] as String),
          nomDept: values['nomDept'] as String,
        );
        if (existing == null) {
          await ApiService.postJson('/departements', dept.toJson());
        } else {
          await ApiService.putJson(
            '/departements/${Uri.encodeComponent(existing.codDept)}',
            dept.toJson(),
          );
        }
      },
      onDelete: (d) =>
          ApiService.delete('/departements/${Uri.encodeComponent(d.codDept)}'),
    );
  }
}

