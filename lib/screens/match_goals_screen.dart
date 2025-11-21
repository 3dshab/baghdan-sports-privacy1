import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/match_summary_model.dart';
import '../models/group_model.dart';
import '../services/firebase_service.dart';
import 'video_player_screen.dart';

/// صفحة عرض أهداف المباريات
class MatchGoalsScreen extends StatefulWidget {
  const MatchGoalsScreen({super.key});

  @override
  State<MatchGoalsScreen> createState() => _MatchGoalsScreenState();
}

class _MatchGoalsScreenState extends State<MatchGoalsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _showAllGroups = true;
  String? _selectedGroupId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051622),
      appBar: AppBar(
        title: Text(
          'أهداف المباريات',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1BA098),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildGroupFilter(),
          Expanded(
            child: _buildMatchGoalsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF0A2E36),
      child: StreamBuilder<List<GroupModel>>(
        stream: _firebaseService.getGroups(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }

          final groups = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'الكل',
                  isSelected: _showAllGroups,
                  onTap: () {
                    setState(() {
                      _showAllGroups = true;
                      _selectedGroupId = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ...groups.map((group) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildFilterChip(
                        label: group.name,
                        isSelected:
                            !_showAllGroups && _selectedGroupId == group.id,
                        onTap: () {
                          setState(() {
                            _showAllGroups = false;
                            _selectedGroupId = group.id;
                          });
                        },
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00ff88)
              : const Color(0xFF051622).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00ff88)
                : const Color(0xFF1BA098).withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.cairo(
            color: isSelected ? const Color(0xFF051622) : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMatchGoalsList() {
    final stream = _showAllGroups
        ? _firebaseService.getMatchSummariesWithGoals()
        : _firebaseService.getMatchSummariesWithGoalsByGroup(_selectedGroupId!);

    return StreamBuilder<List<MatchSummaryModel>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00ff88),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'حدث خطأ في تحميل البيانات',
                style: GoogleFonts.cairo(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.sports_soccer_outlined,
                    size: 80,
                    color: Colors.white24,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد أهداف مسجلة',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            );
          }

          final matches = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return _buildMatchGoalsCard(match);
            },
          );
        });
  }

  Widget _buildMatchGoalsCard(MatchSummaryModel match) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1BA098).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1BA098).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس البطاقة - معلومات المباراة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1BA098).withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        match.homeTeam,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00ff88),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${match.homeScore} - ${match.awayScore}',
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF051622),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        match.awayTeam,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('yyyy/MM/dd - hh:mm a', 'ar')
                      .format(match.matchDate),
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // قائمة الأهداف
          if (match.goals.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الأهداف:',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00ff88),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...match.goals.map((goal) => _buildGoalItem(goal)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(GoalSummary goal) {
    final isHomeTeam = goal.team == 'home';
    final hasVideo = goal.videoUrl != null && goal.videoUrl!.isNotEmpty;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHomeTeam
            ? const Color(0xFF1E5A7D).withValues(alpha: 0.2)
            : const Color(0xFF7D1E1E).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHomeTeam
              ? const Color(0xFF1E5A7D).withValues(alpha: 0.5)
              : const Color(0xFF7D1E1E).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isHomeTeam
                  ? const Color(0xFF1E5A7D)
                  : const Color(0xFF7D1E1E),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sports_soccer,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.playerName,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  goal.teamName,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF00ff88).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF00ff88),
                width: 1,
              ),
            ),
            child: Text(
              "${goal.minute}'",
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00ff88),
              ),
            ),
          ),
          // زر تشغيل الفيديو
          if (hasVideo) const SizedBox(width: 8),
          if (hasVideo)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      videoUrl: goal.videoUrl!,
                      title: 'هدف ${goal.playerName}',
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00ff88).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF00ff88),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Color(0xFF00ff88),
                  size: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
