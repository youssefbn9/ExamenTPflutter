import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'models/absence.dart';
import 'models/class_mat.dart';
import 'models/classe.dart';
import 'models/departement.dart';
import 'models/etudiant.dart';
import 'models/etudiant_moyenne.dart';
import 'models/matiere.dart';
import 'models/note.dart';
import 'models/top_matiere_absence.dart';
import 'user.dart';

// Service API REST generique pour communiquer avec Spring Boot
class ApiService {
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  static Future<dynamic> getJson(String path) async {
    final res = await http.get(Uri.parse('$baseUrl$path'));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return res.body.isEmpty ? null : jsonDecode(res.body);
    }
    throw Exception('GET $path failed (${res.statusCode})');
  }

  static Future<List<T>> getList<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final data = await getJson(path);
    if (data is! List) return [];
    return data.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return res.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('POST $path failed (${res.statusCode})');
  }

  static Future<Map<String, dynamic>> putJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return res.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('PUT $path failed (${res.statusCode})');
  }

  static Future<void> delete(String path) async {
    final res = await http.delete(Uri.parse('$baseUrl$path'));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('DELETE $path failed (${res.statusCode})');
    }
  }

  // Helpers par entite
  static Future<List<Departement>> getDepartements() =>
      getList('/departements', Departement.fromJson);

  static Future<List<Classe>> getClasses({String? dept}) {
    final q = (dept != null && dept.isNotEmpty)
        ? '?dept=${Uri.encodeQueryComponent(dept)}'
        : '';
    return getList('/classes$q', Classe.fromJson);
  }

  static Future<List<Etudiant>> getEtudiants({String? classe}) {
    final q = (classe != null && classe.isNotEmpty)
        ? '?classe=${Uri.encodeQueryComponent(classe)}'
        : '';
    return getList('/etudiants$q', Etudiant.fromJson);
  }

  static Future<List<Matiere>> getMatieres() =>
      getList('/matieres', Matiere.fromJson);

  static Future<List<ClassMat>> getClassMats() =>
      getList('/classmats', ClassMat.fromJson);

  static Future<List<Absence>> getAbsences({String? nce}) {
    final q = (nce != null && nce.isNotEmpty)
        ? '?nce=${Uri.encodeQueryComponent(nce)}'
        : '';
    return getList('/absences$q', Absence.fromJson);
  }

  static Future<List<AbsenceTotal>> getAbsenceTotaux(String nce) =>
      getList('/absences/totaux/${Uri.encodeComponent(nce)}', AbsenceTotal.fromJson);

  static Future<List<Note>> getNotes({String? nce}) {
    final q = (nce != null && nce.isNotEmpty)
        ? '?nce=${Uri.encodeQueryComponent(nce)}'
        : '';
    return getList('/notes$q', Note.fromJson);
  }

  static Future<MoyenneBulletin> getMoyennes(String nce) async {
    final data = await getJson('/notes/moyennes/${Uri.encodeComponent(nce)}');
    return MoyenneBulletin.fromJson(data as Map<String, dynamic>);
  }

  // Question 1 Examen
  static Future<List<EtudiantMoyenne>> getMoyennesClasse(String codClass) =>
      getList(
        '/notes/moyennes-classe/${Uri.encodeComponent(codClass)}',
        EtudiantMoyenne.fromJson,
      );

  // Question 2 Examen
  static Future<List<TopMatiereAbsence>> getTop3MatieresAbsences() =>
      getList('/absences/top3-matieres', TopMatiereAbsence.fromJson);

  static Future<List<User>> getUsers() => getList('/users', User.fromJson);
}

