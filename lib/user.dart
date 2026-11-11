// Modele utilisateur pour authentification et gestion CRUD
class User {
  int? id;
  String email;
  String? password;

  User(this.id, this.email, {this.password});

  factory User.fromMap(Map<String, dynamic> map) => User(
        map['id'] as int?,
        (map['email'] ?? '') as String,
        password: map['password'] as String?,
      );

  factory User.fromJson(Map<String, dynamic> json) => User.fromMap(json);

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'email': email,
        if (password != null) 'password': password,
      };
}

