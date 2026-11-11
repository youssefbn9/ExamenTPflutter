import 'package:flutter/material.dart';
import '../api_service.dart';
import '../user.dart';
import '../widgets/crud_page.dart';

// Ecran CRUD des utilisateurs
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CrudPage<User>(
      title: 'Gestion Utilisateurs',
      fetchItems: ApiService.getUsers,
      titleBuilder: (u) => u.email,
      subtitleBuilder: (u) => 'ID: ${u.id ?? "-"}',
      formFieldsBuilder: (existing, values, _) {
        values['email'] = existing?.email ?? '';
        values['password'] = existing?.password ?? '';
        return [
          TextFormField(
            initialValue: values['email'] as String,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
            onSaved: (v) => values['email'] = v!.trim(),
          ),
          TextFormField(
            initialValue: values['password'] as String,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
            onSaved: (v) => values['password'] = v!.trim(),
          ),
        ];
      },
      onSave: (existing, values) async {
        final user = User(
          existing?.id,
          values['email'] as String,
          password: values['password'] as String,
        );
        if (existing == null) {
          await ApiService.postJson('/users', user.toJson());
        } else {
          await ApiService.putJson('/users/${existing.id}', user.toJson());
        }
      },
      onDelete: (u) => ApiService.delete('/users/${u.id}'),
    );
  }
}

