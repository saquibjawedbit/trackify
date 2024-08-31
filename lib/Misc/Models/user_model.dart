class UserModel {
  String? id;
  String email;
  String name;
  String rollno;
  int semester;

  UserModel({
    this.id,
    required this.email,
    required this.name,
    required this.rollno,
    required this.semester,
  });

  // Factory constructor to create a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      rollno: map['rollno'],
      semester: map['semester'],
    );
  }

  // Method to convert UserModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'rollno': rollno,
      'semester': semester,
    };
  }
}
