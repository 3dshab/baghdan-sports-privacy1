import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String playerName;
  final String team; // 'home' أو 'away'
  final int minute;
  final String? videoUrl; // رابط فيديو الهدف
  
  Goal({
    required this.playerName,
    required this.team,
    required this.minute,
    this.videoUrl,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'playerName': playerName,
      'team': team,
      'minute': minute,
      'videoUrl': videoUrl,
    };
  }
  
  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      playerName: map['playerName'] ?? '',
      team: map['team'] ?? 'home',
      minute: map['minute'] ?? 0,
      videoUrl: map['videoUrl'],
    );
  }
}

class StreamingPlatform {
  final String name;
  final String url;
  
  StreamingPlatform({required this.name, required this.url});
  
  Map<String, dynamic> toMap() {
    return {'name': name, 'url': url};
  }
  
  factory StreamingPlatform.fromMap(Map<String, dynamic> map) {
    return StreamingPlatform(
      name: map['name'] ?? '',
      url: map['url'] ?? '',
    );
  }
}

class MatchModel {
  final String? id;
  final String homeTeam;
  final String awayTeam;
  final DateTime dateTime;
  final int? homeScore;
  final int? awayScore;
  final String? liveStreamUrl; // الرابط الرئيسي (للتوافق مع الكود القديم)
  final List<StreamingPlatform> streamingPlatforms; // قنوات البث المتعددة
  final List<String> commentators; // المعلقين
  final String? mainReferee; // الحكم الرئيسي
  final String? firstAssistant; // الحكم المساعد الأول
  final String? secondAssistant; // الحكم المساعد الثاني
  final String? fourthOfficial; // الحكم الرابع
  final String? matchSummary; // ملخص المباراة
  final String? summaryVideoUrl; // رابط فيديو الملخص
  final String? firstHalfVideoUrl; // رابط فيديو الشوط الأول
  final String? secondHalfVideoUrl; // رابط فيديو الشوط الثاني
  final List<Goal> goals; // قائمة الأهداف
  final bool isLive;
  final String groupId;

  MatchModel({
    this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.dateTime,
    this.homeScore,
    this.awayScore,
    this.liveStreamUrl,
    this.streamingPlatforms = const [],
    this.commentators = const [],
    this.mainReferee,
    this.firstAssistant,
    this.secondAssistant,
    this.fourthOfficial,
    this.matchSummary,
    this.summaryVideoUrl,
    this.firstHalfVideoUrl,
    this.secondHalfVideoUrl,
    this.goals = const [],
    this.isLive = false,
    required this.groupId,
  });

  bool get isFinished => homeScore != null && awayScore != null;

  Map<String, dynamic> toMap() {
    return {
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'dateTime': Timestamp.fromDate(dateTime),
      'homeScore': homeScore,
      'awayScore': awayScore,
      'liveStreamUrl': liveStreamUrl,
      'streamingPlatforms': streamingPlatforms.map((p) => p.toMap()).toList(),
      'commentators': commentators,
      'mainReferee': mainReferee,
      'firstAssistant': firstAssistant,
      'secondAssistant': secondAssistant,
      'fourthOfficial': fourthOfficial,
      'matchSummary': matchSummary,
      'summaryVideoUrl': summaryVideoUrl,
      'firstHalfVideoUrl': firstHalfVideoUrl,
      'secondHalfVideoUrl': secondHalfVideoUrl,
      'goals': goals.map((g) => g.toMap()).toList(),
      'isLive': isLive,
      'groupId': groupId,
    };
  }

  factory MatchModel.fromMap(Map<String, dynamic> map, String id) {
    return MatchModel(
      id: id,
      homeTeam: map['homeTeam'] ?? '',
      awayTeam: map['awayTeam'] ?? '',
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      homeScore: map['homeScore'],
      awayScore: map['awayScore'],
      liveStreamUrl: map['liveStreamUrl'],
      streamingPlatforms: map['streamingPlatforms'] != null
          ? (map['streamingPlatforms'] as List)
              .map((p) => StreamingPlatform.fromMap(p as Map<String, dynamic>))
              .toList()
          : [],
      commentators: map['commentators'] != null
          ? List<String>.from(map['commentators'])
          : [],
      mainReferee: map['mainReferee'],
      firstAssistant: map['firstAssistant'],
      secondAssistant: map['secondAssistant'],
      fourthOfficial: map['fourthOfficial'],
      matchSummary: map['matchSummary'],
      summaryVideoUrl: map['summaryVideoUrl'],
      firstHalfVideoUrl: map['firstHalfVideoUrl'],
      secondHalfVideoUrl: map['secondHalfVideoUrl'],
      goals: map['goals'] != null
          ? (map['goals'] as List)
              .map((g) => Goal.fromMap(g as Map<String, dynamic>))
              .toList()
          : [],
      isLive: map['isLive'] ?? false,
      groupId: map['groupId'] ?? '',
    );
  }

  MatchModel copyWith({
    String? id,
    String? homeTeam,
    String? awayTeam,
    DateTime? dateTime,
    int? homeScore,
    int? awayScore,
    String? liveStreamUrl,
    List<StreamingPlatform>? streamingPlatforms,
    List<String>? commentators,
    String? mainReferee,
    String? firstAssistant,
    String? secondAssistant,
    String? fourthOfficial,
    String? matchSummary,
    String? summaryVideoUrl,
    String? firstHalfVideoUrl,
    String? secondHalfVideoUrl,
    List<Goal>? goals,
    bool? isLive,
    String? groupId,
  }) {
    return MatchModel(
      id: id ?? this.id,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      dateTime: dateTime ?? this.dateTime,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      liveStreamUrl: liveStreamUrl ?? this.liveStreamUrl,
      streamingPlatforms: streamingPlatforms ?? this.streamingPlatforms,
      commentators: commentators ?? this.commentators,
      mainReferee: mainReferee ?? this.mainReferee,
      firstAssistant: firstAssistant ?? this.firstAssistant,
      secondAssistant: secondAssistant ?? this.secondAssistant,
      fourthOfficial: fourthOfficial ?? this.fourthOfficial,
      matchSummary: matchSummary ?? this.matchSummary,
      summaryVideoUrl: summaryVideoUrl ?? this.summaryVideoUrl,
      firstHalfVideoUrl: firstHalfVideoUrl ?? this.firstHalfVideoUrl,
      secondHalfVideoUrl: secondHalfVideoUrl ?? this.secondHalfVideoUrl,
      goals: goals ?? this.goals,
      isLive: isLive ?? this.isLive,
      groupId: groupId ?? this.groupId,
    );
  }

  // دالة للحصول على رابط مشاركة المباراة
  String getShareText() {
    final dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final timeStr = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    
    String text = '⚽ $homeTeam 🆚 $awayTeam\n';
    text += '📅 $dateStr | ⏰ $timeStr\n';
    
    if (isFinished) {
      text += '\n🏆 النتيجة: $homeScore - $awayScore\n';
    }
    
    if (streamingPlatforms.isNotEmpty) {
      text += '\n📺 قنوات البث:\n';
      for (var platform in streamingPlatforms) {
        text += '• ${platform.name}: ${platform.url}\n';
      }
    } else if (liveStreamUrl != null && liveStreamUrl!.isNotEmpty) {
      text += '\n📺 رابط البث: $liveStreamUrl\n';
    }
    
    if (commentators.isNotEmpty) {
      text += '\n🎙️ المعلقون: ${commentators.join(', ')}\n';
    }
    
    if (mainReferee != null && mainReferee!.isNotEmpty) {
      text += '\n👨‍⚖️ الحكم: $mainReferee\n';
    }
    
    if (matchSummary != null && matchSummary!.isNotEmpty) {
      text += '\n📝 ملخص المباراة:\n$matchSummary\n';
    }
    
    text += '\n⚡ بطولة كأس بعدان 18 لكرة القدم';
    
    return text;
  }
}
