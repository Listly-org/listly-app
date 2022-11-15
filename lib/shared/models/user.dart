class User {
    final int id;
    final String name;
    final String email;
    final String password;
    final int? groupId;

    User(this.id, this.name, this.email, this.password, this.groupId);

    factory User.fromJson(Map<dynamic, dynamic> json) {
        return User(
            json['id'] as int,
            json['name'] as String,
            json['email'] as String,
            json['password'] as String,
            json['group_id'] as int?
        );
    }
}
