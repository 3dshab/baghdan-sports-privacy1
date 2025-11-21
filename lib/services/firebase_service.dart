import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/match_summary_model.dart';
import '../models/scorer_model.dart';
import '../models/group_model.dart';
import '../models/team_model.dart';
import '../models/match_model.dart';
import '../models/live_channel_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get match summaries stream
  Stream<List<MatchSummaryModel>> getMatchSummaries() {
    return _firestore
        .collection('match_summaries')
        .orderBy('matchDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map<MatchSummaryModel>((doc) => MatchSummaryModel.fromFirestore(doc))
            .toList());
  }

  // Get single match summary
  Future<MatchSummaryModel?> getMatchSummary(String matchId) async {
    try {
      final doc =
          await _firestore.collection('match_summaries').doc(matchId).get();
      if (doc.exists) {
        return MatchSummaryModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('فشل في جلب بيانات المباراة: $e');
    }
  }

  // Get scorers stream
  Stream<List<ScorerModel>> getScorers() {
    return _firestore
        .collection('scorers')
        .orderBy('goals', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map<ScorerModel>((doc) => ScorerModel.fromFirestore(doc)).toList());
  }

  // Get scorers by group
  Stream<List<ScorerModel>> getScorersByGroup(String groupId) {
    return _firestore
        .collection('scorers')
        .where('groupId', isEqualTo: groupId)
        .orderBy('goals', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map<ScorerModel>((doc) => ScorerModel.fromFirestore(doc)).toList());
  }

  // Get groups stream
  Stream<List<GroupModel>> getGroups() {
    return _firestore
        .collection('groups')
        .orderBy('name')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map<GroupModel>((doc) => GroupModel.fromFirestore(doc)).toList());
  }

  // Get teams stream
  Stream<List<TeamModel>> getTeams() {
    return _firestore
        .collection('teams')
        .orderBy('points', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map<TeamModel>((doc) => TeamModel.fromFirestore(doc)).toList());
  }

  // Get teams by group
  Stream<List<TeamModel>> getTeamsByGroup(String groupId) {
    return _firestore
        .collection('teams')
        .where('groupId', isEqualTo: groupId)
        .orderBy('points', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map<TeamModel>((doc) => TeamModel.fromFirestore(doc)).toList());
  }

  // Get match summaries with goals (أهداف المباريات)
  Stream<List<MatchSummaryModel>> getMatchSummariesWithGoals() {
    return _firestore
        .collection('match_summaries')
        .orderBy('matchDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map<MatchSummaryModel>((doc) => MatchSummaryModel.fromFirestore(doc))
            .where((match) => match.goals.isNotEmpty)
            .toList());
  }

  // Get match summaries by group
  Stream<List<MatchSummaryModel>> getMatchSummariesByGroup(String groupId) {
    return _firestore
        .collection('match_summaries')
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .map((snapshot) {
          final matches = snapshot.docs
              .map<MatchSummaryModel>((doc) => MatchSummaryModel.fromFirestore(doc))
              .toList();
          // ترتيب البيانات في التطبيق بدلاً من Firebase
          matches.sort((a, b) => b.matchDate.compareTo(a.matchDate));
          return matches;
        });
  }

  // Get match summaries with goals by group
  Stream<List<MatchSummaryModel>> getMatchSummariesWithGoalsByGroup(String groupId) {
    return _firestore
        .collection('match_summaries')
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .map((snapshot) {
          final matches = snapshot.docs
              .map<MatchSummaryModel>((doc) => MatchSummaryModel.fromFirestore(doc))
              .where((match) => match.goals.isNotEmpty)
              .toList();
          // ترتيب البيانات في التطبيق بدلاً من Firebase
          matches.sort((a, b) => b.matchDate.compareTo(a.matchDate));
          return matches;
        });
  }

  // Add a new match
  Future<void> addMatch(MatchModel match) async {
    try {
      await _firestore.collection('matches').add(match.toMap());
    } catch (e) {
      throw Exception('فشل في إضافة المباراة: $e');
    }
  }

  // Get live channels stream
  Stream<List<LiveChannelModel>> getLiveChannels() {
    return _firestore
        .collection('live_channels')
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map<LiveChannelModel>((doc) => LiveChannelModel.fromFirestore(doc))
            .where((channel) => channel.isActive) // فلترة في التطبيق بدلاً من Firebase
            .toList());
  }

  // Get all live channels (including inactive ones)
  Future<List<LiveChannelModel>> getAllLiveChannels() async {
    try {
      final snapshot = await _firestore.collection('live_channels').get();
      return snapshot.docs
          .map((doc) => LiveChannelModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب القنوات: $e');
    }
  }

  // Add a new live channel
  Future<void> addLiveChannel(LiveChannelModel channel) async {
    try {
      await _firestore.collection('live_channels').add(channel.toMap());
    } catch (e) {
      throw Exception('فشل في إضافة القناة: $e');
    }
  }

  // Delete a live channel
  Future<void> deleteLiveChannel(String channelId) async {
    try {
      await _firestore.collection('live_channels').doc(channelId).delete();
    } catch (e) {
      throw Exception('فشل في حذف القناة: $e');
    }
  }

  // Upload image to Firebase Storage
  Future<String> uploadImage({
    required File imageFile,
    required String folder,
    required String fileName,
  }) async {
    try {
      final ref = _storage.ref().child('$folder/$fileName');
      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('فشل في رفع الصورة: $e');
    }
  }

  // Add a new scorer
  Future<void> addScorer(ScorerModel scorer) async {
    try {
      await _firestore.collection('scorers').add(scorer.toMap());
    } catch (e) {
      throw Exception('فشل في إضافة الهداف: $e');
    }
  }

  // Update scorer
  Future<void> updateScorer(ScorerModel scorer) async {
    try {
      if (scorer.id == null) {
        throw Exception('معرف الهداف مفقود');
      }
      await _firestore.collection('scorers').doc(scorer.id).update(scorer.toMap());
    } catch (e) {
      throw Exception('فشل في تحديث الهداف: $e');
    }
  }

  // Update match
  Future<void> updateMatch(MatchModel match) async {
    try {
      if (match.id == null) {
        throw Exception('معرف المباراة مفقود');
      }
      await _firestore.collection('matches').doc(match.id).update(match.toMap());
    } catch (e) {
      throw Exception('فشل في تحديث المباراة: $e');
    }
  }

  // Create or update match summary
  Future<void> createOrUpdateMatchSummary(MatchModel match) async {
    try {
      if (match.id == null) {
        throw Exception('معرف المباراة مفقود');
      }

      final matchSummary = MatchSummaryModel(
        id: match.id,
        matchId: match.id!,
        homeTeam: match.homeTeam,
        awayTeam: match.awayTeam,
        homeScore: match.homeScore ?? 0,
        awayScore: match.awayScore ?? 0,
        matchDate: match.dateTime,
        matchSummary: match.matchSummary,
        summaryVideoUrl: match.summaryVideoUrl,
        firstHalfVideoUrl: match.firstHalfVideoUrl,
        secondHalfVideoUrl: match.secondHalfVideoUrl,
        goals: match.goals.map((goal) => GoalSummary(
          playerName: goal.playerName,
          teamName: goal.team == 'home' ? match.homeTeam : match.awayTeam,
          team: goal.team,
          minute: goal.minute,
          videoUrl: goal.videoUrl,
        )).toList(),
        groupId: match.groupId,
      );

      await _firestore
          .collection('match_summaries')
          .doc(match.id)
          .set(matchSummary.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('فشل في مزامنة ملخص المباراة: $e');
    }
  }
}
