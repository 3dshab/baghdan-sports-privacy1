// استخدم هذا الملف لإضافة القنوات بسرعة

import 'package:flutter/material.dart';
import '../models/live_channel_model.dart';
import '../services/firebase_service.dart';

/// زر سريع لإضافة القنوات التجريبية
class QuickAddChannelsButton extends StatelessWidget {
  const QuickAddChannelsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await _addChannels(context);
      },
      icon: const Icon(Icons.add),
      label: const Text('إضافة قنوات تجريبية'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1BA098),
        foregroundColor: Colors.white,
      ),
    );
  }

  Future<void> _addChannels(BuildContext context) async {
    final firebaseService = FirebaseService();
    
    // عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF1BA098)),
      ),
    );

    try {
      // القنوات التجريبية مع روابط فيديو حقيقية
      final channels = [
        LiveChannelModel(
          name: 'قناة البطولة الرسمية',
          description: 'البث المباشر لجميع مباريات البطولة',
          url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
          iconName: 'live_tv',
          colorHex: '7D1E7D',
          order: 1,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'قناة الأهداف',
          description: 'أهداف المباريات والملخصات',
          url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          iconName: 'sports_soccer',
          colorHex: '1BA098',
          order: 2,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'قناة التحليلات',
          description: 'تحليلات فنية وتكتيكية للمباريات',
          url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          iconName: 'analytics',
          colorHex: '8B7E3A',
          order: 3,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'قناة المقابلات',
          description: 'مقابلات حصرية مع اللاعبين والمدربين',
          url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          iconName: 'mic',
          colorHex: '1E5A7D',
          order: 4,
          isActive: true,
        ),
      ];

      // إضافة القنوات
      for (var channel in channels) {
        await firebaseService.addLiveChannel(channel);
      }

      // إغلاق مؤشر التحميل
      if (context.mounted) {
        Navigator.pop(context);
        
        // عرض رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ تم إضافة ${channels.length} قناة بنجاح'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // إغلاق مؤشر التحميل
      if (context.mounted) {
        Navigator.pop(context);
        
        // عرض رسالة خطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ خطأ: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}

/// كيفية الاستخدام:
/// 
/// 1. أضف هذا الزر في أي شاشة (مثلاً في شاشة القنوات):
/// 
/// ```dart
/// import 'utils/quick_add_channels.dart';
/// 
/// // في أي مكان في الواجهة
/// QuickAddChannelsButton()
/// ```
/// 
/// 2. أو استدعِ الدالة مباشرة:
/// 
/// ```dart
/// import 'utils/quick_add_channels.dart';
/// 
/// ElevatedButton(
///   onPressed: () async {
///     await _addChannels(context);
///   },
///   child: Text('إضافة القنوات'),
/// )
/// ```
