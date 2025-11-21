import '../models/live_channel_model.dart';
import '../services/firebase_service.dart';

/// دالة لإضافة بيانات تجريبية للقنوات المباشرة
/// يمكن استدعاء هذه الدالة مرة واحدة لإضافة القنوات الافتراضية
Future<void> seedLiveChannels() async {
  final firebaseService = FirebaseService();

  final channels = [
    LiveChannelModel(
      name: 'قناة البطولة الرسمية',
      description: 'البث المباشر لجميع مباريات البطولة',
      url: 'https://www.youtube.com/@baghdan18', // استبدل بالرابط الحقيقي
      iconName: 'live_tv',
      colorHex: '7D1E7D',
      order: 1,
      isActive: true,
    ),
    LiveChannelModel(
      name: 'قناة الأهداف',
      description: 'أهداف المباريات والملخصات',
      url: 'https://www.youtube.com', // استبدل بالرابط الحقيقي
      iconName: 'sports_soccer',
      colorHex: '1BA098',
      order: 2,
      isActive: true,
    ),
    LiveChannelModel(
      name: 'قناة التحليلات',
      description: 'تحليلات فنية وتكتيكية للمباريات',
      url: 'https://www.youtube.com', // استبدل بالرابط الحقيقي
      iconName: 'analytics',
      colorHex: '8B7E3A',
      order: 3,
      isActive: true,
    ),
    LiveChannelModel(
      name: 'قناة المقابلات',
      description: 'مقابلات حصرية مع اللاعبين والمدربين',
      url: 'https://www.youtube.com', // استبدل بالرابط الحقيقي
      iconName: 'mic',
      colorHex: '1E5A7D',
      order: 4,
      isActive: true,
    ),
  ];

  try {
    for (var channel in channels) {
      await firebaseService.addLiveChannel(channel);
    }
    print('✅ تم إضافة ${channels.length} قناة بنجاح');
  } catch (e) {
    print('❌ خطأ في إضافة القنوات: $e');
  }
}

/// ملاحظات للاستخدام:
/// 
/// 1. لإضافة القنوات الافتراضية، قم باستدعاء هذه الدالة من أي مكان في التطبيق
///    مثلاً من main.dart أو من شاشة الإعدادات
/// 
/// 2. مثال على الاستخدام:
///    ```dart
///    import 'utils/seed_live_channels.dart';
///    
///    // في أي مكان تريد إضافة القنوات
///    await seedLiveChannels();
///    ```
/// 
/// 3. لإضافة قناة جديدة يدوياً:
///    ```dart
///    final firebaseService = FirebaseService();
///    final newChannel = LiveChannelModel(
///      name: 'اسم القناة',
///      description: 'وصف القناة',
///      url: 'رابط الفيديو',
///      iconName: 'live_tv', // أو أي أيقونة أخرى
///      colorHex: '1BA098', // اللون بدون #
///      order: 5,
///      isActive: true,
///    );
///    await firebaseService.addLiveChannel(newChannel);
///    ```
/// 
/// 4. الأيقونات المتاحة:
///    - live_tv
///    - sports_soccer
///    - analytics
///    - mic
///    - video_library
///    - play_circle
/// 
/// 5. أمثلة على الألوان (بدون #):
///    - 1BA098 (أخضر فيروزي)
///    - 7D1E7D (بنفسجي)
///    - 8B7E3A (ذهبي)
///    - 1E5A7D (أزرق)
///    - FF5722 (برتقالي)
///    - 4CAF50 (أخضر)
