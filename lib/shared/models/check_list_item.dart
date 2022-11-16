class CheckListItem {
    final int id;
    final String name;
    final bool completed;
    final int listId;

    CheckListItem(
        this.id, 
        this.name, 
        this.completed,
        this.listId
    );

    factory CheckListItem.fromJson(Map<dynamic, dynamic> json) {
        return CheckListItem(
            json['id'] as int,
            json['name'] as String,
            json['completed'] as bool,
            json['list_id'] as int
        );
    }
}
