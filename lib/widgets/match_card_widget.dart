import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/match_summary_model.dart';

/// Widget احترافي لعرض كارت المباراة
class MatchCardWidget extends StatelessWidget {
  final MatchSummaryModel match;
  final VoidCallback onTap;

  const MatchCardWidget({
    super.key,
    required this.match,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMatchCompleted = match.matchDate.isBefore(DateTime.now());
    final bool hasVideo = match.summaryVideoUrl != null && match.summaryVideoUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1BA098).withValues(alpha: 0.8),
              const Color(0xFF0A2E36),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00ff88).withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CustomPaint(
                  painter: _MatchCardPatternPainter(),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date and Status
                  _buildHeader(isMatchCompleted, hasVideo),
                  
                  const SizedBox(height: 10),
                  
                  // Teams and Score
                  Expanded(
                    child: _buildTeamsSection(isMatchCompleted),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Goals Summary
                  if (match.goals.isNotEmpty && isMatchCompleted)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _buildGoalsSummary(),
                    ),
                  
                  // Watch Button
                  if (hasVideo && isMatchCompleted)
                    _buildWatchButton(),
                ],
              ),
            ),

            // Live indicator
            if (!isMatchCompleted)
              Positioned(
                top: 12,
                left: 12,
                child: _buildLiveIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  /// Build header with date and status
  Widget _buildHeader(bool isCompleted, bool hasVideo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Date
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 14,
                color: Color(0xFF00ff88),
              ),
              const SizedBox(width: 6),
              Text(
                DateFormat('dd/MM/yyyy', 'ar').format(match.matchDate),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        // Video indicator
        if (hasVideo && isCompleted)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              size: 16,
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  /// Build teams section with scores
  Widget _buildTeamsSection(bool isCompleted) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Home Team
        Expanded(
          child: _buildTeamInfo(
            match.homeTeam,
            match.homeScore,
            isCompleted,
            isHome: true,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // VS or Score
        _buildScoreDivider(isCompleted),
        
        const SizedBox(height: 8),
        
        // Away Team
        Expanded(
          child: _buildTeamInfo(
            match.awayTeam,
            match.awayScore,
            isCompleted,
            isHome: false,
          ),
        ),
      ],
    );
  }

  /// Build team info
  Widget _buildTeamInfo(String teamName, int score, bool isCompleted, {required bool isHome}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Team Icon
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF00ff88).withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.shield,
            color: Color(0xFF00ff88),
            size: 24,
          ),
        ),
        
        const SizedBox(height: 6),
        
        // Team Name
        Flexible(
          child: Text(
            teamName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // Score
        if (isCompleted)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              score.toString(),
              style: const TextStyle(
                color: Color(0xFF00ff88),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  /// Build score divider
  Widget _buildScoreDivider(bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isCompleted ? '-' : 'VS',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Build goals summary
  Widget _buildGoalsSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sports_soccer,
            size: 14,
            color: Color(0xFF00ff88),
          ),
          const SizedBox(width: 4),
          Text(
            '${match.goals.length} ${match.goals.length == 1 ? 'هدف' : 'أهداف'}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  /// Build watch button
  Widget _buildWatchButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00ff88), Color(0xFF1BA098)],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00ff88).withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.play_circle_filled,
            color: Colors.white,
            size: 16,
          ),
          SizedBox(width: 6),
          Text(
            'مشاهدة الملخص',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Build live indicator
  Widget _buildLiveIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: Colors.white,
          ),
          SizedBox(width: 6),
          Text(
            'قريباً',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for card background pattern
class _MatchCardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw diagonal lines pattern
    for (double i = -size.height; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
