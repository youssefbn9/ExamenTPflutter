import 'package:flutter/material.dart';

// Widget generique reutilisable pour les ecrans CRUD
class CrudPage<T> extends StatefulWidget {
  final String title;
  final Widget? topHeader;
  final Object? reloadKey;
  final Future<List<T>> Function() fetchItems;
  final String Function(T item) titleBuilder;
  final String Function(T item)? subtitleBuilder;
  final List<Widget> Function(
    T? existing,
    Map<String, dynamic> values,
    StateSetter setDialogState,
  ) formFieldsBuilder;
  final Future<void> Function(T? existing, Map<String, dynamic> values) onSave;
  final Future<void> Function(T item) onDelete;

  const CrudPage({
    super.key,
    required this.title,
    this.topHeader,
    this.reloadKey,
    required this.fetchItems,
    required this.titleBuilder,
    this.subtitleBuilder,
    required this.formFieldsBuilder,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<CrudPage<T>> createState() => _CrudPageState<T>();
}

class _CrudPageState<T> extends State<CrudPage<T>> {
  List<T> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant CrudPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reloadKey != widget.reloadKey) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await widget.fetchItems();
      if (!mounted) return;
      setState(() {
        _items = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _openForm([T? existing]) async {
    final formKey = GlobalKey<FormState>();
    final values = <String, dynamic>{};
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Ajouter' : 'Modifier'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.formFieldsBuilder(
                  existing,
                  values,
                  setDialogState,
                ),
              ),
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

    if (saved == true) {
      try {
        await widget.onSave(existing, values);
        await _load();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _confirmDelete(T item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Supprimer cet element ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Non'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Oui'),
          ),
        ],
      ),
    );
    if (ok == true) {
      try {
        await widget.onDelete(item);
        await _load();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (widget.topHeader != null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: widget.topHeader!,
            ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : _items.isEmpty
                        ? const Center(child: Text('Aucune donnee'))
                        : ListView.builder(
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              final sub = widget.subtitleBuilder?.call(item);
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                child: ListTile(
                                  title: Text(widget.titleBuilder(item)),
                                  subtitle: sub != null ? Text(sub) : null,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () => _openForm(item),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => _confirmDelete(item),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
