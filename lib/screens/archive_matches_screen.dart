import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../models/archive_tournament_model.dart';
import 'tournament_video_player_screen.dart';

/// صفحة أرشيف البطولة - تجلب البيانات من baghdan_admin
class ArchiveMatchesScreen extends StatefulWidget {
  const ArchiveMatchesScreen({super.key});

  @override
  State<ArchiveMatchesScreen> createState() => _ArchiveMatchesScreenState();
}

class _ArchiveMatchesScreenState extends State<ArchiveMatchesScreen> {
  final AuthService _authService = AuthService();
  bool _isGuest = false;
  bool _checkingRole = true;

  @override
  void initState() {
    super.initState();
    _checkGuest();
  }

  Future<void> _checkGuest() async {
    final isGuest = await _authService.isCurrentUserGuest();
    if (mounted) {
      setState(() {
        _isGuest = isGuest;
        _checkingRole = false;
      });
    }
  }

  /// جلب البيانات من أرشيف البطولة في Firebase
  /// يجلب البيانات من مجموعة 'archives' المخصصة للبطولات السابقة
  Stream<List<ArchiveTournamentModel>> _getArchiveTournaments() {
    return FirebaseFirestore.instance
        .collection('archives')
        .orderBy('order', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map<ArchiveTournamentModel>(
                (doc) => ArchiveTournamentModel.fromFirestore(doc),
              )
              .toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051622),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1BA098),
        elevation: 0,
        title: Text(
          'أرشيف البطولة',
          style: GoogleFonts.cairo(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _checkingRole
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00ff88)),
            )
          : _isGuest
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'وضع الزائر لا يسمح بمشاهدة أرشيف البطولة.',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'قم بتسجيل الدخول أو إنشاء حساب جديد للوصول إلى الأرشيف.',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : StreamBuilder<List<ArchiveTournamentModel>>(
              stream: _getArchiveTournaments(),
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
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'حدث خطأ: ${snapshot.error}',
                          style: GoogleFonts.cairo(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.archive_outlined,
                          size: 80,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد بيانات في الأرشيف',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final tournaments = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tournaments.length,
                  itemBuilder: (context, index) {
                    final tournament = tournaments[index];
                    return _buildTournamentCard(tournament);
                  },
                );
              },
            ),
    );
  }

  /// بناء بطاقة البطولة
  Widget _buildTournamentCard(ArchiveTournamentModel tournament) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1BA098), const Color(0xFF0D7C72)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1BA098).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _playVideo(tournament),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // أيقونة التشغيل
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                const SizedBox(width: 16),
                // معلومات البطولة
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tournament.title,
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tournament.description,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.white60,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            tournament.year,
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // أيقونة السهم
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// تشغيل الفيديو
  void _playVideo(ArchiveTournamentModel tournament) {
    if (tournament.videoUrl == null || tournament.videoUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'لا يوجد فيديو متاح لهذه البطولة',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TournamentVideoPlayerScreen(tournament: tournament),
      ),
    );
  }
}
