class Group {
    final int id;
    final String name;

    Group(this.id, this.name);

    factory Group.fromJson(Map<dynamic, dynamic> json) {
        return Group(
            json['id'] as int,
            json['name'] as String
        );
    }
}
