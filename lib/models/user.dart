class User {
  final String id;
  final String username;
  final String avatarUrl;
  final String host;
  final String? token; // 实际开发中 Token 可能存 SecureStorage，这里仅作演示

  User({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.host,
    this.token,
  });

  // 工厂方法：从 JSON 解析 (模拟 API 返回)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String,
      token: json['token'] as String?, 
      host: json['host'] as String,
    );
  }
}