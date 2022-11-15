class List {
    final int id;
    final String name;
    final String type;
    final double? value;
    final int groupId;

    List(this.id, this.name, this.type, this.value, this.groupId);

    factory List.fromJson(Map<dynamic, dynamic> json) {
        return List(
           json['id'] as int,
           json['name'] as String,
           json['type'] as String,
           json['value'] as double?,
           json['group_id'] as int
        );
    }
}
