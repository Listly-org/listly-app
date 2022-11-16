class CheckList {
    final int id;
    final String name;
    final String type;
    final double? value;
    final int itemsCount;
    final int completeditemsCount;
    final int groupId;

    CheckList(
        this.id, 
        this.name, 
        this.type, 
        this.value, 
        this.itemsCount,
        this.completeditemsCount,
        this.groupId
    );

    factory CheckList.fromJson(Map<dynamic, dynamic> json) {
        return CheckList(
           json['id'] as int,
           json['name'] as String,
           json['type'] as String,
           json['value'] as double?,
           json['items_count'] as int,
           json['completed_items_count'] as int,
           json['group_id'] as int
        );
    }
}
