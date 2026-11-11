import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/classe.dart';
import '../models/etudiant.dart';
import '../widgets/crud_page.dart';

// Ecran CRUD des etudiants filtre par classe selectionnee au demarrage
class EtudiantScreen extends StatefulWidget {
  const EtudiantScreen({super.key});

  @override
  State<EtudiantScreen> createState() => _EtudiantScreenState();
}

class _EtudiantScreenState extends State<EtudiantScreen> {
  List<Classe> _classes = [];
  String? _selectedClass;

  @override
  void initState() {
    super.initState();
    ApiService.getClasses().then((list) {
      if (!mounted) return;
      setState(() {
        _classes = list;
        if (list.isNotEmpty) {
          _selectedClass = list.first.codClass;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CrudPage<Etudiant>(
      title: 'Gestion Etudiants',
      reloadKey: _selectedClass,
      topHeader: Row(
        children: [
          const Text(
            'Classe : ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text('Code Classe'),
              value: _selectedClass,
              items: _classes
                  .map(
                    (c) => DropdownMenuItem(
                      value: c.codClass,
                      child: Text(c.codClass),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedClass = v),
            ),
          ),
        ],
      ),
      fetchItems: () async {
        if (_selectedClass == null) return [];
        return ApiService.getEtudiants(classe: _selectedClass);
      },
      titleBuilder: (e) => '${e.nce} - ${e.nom} ${e.prenom}',
      subtitleBuilder: (e) =>
          'Classe: ${e.classe?.codClass ?? "-"} | Ne(e): ${e.dateNais ?? "-"} (${e.lieuNais ?? "-"})',
      formFieldsBuilder: (existing, values, setDialogState) {
        values['nce'] = existing?.nce ?? '';
        values['nom'] = existing?.nom ?? '';
        values['prenom'] = existing?.prenom ?? '';
        values['dateNais'] = existing?.dateNais ?? '2003-01-01';
        values['lieuNais'] = existing?.lieuNais ?? '';
        values['codClass'] ??= existing?.classe?.codClass ?? _selectedClass;

        return [
          TextFormField(
            initialValue: values['nce'] as String,
            enabled: existing == null,
            decoration: const InputDecoration(labelText: 'NCE'),
            validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
            onSaved: (v) => values['nce'] = v!.trim(),
          ),
          TextFormField(
            initialValue: values['nom'] as String,
            decoration: const InputDecoration(labelText: 'Nom'),
            validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
            onSaved: (v) => values['nom'] = v!.trim(),
          ),
          TextFormField(
            initialValue: values['prenom'] as String,
            decoration: const InputDecoration(labelText: 'Prenom'),
            validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
            onSaved: (v) => values['prenom'] = v!.trim(),
          ),
          TextFormField(
            initialValue: values['dateNais'] as String,
            decoration:
                const InputDecoration(labelText: 'Date Naissance (yyyy-MM-dd)'),
            onSaved: (v) => values['dateNais'] = v?.trim() ?? '',
          ),
          TextFormField(
            initialValue: values['lieuNais'] as String,
            decoration: const InputDecoration(labelText: 'Lieu Naissance'),
            onSaved: (v) => values['lieuNais'] = v?.trim() ?? '',
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _classes.any((c) => c.codClass == values['codClass'])
                ? values['codClass'] as String?
                : null,
            decoration: const InputDecoration(labelText: 'Classe'),
            items: _classes
                .map(
                  (c) => DropdownMenuItem(
                    value: c.codClass,
                    child: Text(c.codClass),
                  ),
                )
                .toList(),
            validator: (v) => v == null ? 'Requis' : null,
            onChanged: (v) => setDialogState(() => values['codClass'] = v),
            onSaved: (v) => values['codClass'] = v,
          ),
        ];
      },
      onSave: (existing, values) async {
        final codClass = values['codClass'] as String?;
        final etudiant = Etudiant(
          nce: existing?.nce ?? (values['nce'] as String),
          nom: values['nom'] as String,
          prenom: values['prenom'] as String,
          dateNais: values['dateNais'] as String?,
          lieuNais: values['lieuNais'] as String?,
          classe: codClass != null
              ? Classe(codClass: codClass, nomClass: codClass, nbrEtud: 0)
              : null,
        );
        if (existing == null) {
          await ApiService.postJson('/etudiants', etudiant.toJson());
        } else {
          await ApiService.putJson(
            '/etudiants/${Uri.encodeComponent(existing.nce)}',
            etudiant.toJson(),
          );
        }
      },
      onDelete: (e) =>
          ApiService.delete('/etudiants/${Uri.encodeComponent(e.nce)}'),
    );
  }
}
