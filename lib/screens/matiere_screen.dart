import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/matiere.dart';
import '../widgets/crud_page.dart';

// Ecran CRUD des matieres
class MatiereScreen extends StatelessWidget {
  const MatiereScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CrudPage<Matiere>(
      title: 'Gestion Matieres',
      fetchItems: ApiService.getMatieres,
      titleBuilder: (m) => '${m.codMat} - ${m.intMat}',
      subtitleBuilder: (m) => m.description ?? '',
      formFieldsBuilder: (existing, values, _) {
        values['codMat'] = existing?.codMat ?? '';
        values['intMat'] = existing?.intMat ?? '';
        values['description'] = existing?.description ?? '';
        return [
          TextFormField(
            initialValue: values['codMat'] as String,
            enabled: existing == null,
            decoration: const InputDecoration(labelText: 'Code Matiere'),
            validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
            onSaved: (v) => values['codMat'] = v!.trim(),
          ),
          TextFormField(
            initialValue: values['intMat'] as String,
            decoration: const InputDecoration(labelText: 'Intitule Matiere'),
            validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
            onSaved: (v) => values['intMat'] = v!.trim(),
          ),
          TextFormField(
            initialValue: values['description'] as String,
            decoration: const InputDecoration(labelText: 'Description'),
            onSaved: (v) => values['description'] = v?.trim() ?? '',
          ),
        ];
      },
      onSave: (existing, values) async {
        final matiere = Matiere(
          codMat: existing?.codMat ?? (values['codMat'] as String),
          intMat: values['intMat'] as String,
          description: values['description'] as String?,
        );
        if (existing == null) {
          await ApiService.postJson('/matieres', matiere.toJson());
        } else {
          await ApiService.putJson(
            '/matieres/${Uri.encodeComponent(existing.codMat)}',
            matiere.toJson(),
          );
        }
      },
      onDelete: (m) =>
          ApiService.delete('/matieres/${Uri.encodeComponent(m.codMat)}'),
    );
  }
}

