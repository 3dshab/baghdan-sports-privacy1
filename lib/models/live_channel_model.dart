import 'package:cloud_firestore/cloud_firestore.dart';

/// نموذج القناة المباشرة
class LiveChannelModel {
  final String? id;
  final String name;
  final String description;
  final String url;
  final String iconName; // اسم الأيقونة (live_tv, sports_soccer, analytics, mic)
  final String colorHex; // اللون بصيغة hex (مثل: 7D1E7D)
  final int order; // ترتيب العرض
  final bool isActive; // هل القناة نشطة؟

  LiveChannelModel({
    this.id,
    required this.name,
    required this.description,
    required this.url,
    this.iconName = 'live_tv',
    this.colorHex = '1BA098',
    this.order = 0,
    this.isActive = true,
  });

  /// تحويل من Firestore Document إلى Model
  factory LiveChannelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LiveChannelModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      url: data['url'] ?? '',
      iconName: data['iconName'] ?? 'live_tv',
      colorHex: data['colorHex'] ?? '1BA098',
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
    );
  }

  /// تحويل من Model إلى Map لحفظه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'url': url,
      'iconName': iconName,
      'colorHex': colorHex,
      'order': order,
      'isActive': isActive,
    };
  }

  /// نسخ النموذج مع تعديل بعض الحقول
  LiveChannelModel copyWith({
    String? id,
    String? name,
    String? description,
    String? url,
    String? iconName,
    String? colorHex,
    int? order,
    bool? isActive,
  }) {
    return LiveChannelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
    );
  }
}
