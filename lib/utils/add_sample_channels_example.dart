// مثال على كيفية إضافة القنوات المباشرة
// يمكنك استدعاء هذه الدالة من أي مكان في التطبيق

import 'package:flutter/material.dart';
import '../models/live_channel_model.dart';
import '../services/firebase_service.dart';

/// مثال على إضافة قناة واحدة
Future<void> addSingleChannel() async {
  final firebaseService = FirebaseService();
  
  final channel = LiveChannelModel(
    name: 'قناة البطولة الرسمية',
    description: 'البث المباشر لجميع مباريات البطولة',
    // استبدل هذا الرابط برابط الفيديو الحقيقي
    // يمكن أن يكون:
    // - رابط HLS: https://example.com/stream.m3u8
    // - رابط MP4: https://example.com/video.mp4
    // - رابط YouTube: https://www.youtube.com/watch?v=VIDEO_ID
    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8', // رابط تجريبي
    iconName: 'live_tv',
    colorHex: '7D1E7D',
    order: 1,
    isActive: true,
  );

  try {
    await firebaseService.addLiveChannel(channel);
    debugPrint('✅ تم إضافة القناة بنجاح');
  } catch (e) {
    debugPrint('❌ خطأ في إضافة القناة: $e');
  }
}

/// مثال على إضافة عدة قنوات
Future<void> addMultipleChannels() async {
  final firebaseService = FirebaseService();
  
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
  ];

  try {
    for (var channel in channels) {
      await firebaseService.addLiveChannel(channel);
      debugPrint('✅ تم إضافة: ${channel.name}');
    }
    debugPrint('🎉 تم إضافة جميع القنوات بنجاح');
  } catch (e) {
    debugPrint('❌ خطأ في إضافة القنوات: $e');
  }
}

/// كيفية الاستخدام في التطبيق:
/// 
/// 1. من main.dart:
/// ```dart
/// import 'utils/add_sample_channels_example.dart';
/// 
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp();
///   
///   // قم بإلغاء التعليق لإضافة القنوات (مرة واحدة فقط)
///   // await addMultipleChannels();
///   
///   runApp(MyApp());
/// }
/// ```
/// 
/// 2. من زر في واجهة المستخدم:
/// ```dart
/// ElevatedButton(
///   onPressed: () async {
///     await addMultipleChannels();
///     ScaffoldMessenger.of(context).showSnackBar(
///       SnackBar(content: Text('تم إضافة القنوات')),
///     );
///   },
///   child: Text('إضافة القنوات التجريبية'),
/// )
/// ```
/// 
/// 3. روابط فيديو تجريبية للاختبار:
/// 
/// HLS Streams:
/// - https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8
/// - https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8
/// 
/// MP4 Files:
/// - https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4
/// - https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4
/// - https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4
/// 
/// ملاحظة: استبدل هذه الروابط بروابط الفيديو الحقيقية الخاصة بك
