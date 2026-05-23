// lib/models/user.dart

class User {
  final int? id;
  final String name;
  final String surname;
  final int age;
  final String gender;
  final List<String> allergens;
  final List<String> conditions;

  User({
    this.id,
    required this.name,
    required this.surname,
    this.age = 0,
    this.gender = '',
    this.allergens = const [],
    this.conditions = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // Eğer JSON’da id yoksa null kalır
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      surname: json['surname'] as String? ?? '',
      // age & gender JSON’da yoksa varsayılanı kullan
      age: (json['age'] as int?) ?? 0,
      gender: json['gender'] as String? ?? '',
      // allergens/conditions yoksa boş liste
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      conditions: (json['conditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'name': name,
      'surname': surname,
      'age': age,
      'gender': gender,
      'allergens': allergens,
      'conditions': conditions,
    };
    if (id != null) data['id'] = id;
    return data;
  }
}
