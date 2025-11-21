import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/live_channel_model.dart';
import '../services/firebase_service.dart';
import '../services/auth_service.dart';
import 'channel_player_screen.dart';

/// صفحة القنوات المباشرة
class LiveChannelsScreen extends StatefulWidget {
  const LiveChannelsScreen({super.key});

  @override
  State<LiveChannelsScreen> createState() => _LiveChannelsScreenState();
}

class _LiveChannelsScreenState extends State<LiveChannelsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
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

  Future<void> _performAddYemenChannels(List<LiveChannelModel> channels) async {
    // عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF1BA098)),
      ),
    );

    try {
      // الحصول على القنوات الموجودة
      final existingChannels = await _firebaseService.getLiveChannels().first;
      final existingNames = existingChannels
          .map((c) => c.name.toLowerCase())
          .toSet();

      // إضافة القنوات غير الموجودة فقط
      int addedCount = 0;
      for (var channel in channels) {
        if (!existingNames.contains(channel.name.toLowerCase())) {
          await _firebaseService.addLiveChannel(channel);
          addedCount++;
        }
      }

      // إغلاق مؤشر التحميل
      if (mounted) {
        Navigator.of(context).pop();

        // عرض رسالة نجاح
        final skippedCount = channels.length - addedCount;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              addedCount > 0
                  ? '🇾🇪 تم إضافة $addedCount قناة يمنية${skippedCount > 0 ? ' (تم تخطي $skippedCount قناة موجودة مسبقاً)' : ''}\nملاحظة: قد تحتاج تحديث الروابط'
                  : '⚠️ جميع القنوات موجودة مسبقاً',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: addedCount > 0 ? Colors.orange : Colors.blue,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      // إغلاق مؤشر التحميل
      if (mounted) {
        Navigator.of(context).pop();

        // عرض رسالة خطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ خطأ: $e', style: GoogleFonts.cairo()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _addYemenChannels() async {
    // عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF1BA098)),
      ),
    );

    try {
      // القنوات اليمنية (روابط تقريبية - قد تحتاج تحديث)
      final channels = [
        LiveChannelModel(
          name: 'قناة اليمن اليوم',
          description: 'البث المباشر لقناة اليمن اليوم',
          url: 'https://stream.yementoday.tv/live/yementoday.m3u8',
          iconName: 'live_tv',
          colorHex: 'FF0000',
          order: 301,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'يمن شباب',
          description: 'قناة يمن شباب الفضائية',
          url: 'https://stream.yemenshabab.net/live/shabab.m3u8',
          iconName: 'live_tv',
          colorHex: '00FF00',
          order: 302,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'قناة السعيدة',
          description: 'قناة السعيدة الفضائية',
          url: 'https://stream.alsaeedah.tv/live/saeedah.m3u8',
          iconName: 'live_tv',
          colorHex: '0000FF',
          order: 303,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'قناة بلقيس',
          description: 'قناة بلقيس الفضائية',
          url: 'https://stream.belqeestv.net/live/belqees.m3u8',
          iconName: 'live_tv',
          colorHex: 'FFD700',
          order: 304,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'قناة عدن',
          description: 'قناة عدن الفضائية',
          url: 'https://stream.adentv.ye/live/aden.m3u8',
          iconName: 'live_tv',
          colorHex: '00A651',
          order: 305,
          isActive: true,
        ),
      ];

      // إغلاق مؤشر التحميل
      if (mounted) {
        Navigator.pop(context);

        // عرض رسالة تحذيرية
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              '⚠️ تنبيه مهم',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'الروابط المضافة تقريبية وقد لا تعمل.\n\n'
              'للحصول على الروابط الحقيقية:\n\n'
              '1️⃣ زر المواقع الرسمية للقنوات\n'
              '2️⃣ استخدم Developer Tools (F12)\n'
              '3️⃣ ابحث عن ملفات .m3u8\n'
              '4️⃣ حدّث الروابط في Firebase\n\n'
              'هل تريد إضافة القنوات بالروابط التقريبية؟',
              style: GoogleFonts.cairo(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('إلغاء', style: GoogleFonts.cairo()),
              ),
              ElevatedButton(
                onPressed: () {
                  // إغلاق dialog التحذير
                  Navigator.of(context).pop();

                  // استدعاء دالة منفصلة للإضافة
                  _performAddYemenChannels(channels);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1BA098),
                ),
                child: Text('إضافة', style: GoogleFonts.cairo()),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // إغلاق مؤشر التحميل
      if (mounted) {
        Navigator.pop(context);

        // عرض رسالة خطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ خطأ: $e', style: GoogleFonts.cairo()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _addSportsChannels() async {
    // عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF1BA098)),
      ),
    );

    try {
      // الحصول على القنوات الموجودة
      final existingChannels = await _firebaseService.getLiveChannels().first;
      final existingNames = existingChannels
          .map((c) => c.name.toLowerCase())
          .toSet();

      // القنوات الرياضية المجانية
      final channels = [
        LiveChannelModel(
          name: 'beIN SPORTS XTRA',
          description: 'قناة beIN الرياضية المجانية',
          url: 'https://siloh.pluto.tv/lilo/production/bein/master.m3u8',
          iconName: 'sports_soccer',
          colorHex: 'E74C3C',
          order: 201,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'Red Bull TV',
          description: 'قناة Red Bull للرياضات الإكستريم',
          url:
              'https://rbmn-live.akamaized.net/hls/live/590964/BoRB-AT/master.m3u8',
          iconName: 'sports_soccer',
          colorHex: 'DC0000',
          order: 202,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'Dubai Sports',
          description: 'قناة دبي الرياضية',
          url:
              'https://dmitnthvll.cdn.mangomolo.com/dubaisports/smil:dubaisports.smil/playlist.m3u8',
          iconName: 'sports_soccer',
          colorHex: '0066CC',
          order: 203,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'Dubai Racing',
          description: 'قناة دبي للسباقات',
          url:
              'https://dmitwlvvll.cdn.mangomolo.com/dubairacing/smil:dubairacing.smil/playlist.m3u8',
          iconName: 'sports_soccer',
          colorHex: '00A651',
          order: 204,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'Olympic Channel',
          description: 'القناة الأولمبية الرسمية',
          url:
              'https://ott-channels.akamaized.net/out/v1/c685bf3b0c0a4b6cb88e8e8e8c8e8e8e/index.m3u8',
          iconName: 'sports_soccer',
          colorHex: 'FFD700',
          order: 205,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'FIFA+',
          description: 'قناة الفيفا الرسمية',
          url: 'https://stream.fifa.com/live/fifa-plus.m3u8',
          iconName: 'sports_soccer',
          colorHex: '326295',
          order: 206,
          isActive: true,
        ),
      ];

      // إضافة القنوات غير الموجودة فقط
      int addedCount = 0;
      for (var channel in channels) {
        if (!existingNames.contains(channel.name.toLowerCase())) {
          await _firebaseService.addLiveChannel(channel);
          addedCount++;
        }
      }

      // إغلاق مؤشر التحميل
      if (mounted) {
        Navigator.pop(context);

        // عرض رسالة نجاح
        final skippedCount = channels.length - addedCount;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              addedCount > 0
                  ? '⚽ تم إضافة $addedCount قناة رياضية${skippedCount > 0 ? ' (تم تخطي $skippedCount قناة موجودة مسبقاً)' : ''}'
                  : '⚠️ جميع القنوات الرياضية موجودة مسبقاً',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: addedCount > 0 ? Colors.green : Colors.blue,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // إغلاق مؤشر التحميل
      if (mounted) {
        Navigator.pop(context);

        // عرض رسالة خطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ خطأ: $e', style: GoogleFonts.cairo()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _addArabicNewsChannels() async {
    // عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF1BA098)),
      ),
    );

    try {
      // الحصول على القنوات الموجودة
      final existingChannels = await _firebaseService.getLiveChannels().first;
      final existingNames = existingChannels
          .map((c) => c.name.toLowerCase())
          .toSet();

      // القنوات الإخبارية العربية مع روابط حقيقية
      final channels = [
        LiveChannelModel(
          name: 'الجزيرة مباشر',
          description: 'قناة الجزيرة الإخبارية - بث مباشر 24/7',
          url: 'https://live-hls-web-aja.getaj.net/AJA/index.m3u8',
          iconName: 'live_tv',
          colorHex: 'F39C12',
          order: 101,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'France 24 عربي',
          description: 'قناة فرانس 24 بالعربية',
          url: 'https://static.france24.com/live/F24_AR_HI_HLS/live_web.m3u8',
          iconName: 'live_tv',
          colorHex: 'E74C3C',
          order: 102,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'DW عربي',
          description: 'قناة دويتشه فيله بالعربية',
          url:
              'https://dwamdstream103.akamaized.net/hls/live/2015526/dwstream103/index.m3u8',
          iconName: 'live_tv',
          colorHex: '3498DB',
          order: 103,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'TRT عربي',
          description: 'قناة TRT التركية بالعربية',
          url: 'https://tv-trtarabi.live.trt.com.tr/master.m3u8',
          iconName: 'live_tv',
          colorHex: 'E74C3C',
          order: 104,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'الجزيرة الإنجليزية',
          description: 'Al Jazeera English',
          url: 'https://live-hls-web-aje.getaj.net/AJE/index.m3u8',
          iconName: 'live_tv',
          colorHex: 'F39C12',
          order: 105,
          isActive: true,
        ),
      ];

      // إضافة القنوات غير الموجودة فقط
      int addedCount = 0;
      for (var channel in channels) {
        if (!existingNames.contains(channel.name.toLowerCase())) {
          await _firebaseService.addLiveChannel(channel);
          addedCount++;
        }
      }

      // إغلاق مؤشر التحميل
      if (mounted) {
        Navigator.pop(context);

        // عرض رسالة نجاح
        final skippedCount = channels.length - addedCount;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              addedCount > 0
                  ? '✅ تم إضافة $addedCount قناة إخبارية عربية${skippedCount > 0 ? ' (تم تخطي $skippedCount قناة موجودة مسبقاً)' : ''}'
                  : '⚠️ جميع القنوات الإخبارية موجودة مسبقاً',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: addedCount > 0 ? Colors.green : Colors.blue,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // إغلاق مؤشر التحميل
      if (mounted) {
        Navigator.pop(context);

        // عرض رسالة خطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ خطأ: $e', style: GoogleFonts.cairo()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _removeDuplicateChannels() async {
    // عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF1BA098)),
      ),
    );

    try {
      // الحصول على جميع القنوات (بما فيها غير النشطة)
      final channels = await _firebaseService.getAllLiveChannels();

      // تجميع القنوات حسب الاسم
      final Map<String, List<LiveChannelModel>> channelsByName = {};
      for (var channel in channels) {
        final nameLower = channel.name.toLowerCase().trim();
        if (!channelsByName.containsKey(nameLower)) {
          channelsByName[nameLower] = [];
        }
        channelsByName[nameLower]!.add(channel);
      }

      // حذف القنوات المكررة (الاحتفاظ بالأولى فقط)
      int deletedCount = 0;
      for (var entry in channelsByName.entries) {
        if (entry.value.length > 1) {
          // الاحتفاظ بالقناة الأولى وحذف الباقي
          for (int i = 1; i < entry.value.length; i++) {
            if (entry.value[i].id != null) {
              await _firebaseService.deleteLiveChannel(entry.value[i].id!);
              deletedCount++;
            }
          }
        }
      }

      // إغلاق مؤشر التحميل
      if (mounted) {
        Navigator.pop(context);

        // عرض رسالة النتيجة
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              deletedCount > 0
                  ? '🗑️ تم حذف $deletedCount قناة مكررة بنجاح'
                  : '✅ لا توجد قنوات مكررة',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: deletedCount > 0 ? Colors.green : Colors.blue,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // إغلاق مؤشر التحميل
      if (mounted) {
        Navigator.pop(context);

        // عرض رسالة خطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '❌ خطأ في حذف القنوات المكررة: $e',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _addSampleChannels() async {
    // عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF1BA098)),
      ),
    );

    try {
      // الحصول على القنوات الموجودة
      final existingChannels = await _firebaseService.getLiveChannels().first;
      final existingNames = existingChannels
          .map((c) => c.name.toLowerCase())
          .toSet();

      // القنوات التجريبية مع روابط فيديو متوافقة مع iOS
      final channels = [
        LiveChannelModel(
          name: 'قناة البطولة الرسمية',
          description: 'البث المباشر لجميع مباريات البطولة',
          url:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
          iconName: 'live_tv',
          colorHex: '7D1E7D',
          order: 1,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'قناة الأهداف',
          description: 'أهداف المباريات والملخصات',
          url:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
          iconName: 'sports_soccer',
          colorHex: '1BA098',
          order: 2,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'قناة التحليلات',
          description: 'تحليلات فنية وتكتيكية للمباريات',
          url:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          iconName: 'analytics',
          colorHex: '8B7E3A',
          order: 3,
          isActive: true,
        ),
        LiveChannelModel(
          name: 'قناة المقابلات',
          description: 'مقابلات حصرية مع اللاعبين والمدربين',
          url:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          iconName: 'mic',
          colorHex: '1E5A7D',
          order: 4,
          isActive: true,
        ),
      ];

      // إضافة القنوات غير الموجودة فقط
      int addedCount = 0;
      for (var channel in channels) {
        if (!existingNames.contains(channel.name.toLowerCase())) {
          await _firebaseService.addLiveChannel(channel);
          addedCount++;
        }
      }

      // إغلاق مؤشر التحميل
      if (mounted) {
        Navigator.pop(context);

        // عرض رسالة نجاح
        final skippedCount = channels.length - addedCount;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              addedCount > 0
                  ? '✅ تم إضافة $addedCount قناة${skippedCount > 0 ? ' (تم تخطي $skippedCount قناة موجودة مسبقاً)' : ''}'
                  : '⚠️ جميع القنوات موجودة مسبقاً',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: addedCount > 0 ? Colors.green : Colors.blue,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // إغلاق مؤشر التحميل
      if (mounted) {
        Navigator.pop(context);

        // عرض رسالة خطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ خطأ: $e', style: GoogleFonts.cairo()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051622),
      appBar: AppBar(
        title: Text(
          'قنوات مباشرة',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1BA098),
        elevation: 0,
        actions: _checkingRole || _isGuest
            ? []
            : [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'خيارات',
                  onSelected: (value) {
                    if (value == 'sample') {
                      _addSampleChannels();
                    } else if (value == 'arabic') {
                      _addArabicNewsChannels();
                    } else if (value == 'sports') {
                      _addSportsChannels();
                    } else if (value == 'yemen') {
                      _addYemenChannels();
                    } else if (value == 'remove_duplicates') {
                      _removeDuplicateChannels();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'sample',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.video_library,
                            color: Color(0xFF1BA098),
                          ),
                          const SizedBox(width: 12),
                          Text('قنوات تجريبية', style: GoogleFonts.cairo()),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'arabic',
                      child: Row(
                        children: [
                          const Icon(Icons.public, color: Color(0xFF7D1E7D)),
                          const SizedBox(width: 12),
                          Text(
                            'قنوات إخبارية عربية',
                            style: GoogleFonts.cairo(),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'sports',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.sports_soccer,
                            color: Color(0xFFE74C3C),
                          ),
                          const SizedBox(width: 12),
                          Text('قنوات رياضية', style: GoogleFonts.cairo()),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'yemen',
                      child: Row(
                        children: [
                          const Icon(Icons.flag, color: Color(0xFFFF0000)),
                          const SizedBox(width: 12),
                          Text('قنوات يمنية 🇾🇪', style: GoogleFonts.cairo()),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'remove_duplicates',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_sweep, color: Colors.red),
                          const SizedBox(width: 12),
                          Text(
                            'حذف القنوات المكررة',
                            style: GoogleFonts.cairo(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'إعادة تحميل',
                  onPressed: () {
                    setState(() {}); // إعادة تحميل البيانات
                  },
                ),
              ],
      ),
      body: _checkingRole
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1BA098)),
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
                      'وضع الزائر لا يسمح بمشاهدة القنوات المباشرة.',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'قم بتسجيل الدخول أو إنشاء حساب جديد للوصول إلى القنوات المباشرة.',
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
          : StreamBuilder<List<LiveChannelModel>>(
              stream: _firebaseService.getLiveChannels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1BA098)),
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
                          'خطأ في تحميل القنوات',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: GoogleFonts.cairo(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final channels = snapshot.data ?? [];

                if (channels.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.tv_off,
                            color: Colors.white54,
                            size: 80,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد قنوات متاحة حالياً',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'اضغط على الزر أدناه لإضافة قنوات تجريبية',
                            style: GoogleFonts.cairo(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => _addSampleChannels(),
                            icon: const Icon(Icons.add_circle_outline),
                            label: Text(
                              'إضافة قنوات تجريبية',
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1BA098),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _addArabicNewsChannels(),
                            icon: const Icon(Icons.public),
                            label: Text(
                              'إضافة قنوات إخبارية عربية',
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7D1E7D),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: channels.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    return _buildChannelCard(context, channel);
                  },
                );
              },
            ),
    );
  }

  Widget _buildChannelCard(BuildContext context, LiveChannelModel channel) {
    final color = _getColorFromHex(channel.colorHex);
    final icon = _getIconFromName(channel.iconName);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChannelPlayerScreen(channel: channel),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1BA098).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 35, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channel.name,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    channel.description,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.play_circle_filled, size: 40, color: color),
          ],
        ),
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return const Color(0xFF1BA098);
    }
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'live_tv':
        return Icons.live_tv;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'analytics':
        return Icons.analytics;
      case 'mic':
        return Icons.mic;
      case 'video_library':
        return Icons.video_library;
      case 'play_circle':
        return Icons.play_circle_filled;
      default:
        return Icons.live_tv;
    }
  }
}
