import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'matches_screen.dart';
import 'scorers_screen.dart';
import 'teams_screen.dart';
import 'match_goals_screen.dart';
import 'live_channels_screen.dart';
import 'archive_matches_screen.dart';

/// الصفحة الرئيسية - Dashboard
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051622),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildDashboardCard(
                context,
                title: 'المباريات',
                icon: Icons.sports_soccer,
                color: const Color(0xFF1E5A7D),
                iconBgColor: const Color(0xFF0E3A5D),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MatchesScreen(),
                    ),
                  );
                },
              ),
              _buildDashboardCard(
                context,
                title: 'الهدافين',
                icon: Icons.emoji_events,
                color: const Color(0xFFFFC107),
                iconBgColor: const Color(0xFF827717),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScorersScreen(),
                    ),
                  );
                },
              ),
              _buildDashboardCard(
                context,
                title: 'الفرق',
                icon: Icons.groups,
                color: const Color(0xFF1E5A7D),
                iconBgColor: const Color(0xFF0E3A5D),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeamsScreen(),
                    ),
                  );
                },
              ),
              _buildDashboardCard(
                context,
                title: 'أهداف المباريات',
                icon: Icons.sports_soccer,
                color: const Color(0xFFE91E63),
                iconBgColor: const Color(0xFF880E4F),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MatchGoalsScreen(),
                    ),
                  );
                },
              ),
              _buildDashboardCard(
                context,
                title: 'ملخص المباريات',
                icon: Icons.video_library,
                color: const Color(0xFF9C27B0),
                iconBgColor: const Color(0xFF4A148C),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MatchesScreen(),
                    ),
                  );
                },
              ),
              _buildDashboardCard(
                context,
                title: 'قنوات مباشرة',
                icon: Icons.live_tv,
                color: const Color(0xFFFF5722),
                iconBgColor: const Color(0xFF880E4F),
                onTap: () {
                  _handleRestrictedNavigation(
                    context,
                    const LiveChannelsScreen(),
                  );
                },
              ),
              _buildDashboardCard(
                context,
                title: 'أرشيف البطولة',
                icon: Icons.archive,
                color: const Color(0xFF607D8B),
                iconBgColor: const Color(0xFF37474F),
                onTap: () {
                  _handleRestrictedNavigation(
                    context,
                    const ArchiveMatchesScreen(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRestrictedNavigation(BuildContext context, Widget screen) async {
    final authService = AuthService();
    final isGuest = await authService.isCurrentUserGuest();

    if (isGuest) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'تصفح محدود للزائر',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'القنوات المباشرة وأرشيف البطولة متاحة فقط للمستخدمين المسجَّلين. يمكنك إنشاء حساب أو تسجيل الدخول للوصول إلى هذه الميزة.',
            style: GoogleFonts.cairo(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إغلاق', style: GoogleFonts.cairo()),
            ),
          ],
        ),
      );
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
