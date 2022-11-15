class ListItem {
    final int id;
    final String name;
    final int listId;

    ListItem(this.id, this.name, this.listId);

    factory ListItem.fromJson(Map<dynamic, dynamic> json) {
        return ListItem(
            json['id'] as int,
            json['name'] as String,
            json['list_id'] as int
        );
    }
}
