class ScorerModel {
  final String? id;
  final String playerName;
  final String teamName;
  final String groupId;
  final int goals;
  final String? playerPhoto; // رابط صورة اللاعب (اختياري)

  ScorerModel({
    this.id,
    required this.playerName,
    required this.teamName,
    required this.groupId,
    required this.goals,
    this.playerPhoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'playerName': playerName,
      'teamName': teamName,
      'groupId': groupId,
      'goals': goals,
      'playerPhoto': playerPhoto,
    };
  }

  factory ScorerModel.fromMap(Map<String, dynamic> map, String id) {
    return ScorerModel(
      id: id,
      playerName: map['playerName'] ?? '',
      teamName: map['teamName'] ?? '',
      groupId: map['groupId'] ?? '',
      goals: map['goals'] ?? 0,
      playerPhoto: map['playerPhoto'],
    );
  }

  factory ScorerModel.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ScorerModel.fromMap(data, doc.id);
  }

  ScorerModel copyWith({
    String? id,
    String? playerName,
    String? teamName,
    String? groupId,
    int? goals,
    String? playerPhoto,
  }) {
    return ScorerModel(
      id: id ?? this.id,
      playerName: playerName ?? this.playerName,
      teamName: teamName ?? this.teamName,
      groupId: groupId ?? this.groupId,
      goals: goals ?? this.goals,
      playerPhoto: playerPhoto ?? this.playerPhoto,
    );
  }
}
