import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/permission_service.dart';

/// شاشة طلب الأذونات عند أول تشغيل للتطبيق
class PermissionsRequestScreen extends StatefulWidget {
  final VoidCallback onPermissionsHandled;

  const PermissionsRequestScreen({
    super.key,
    required this.onPermissionsHandled,
  });

  @override
  State<PermissionsRequestScreen> createState() => _PermissionsRequestScreenState();
}

class _PermissionsRequestScreenState extends State<PermissionsRequestScreen> {
  bool _isRequesting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051622),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // App Logo/Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00ff88),
                      const Color(0xFF1BA098),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00ff88).withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.sports_soccer,
                  size: 50,
                  color: Color(0xFF051622),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'مرحباً بك في',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'بطولة كأس بعدان 18',
                style: GoogleFonts.cairo(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00ff88),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Permissions Info Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0a4d68).withValues(alpha: 0.6),
                      const Color(0xFF051622).withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF00ff88).withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.security,
                      size: 40,
                      color: const Color(0xFF00ff88),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'الأذونات المطلوبة',
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00ff88),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'للحصول على أفضل تجربة، يحتاج التطبيق إلى الأذونات التالية:',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Permission Items
                    _buildPermissionItem(
                      icon: Icons.photo_library,
                      title: 'الوصول إلى الصور',
                      description: 'لرفع صور اللاعبين والفرق',
                    ),
                    const SizedBox(height: 12),
                    _buildPermissionItem(
                      icon: Icons.video_library,
                      title: 'الوصول إلى الفيديوهات',
                      description: 'لرفع فيديوهات الأهداف والملخصات',
                    ),
                    const SizedBox(height: 12),
                    _buildPermissionItem(
                      icon: Icons.camera_alt,
                      title: 'الكاميرا',
                      description: 'لالتقاط صور مباشرة',
                    ),
                    const SizedBox(height: 12),
                    _buildPermissionItem(
                      icon: Icons.notifications,
                      title: 'الإشعارات',
                      description: 'لتلقي تحديثات المباريات',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Info Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1BA098).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF1BA098).withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(0xFF00ff88),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'يمكنك تغيير الأذونات لاحقاً من إعدادات الجهاز',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Column(
                children: [
                  // Grant Permissions Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isRequesting ? null : _requestPermissions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00ff88),
                        foregroundColor: const Color(0xFF051622),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0xFF00ff88).withValues(alpha: 0.5),
                      ),
                      child: _isRequesting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Color(0xFF051622),
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'منح الأذونات',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Skip Button
                  TextButton(
                    onPressed: _isRequesting ? null : _skipPermissions,
                    child: Text(
                      'تخطي الآن',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: Colors.white54,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF00ff88).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF00ff88),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _isRequesting = true;
    });

    try {
      final results = await PermissionService.requestAllPermissions();
      
      // Check if at least storage permissions are granted
      final hasStorageAccess = results['storage'] == true || 
                               results['photos'] == true || 
                               results['videos'] == true;

      if (mounted) {
        if (hasStorageAccess) {
          // Success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم منح الأذونات بنجاح',
                style: GoogleFonts.cairo(),
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          // Warning message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'بعض الميزات قد لا تعمل بدون الأذونات',
                style: GoogleFonts.cairo(),
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        }

        // Continue to app
        widget.onPermissionsHandled();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'حدث خطأ أثناء طلب الأذونات',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }

  Future<void> _skipPermissions() async {
    // Mark as requested even if skipped
    await PermissionService.markPermissionsAsRequested();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'يمكنك منح الأذونات لاحقاً من الإعدادات',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
      
      widget.onPermissionsHandled();
    }
  }
}
