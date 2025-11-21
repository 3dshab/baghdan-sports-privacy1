import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/permission_service.dart';

class PermissionDialog extends StatelessWidget {
  final VoidCallback onPermissionGranted;

  const PermissionDialog({
    super.key,
    required this.onPermissionGranted,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0a4d68),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          const Icon(
            Icons.video_library,
            color: Color(0xFF00ff88),
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'الوصول إلى الملفات',
              style: GoogleFonts.cairo(
                color: const Color(0xFF00ff88),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'يحتاج التطبيق إلى إذن للوصول إلى الملفات والفيديوهات لتتمكن من:',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _buildPermissionItem(
            icon: Icons.upload_file,
            text: 'رفع فيديوهات ملخصات المباريات',
          ),
          const SizedBox(height: 12),
          _buildPermissionItem(
            icon: Icons.sports_soccer,
            text: 'رفع فيديوهات الأهداف',
          ),
          const SizedBox(height: 12),
          _buildPermissionItem(
            icon: Icons.image,
            text: 'إضافة صور وشعارات الفرق',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF051622),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFF00ff88),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'لن يتم الوصول إلى ملفاتك إلا عند اختيارك لها',
                    style: GoogleFonts.cairo(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'لاحقاً',
            style: GoogleFonts.cairo(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            final granted = await PermissionService.requestPermissionsWithDialog();
            if (granted) {
              onPermissionGranted();
            } else {
              // Show message that permissions are needed
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'يمكنك منح الأذونات لاحقاً من إعدادات التطبيق',
                      style: GoogleFonts.cairo(),
                    ),
                    backgroundColor: Colors.orange,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00ff88),
            foregroundColor: const Color(0xFF051622),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'السماح',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF051622),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF00ff88),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
