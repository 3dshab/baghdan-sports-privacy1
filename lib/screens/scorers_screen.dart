import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scorer_model.dart';
import '../models/group_model.dart';
import '../services/firebase_service.dart';
import 'scorer_detail_screen.dart';

/// صفحة عرض الهدافين للمستخدمين
class ScorersScreen extends StatefulWidget {
  const ScorersScreen({super.key});

  @override
  State<ScorersScreen> createState() => _ScorersScreenState();
}

class _ScorersScreenState extends State<ScorersScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String? _selectedGroupId;
  bool _showAllGroups = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051622),
      appBar: AppBar(
        title: Text(
          'الهدافين',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1BA098),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildGroupFilter(),
          Expanded(child: _buildScorersList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1BA098), const Color(0xFF0A2E36)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events, size: 60, color: Color(0xFFFFD700)),
          const SizedBox(height: 12),
          Text(
            'قائمة الهدافين',
            style: GoogleFonts.cairo(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أفضل اللاعبين تسجيلاً للأهداف',
            style: GoogleFonts.cairo(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2E36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: _showAllGroups,
                onChanged: (value) {
                  setState(() {
                    _showAllGroups = value ?? true;
                    if (_showAllGroups) {
                      _selectedGroupId = null;
                    }
                  });
                },
                activeColor: const Color(0xFF00ff88),
              ),
              Text(
                'عرض جميع المجموعات',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (!_showAllGroups)
            StreamBuilder<List<GroupModel>>(
              stream: _firebaseService.getGroups(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00ff88)),
                  );
                }

                final groups = snapshot.data!;

                if (_selectedGroupId == null && groups.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _selectedGroupId = groups.first.id;
                    });
                  });
                }

                return DropdownButtonFormField<String>(
                  initialValue: _selectedGroupId,
                  decoration: InputDecoration(
                    labelText: 'اختر المجموعة',
                    labelStyle: GoogleFonts.cairo(color: Colors.white70),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00ff88)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF00ff88),
                        width: 2,
                      ),
                    ),
                  ),
                  dropdownColor: const Color(0xFF051622),
                  style: GoogleFonts.cairo(color: Colors.white),
                  items: groups.map((group) {
                    return DropdownMenuItem(
                      value: group.id,
                      child: Text(group.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGroupId = value;
                    });
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildScorersList() {
    final stream = _showAllGroups
        ? _firebaseService.getScorers()
        : _firebaseService.getScorersByGroup(_selectedGroupId!);

    return StreamBuilder<List<ScorerModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00ff88)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'حدث خطأ في تحميل البيانات',
                  style: GoogleFonts.cairo(color: Colors.red, fontSize: 16),
                ),
              ],
            ),
          );
        }

        final scorers = snapshot.data ?? [];

        if (scorers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.sports_soccer,
                  size: 80,
                  color: Colors.white24,
                ),
                const SizedBox(height: 16),
                Text(
                  'لا يوجد هدافين',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'لم يتم إضافة أي هدافين بعد',
                  style: GoogleFonts.cairo(fontSize: 14, color: Colors.white38),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getCrossAxisCount(context),
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: scorers.length,
          itemBuilder: (context, index) {
            final scorer = scorers[index];
            final rank = index + 1;
            return _buildScorerCard(scorer, rank);
          },
        );
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 5;
    if (width > 900) return 4;
    if (width > 600) return 3;
    return 2;
  }

  Widget _buildScorerCard(ScorerModel scorer, int rank) {
    Color rankColor;
    String rankEmoji;

    if (rank == 1) {
      rankColor = const Color(0xFFFFD700); // Gold
      rankEmoji = '🥇';
    } else if (rank == 2) {
      rankColor = const Color(0xFFC0C0C0); // Silver
      rankEmoji = '🥈';
    } else if (rank == 3) {
      rankColor = const Color(0xFFCD7F32); // Bronze
      rankEmoji = '🥉';
    } else {
      rankColor = const Color(0xFF00ff88);
      rankEmoji = '';
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScorerDetailScreen(
              scorer: scorer,
              rank: rank,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: rankColor.withValues(alpha: 0.5), width: 2),
        ),
        color: const Color(0xFF0A2E36),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [rankColor.withValues(alpha: 0.1), const Color(0xFF0A2E36)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Rank Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: rankColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: rankColor.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (rankEmoji.isNotEmpty) ...[
                      Text(rankEmoji, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      '#$rank',
                      style: GoogleFonts.cairo(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Player Photo
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: rankColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: rankColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white10,
                  backgroundImage:
                      scorer.playerPhoto != null &&
                          scorer.playerPhoto!.isNotEmpty
                      ? NetworkImage(scorer.playerPhoto!)
                      : null,
                  child:
                      scorer.playerPhoto == null || scorer.playerPhoto!.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.white54,
                        )
                      : null,
                ),
              ),

              // Player Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  scorer.playerName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Team Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  scorer.teamName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    color: const Color(0xFF00ff88),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Goals Count
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: rankColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: rankColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.sports_soccer,
                      size: 18,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${scorer.goals}',
                      style: GoogleFonts.cairo(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'هدف',
                      style: GoogleFonts.cairo(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
