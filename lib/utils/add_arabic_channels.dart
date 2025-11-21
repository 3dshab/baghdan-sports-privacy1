// قنوات عربية ويمنية مجانية

import 'package:flutter/material.dart';
import '../models/live_channel_model.dart';
import '../services/firebase_service.dart';

/// إضافة قنوات إخبارية عربية وقنوات يمنية
Future<void> addArabicChannels(BuildContext context) async {
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
    final channels = [
      // القنوات اليمنية
      LiveChannelModel(
        name: 'قناة اليمن اليوم',
        description: 'البث المباشر لقناة اليمن اليوم',
        url: 'https://stream.aljazeera.net/live/aljazeera/aljazeera.m3u8',
        iconName: 'live_tv',
        colorHex: 'FF0000',
        order: 1,
        isActive: true,
      ),
      LiveChannelModel(
        name: 'يمن شباب',
        description: 'قناة يمن شباب الفضائية',
        url: 'https://stream.aljazeera.net/live/aljazeera/aljazeera.m3u8',
        iconName: 'live_tv',
        colorHex: '00FF00',
        order: 2,
        isActive: true,
      ),
      LiveChannelModel(
        name: 'السعيدة',
        description: 'قناة السعيدة الفضائية',
        url: 'https://stream.aljazeera.net/live/aljazeera/aljazeera.m3u8',
        iconName: 'live_tv',
        colorHex: '0000FF',
        order: 3,
        isActive: true,
      ),

      // القنوات الإخبارية العربية
      LiveChannelModel(
        name: 'الجزيرة مباشر',
        description: 'قناة الجزيرة الإخبارية',
        url: 'https://live-hls-web-aja.getaj.net/AJA/index.m3u8',
        iconName: 'live_tv',
        colorHex: 'F39C12',
        order: 4,
        isActive: true,
      ),
      LiveChannelModel(
        name: 'العربية',
        description: 'قناة العربية الإخبارية',
        url: 'https://stream.alarabiya.net/alarabiya/alarabiapublish/alarabiya_ar.smil/playlist.m3u8',
        iconName: 'live_tv',
        colorHex: '1E88E5',
        order: 5,
        isActive: true,
      ),
      LiveChannelModel(
        name: 'سكاي نيوز عربية',
        description: 'قناة سكاي نيوز عربية',
        url: 'https://stream.skynewsarabia.com/hls/sna.m3u8',
        iconName: 'live_tv',
        colorHex: 'E53935',
        order: 6,
        isActive: true,
      ),
      LiveChannelModel(
        name: 'BBC عربي',
        description: 'قناة BBC الإخبارية بالعربية',
        url: 'https://vs-cmaf-pushb-ww-live.akamaized.net/x=3/i=urn:bbc:pips:service:bbc_arabic_tv/pc_hd_abr_v2.mpd',
        iconName: 'live_tv',
        colorHex: 'BB1919',
        order: 7,
        isActive: true,
      ),
      LiveChannelModel(
        name: 'الحدث',
        description: 'قناة الحدث الإخبارية',
        url: 'https://stream.alhadath.sa/live/alhadath/alhadath.m3u8',
        iconName: 'live_tv',
        colorHex: '00A651',
        order: 8,
        isActive: true,
      ),
      LiveChannelModel(
        name: 'الغد',
        description: 'قناة الغد الإخبارية',
        url: 'https://stream.alghad.tv/live/alghad/alghad.m3u8',
        iconName: 'live_tv',
        colorHex: '9C27B0',
        order: 9,
        isActive: true,
      ),
      LiveChannelModel(
        name: 'RT Arabic',
        description: 'قناة روسيا اليوم بالعربية',
        url: 'https://rt-arb.rttv.com/live/rtarab/playlist.m3u8',
        iconName: 'live_tv',
        colorHex: '0288D1',
        order: 10,
        isActive: true,
      ),
      LiveChannelModel(
        name: 'الميادين',
        description: 'قناة الميادين الإخبارية',
        url: 'https://stream.almayadeen.tv/live/almayadeen/almayadeen.m3u8',
        iconName: 'live_tv',
        colorHex: 'D32F2F',
        order: 11,
        isActive: true,
      ),
      LiveChannelModel(
        name: 'الحرة',
        description: 'قناة الحرة الإخبارية',
        url: 'https://stream.alhurra.com/live/alhurra/alhurra.m3u8',
        iconName: 'live_tv',
        colorHex: '1976D2',
        order: 12,
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

/// ملاحظات مهمة:
/// 
/// 1. الروابط أعلاه هي روابط تقريبية، قد تحتاج للتحديث
/// 2. بعض القنوات قد تتطلب VPN للوصول
/// 3. بعض الروابط قد لا تعمل على iOS Simulator
/// 4. للحصول على أفضل النتائج، جرب على جهاز حقيقي
/// 
/// كيفية الحصول على روابط القنوات الحقيقية:
/// 
/// 1. من مواقع IPTV:
///    - https://github.com/iptv-org/iptv
///    - https://github.com/Free-TV/IPTV
/// 
/// 2. من المواقع الرسمية للقنوات:
///    - ابحث عن "live stream" في موقع القناة
///    - افحص الشبكة في Developer Tools
///    - ابحث عن ملفات .m3u8
/// 
/// 3. من تطبيقات IPTV:
///    - استخدم تطبيقات مثل VLC أو Kodi
///    - استخرج الروابط من قوائم M3U
/// 
/// مثال على كيفية إيجاد رابط قناة:
/// 
/// 1. افتح موقع القناة الرسمي
/// 2. اضغط F12 لفتح Developer Tools
/// 3. اذهب إلى تبويب Network
/// 4. شغل البث المباشر
/// 5. ابحث عن ملفات .m3u8 أو .mpd
/// 6. انسخ الرابط واستخدمه
