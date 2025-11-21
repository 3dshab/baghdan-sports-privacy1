import 'package:cloud_firestore/cloud_firestore.dart';

/// نموذج ملخص المباراة - مجموعة منفصلة لسهولة جلب البيانات في تطبيق المستخدمين
class MatchSummaryModel {
  final String? id; // نفس معرف المباراة
  final String matchId; // معرف المباراة الأصلية
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final DateTime matchDate;
  final String? matchSummary; // ملخص المباراة النصي
  final String? summaryVideoUrl; // رابط فيديو الملخص
  final String? firstHalfVideoUrl; // رابط فيديو الشوط الأول
  final String? secondHalfVideoUrl; // رابط فيديو الشوط الثاني
  final List<GoalSummary> goals; // قائمة الأهداف مع تفاصيل الهدافين
  final String groupId;

  MatchSummaryModel({
    this.id,
    required this.matchId,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.matchDate,
    this.matchSummary,
    this.summaryVideoUrl,
    this.firstHalfVideoUrl,
    this.secondHalfVideoUrl,
    this.goals = const [],
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'matchId': matchId,
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'matchDate': Timestamp.fromDate(matchDate),
      'matchSummary': matchSummary,
      'summaryVideoUrl': summaryVideoUrl,
      'firstHalfVideoUrl': firstHalfVideoUrl,
      'secondHalfVideoUrl': secondHalfVideoUrl,
      'goals': goals.map((g) => g.toMap()).toList(),
      'groupId': groupId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory MatchSummaryModel.fromMap(Map<String, dynamic> map, String id) {
    return MatchSummaryModel(
      id: id,
      matchId: map['matchId'] ?? '',
      homeTeam: map['homeTeam'] ?? '',
      awayTeam: map['awayTeam'] ?? '',
      homeScore: map['homeScore'] ?? 0,
      awayScore: map['awayScore'] ?? 0,
      matchDate: (map['matchDate'] as Timestamp).toDate(),
      matchSummary: map['matchSummary'],
      summaryVideoUrl: map['summaryVideoUrl'],
      firstHalfVideoUrl: map['firstHalfVideoUrl'],
      secondHalfVideoUrl: map['secondHalfVideoUrl'],
      goals: map['goals'] != null
          ? (map['goals'] as List)
              .map((g) => GoalSummary.fromMap(g as Map<String, dynamic>))
              .toList()
          : [],
      groupId: map['groupId'] ?? '',
    );
  }

  factory MatchSummaryModel.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MatchSummaryModel.fromMap(data, doc.id);
  }

  MatchSummaryModel copyWith({
    String? id,
    String? matchId,
    String? homeTeam,
    String? awayTeam,
    int? homeScore,
    int? awayScore,
    DateTime? matchDate,
    String? matchSummary,
    String? summaryVideoUrl,
    String? firstHalfVideoUrl,
    String? secondHalfVideoUrl,
    List<GoalSummary>? goals,
    String? groupId,
  }) {
    return MatchSummaryModel(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      matchDate: matchDate ?? this.matchDate,
      matchSummary: matchSummary ?? this.matchSummary,
      summaryVideoUrl: summaryVideoUrl ?? this.summaryVideoUrl,
      firstHalfVideoUrl: firstHalfVideoUrl ?? this.firstHalfVideoUrl,
      secondHalfVideoUrl: secondHalfVideoUrl ?? this.secondHalfVideoUrl,
      goals: goals ?? this.goals,
      groupId: groupId ?? this.groupId,
    );
  }
}

/// نموذج هدف مبسط مع معلومات الهداف
class GoalSummary {
  final String playerName; // اسم اللاعب الهداف
  final String teamName; // اسم الفريق
  final String team; // 'home' أو 'away'
  final int minute; // دقيقة الهدف
  final String? videoUrl; // رابط فيديو الهدف

  GoalSummary({
    required this.playerName,
    required this.teamName,
    required this.team,
    required this.minute,
    this.videoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'playerName': playerName,
      'teamName': teamName,
      'team': team,
      'minute': minute,
      'videoUrl': videoUrl,
    };
  }

  factory GoalSummary.fromMap(Map<String, dynamic> map) {
    return GoalSummary(
      playerName: map['playerName'] ?? '',
      teamName: map['teamName'] ?? '',
      team: map['team'] ?? 'home',
      minute: map['minute'] ?? 0,
      videoUrl: map['videoUrl'],
    );
  }
}
