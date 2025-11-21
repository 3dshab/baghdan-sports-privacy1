class TeamModel {
  final String? id;
  final String name;
  final String groupId;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;
  final int points;

  TeamModel({
    this.id,
    required this.name,
    required this.groupId,
    this.played = 0,
    this.won = 0,
    this.drawn = 0,
    this.lost = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
    this.points = 0,
  });

  int get goalDifference => goalsFor - goalsAgainst;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'groupId': groupId,
      'played': played,
      'won': won,
      'drawn': drawn,
      'lost': lost,
      'goalsFor': goalsFor,
      'goalsAgainst': goalsAgainst,
      'points': points,
    };
  }

  factory TeamModel.fromMap(Map<String, dynamic> map, String id) {
    return TeamModel(
      id: id,
      name: map['name'] ?? '',
      groupId: map['groupId'] ?? '',
      played: map['played'] ?? 0,
      won: map['won'] ?? 0,
      drawn: map['drawn'] ?? 0,
      lost: map['lost'] ?? 0,
      goalsFor: map['goalsFor'] ?? 0,
      goalsAgainst: map['goalsAgainst'] ?? 0,
      points: map['points'] ?? 0,
    );
  }

  factory TeamModel.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TeamModel.fromMap(data, doc.id);
  }

  TeamModel copyWith({
    String? id,
    String? name,
    String? groupId,
    int? played,
    int? won,
    int? drawn,
    int? lost,
    int? goalsFor,
    int? goalsAgainst,
    int? points,
  }) {
    return TeamModel(
      id: id ?? this.id,
      name: name ?? this.name,
      groupId: groupId ?? this.groupId,
      played: played ?? this.played,
      won: won ?? this.won,
      drawn: drawn ?? this.drawn,
      lost: lost ?? this.lost,
      goalsFor: goalsFor ?? this.goalsFor,
      goalsAgainst: goalsAgainst ?? this.goalsAgainst,
      points: points ?? this.points,
    );
  }
}
