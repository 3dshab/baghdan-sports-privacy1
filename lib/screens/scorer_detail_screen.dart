import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/scorer_model.dart';

/// صفحة عرض تفاصيل الهداف بشاشة كاملة
class ScorerDetailScreen extends StatefulWidget {
  final ScorerModel scorer;
  final int rank;

  const ScorerDetailScreen({
    super.key,
    required this.scorer,
    required this.rank,
  });

  @override
  State<ScorerDetailScreen> createState() => _ScorerDetailScreenState();
}

class _ScorerDetailScreenState extends State<ScorerDetailScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051622),
      appBar: AppBar(
        title: Text(
          'بطاقة الهداف',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1BA098),
        elevation: 0,
        actions: [
          IconButton(
            icon: _isSharing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.share),
            onPressed: _isSharing ? null : _shareCard,
            tooltip: 'مشاركة',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Screenshot(
              controller: _screenshotController,
              child: _buildScorerCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScorerCard() {
    Color rankColor;
    String rankEmoji;

    if (widget.rank == 1) {
      rankColor = const Color(0xFFFFD700); // Gold
      rankEmoji = '🥇';
    } else if (widget.rank == 2) {
      rankColor = const Color(0xFFC0C0C0); // Silver
      rankEmoji = '🥈';
    } else if (widget.rank == 3) {
      rankColor = const Color(0xFFCD7F32); // Bronze
      rankEmoji = '🥉';
    } else {
      rankColor = const Color(0xFF00ff88);
      rankEmoji = '';
    }

    // Get screen width and calculate card width
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 450 ? 350.0 : screenWidth - 40;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            rankColor.withValues(alpha: 0.2),
            const Color(0xFF0A2E36),
            const Color(0xFF051622),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: rankColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: rankColor.withValues(alpha: 0.5),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: rankColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'بطولة كأس بعدان 18',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF00ff88),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'قائمة الهدافين',
                  style: GoogleFonts.cairo(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Rank Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: rankColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: rankColor.withValues(alpha: 0.6),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (rankEmoji.isNotEmpty) ...[
                  Text(rankEmoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                ],
                Text(
                  'المركز #${widget.rank}',
                  style: GoogleFonts.cairo(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Player Photo
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: rankColor, width: 3),
              boxShadow: [
                BoxShadow(
                  color: rankColor.withValues(alpha: 0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white10,
              backgroundImage:
                  widget.scorer.playerPhoto != null &&
                      widget.scorer.playerPhoto!.isNotEmpty
                  ? NetworkImage(widget.scorer.playerPhoto!)
                  : null,
              child:
                  widget.scorer.playerPhoto == null ||
                      widget.scorer.playerPhoto!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 60,
                      color: rankColor.withValues(alpha: 0.5),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 20),

          // Player Name
          Text(
            widget.scorer.playerName,
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Team Name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1BA098).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFF1BA098), width: 2),
            ),
            child: Text(
              widget.scorer.teamName,
              style: GoogleFonts.cairo(
                fontSize: 17,
                color: const Color(0xFF00ff88),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Goals Count
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  rankColor.withValues(alpha: 0.3),
                  rankColor.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: rankColor, width: 2),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.sports_soccer,
                  size: 40,
                  color: Color(0xFF00ff88),
                ),
                const SizedBox(height: 10),
                Text(
                  '${widget.scorer.goals}',
                  style: GoogleFonts.cairo(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: rankColor,
                    shadows: [
                      Shadow(color: rankColor.withValues(alpha: 0.5), blurRadius: 20),
                    ],
                  ),
                ),
                Text(
                  'هدف',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Footer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: Color(0xFFFFD700),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'موسم 2024-2025',
                  style: GoogleFonts.cairo(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareCard() async {
    if (!mounted) return;
    
    setState(() {
      _isSharing = true;
    });

    try {
      // Capture screenshot with higher quality
      final image = await _screenshotController.capture(pixelRatio: 2.0);

      if (image == null) {
        throw Exception('فشل في التقاط الصورة');
      }

      // Save to temporary directory
      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/scorer_${widget.scorer.id ?? 'card'}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      // Share the image
      if (!mounted) return;
      
      // Get the share button position for iPad
      final box = context.findRenderObject() as RenderBox?;
      final sharePositionOrigin = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : null;
      
      final result = await Share.shareXFiles(
        [XFile(imagePath)],
        text:
            'الهداف ${widget.scorer.playerName} - ${widget.scorer.goals} هدف\n'
            'فريق ${widget.scorer.teamName}\n'
            'بطولة كأس بعدان 18 ⚽',
        sharePositionOrigin: sharePositionOrigin,
      );

      // Show success message
      if (!mounted) return;
      
      if (result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تمت المشاركة بنجاح', style: GoogleFonts.cairo()),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء المشاركة: $e',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }
}
