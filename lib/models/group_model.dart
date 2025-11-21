class GroupModel {
  final String id;
  final String name;
  final int order;

  GroupModel({
    required this.id,
    required this.name,
    required this.order,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'order': order,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map, String id) {
    return GroupModel(
      id: id,
      name: map['name'] ?? '',
      order: map['order'] ?? 0,
    );
  }

  factory GroupModel.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupModel.fromMap(data, doc.id);
  }
}
