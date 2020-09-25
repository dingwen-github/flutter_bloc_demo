///用户实体 User
class User {
  final num userId;
  final String username;
  final String password;
  final int age;

  User({this.userId, this.username, this.password, this.age});

  ///json转dart model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      username: json['username'],
      password: json['password'],
      age: json['age'],
    );
  }

  ///dart model 转 map
  Map<String, dynamic> toJson({User user}) {
    if (user != null) {
      return {
        'userId': user.userId,
        'username': user.username,
        'password': user.password,
        'age': user.age
      };
    } else {
      return {
        'userId': userId,
        'username': username,
        'password': password,
        'age': age
      };
    }
  }
}
