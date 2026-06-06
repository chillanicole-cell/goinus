// lib/models/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String type;
  final String? company; // intern: unused | company: their company name
  final List<String>? skills;
  final String? cvPath;
  final double? gpa;
  final String? aboutMe;
  final String? educationHistory;
  final List<String>? documents;
  final String? photoUrl;
  final String? major;
  final String? industry;
  final String? location;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    this.company,
    this.skills,
    this.cvPath,
    this.gpa,
    this.aboutMe,
    this.educationHistory,
    this.documents,
    this.photoUrl,
    this.major,
    this.industry,
    this.location,
  });

  factory User.guest() => const User(
    id: 'guest',
    name: 'Guest User',
    email: 'guest@goinus.com',
    type: 'intern',
  );

  bool get isGuest => id == 'guest';

  // Backend sends type == "intern" for interns and "company" for companies.
  bool get isIntern =>
      type == 'intern' || type == 'student' || type == 'jobseeker';
  bool get isCompany => type == 'company' || type == 'employer';

  factory User.fromJson(Map<String, dynamic> json) {
    // FIX: backend sends "companyName" for Company users, not "company".
    // Accept either key so this works for both old and new responses.
    final companyValue =
        (json['companyName'] as String?) ?? (json['company'] as String?);

    return User(
      id: (json['id'] as String?) ?? 'guest',
      name: (json['name'] as String?) ?? 'User',
      email: (json['email'] as String?) ?? '',
      type: (json['type'] as String?) ?? 'intern',
      company: companyValue,
      skills: (json['skills'] as List?)?.map((e) => e.toString()).toList(),
      cvPath: json['cvPath'] as String?,
      gpa: (json['gpa'] as num?)?.toDouble(),
      aboutMe: json['aboutMe'] as String?,
      educationHistory: json['educationHistory'] as String?,
      documents: (json['documents'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      photoUrl: json['photoUrl'] as String?,
      major: json['major'] as String?,
      industry: json['industry'] as String?,
      location: json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'type': type,
    // FIX: persist both keys so fromJson can round-trip correctly.
    'company': company,
    'companyName': company,
    'skills': skills,
    'cvPath': cvPath,
    'gpa': gpa,
    'aboutMe': aboutMe,
    'educationHistory': educationHistory,
    'documents': documents,
    'photoUrl': photoUrl,
    'major': major,
    'industry': industry,
    'location': location,
  };

  User copyWith({
    String? name,
    String? email,
    String? type,
    String? company,
    List<String>? skills,
    String? cvPath,
    double? gpa,
    String? aboutMe,
    String? educationHistory,
    List<String>? documents,
    String? photoUrl,
    String? major,
    String? industry,
    String? location,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      type: type ?? this.type,
      company: company ?? this.company,
      skills: skills ?? this.skills,
      cvPath: cvPath ?? this.cvPath,
      gpa: gpa ?? this.gpa,
      aboutMe: aboutMe ?? this.aboutMe,
      educationHistory: educationHistory ?? this.educationHistory,
      documents: documents ?? this.documents,
      photoUrl: photoUrl ?? this.photoUrl,
      major: major ?? this.major,
      industry: industry ?? this.industry,
      location: location ?? this.location,
    );
  }
}
