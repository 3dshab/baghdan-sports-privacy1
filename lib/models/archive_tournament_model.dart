import 'package:cloud_firestore/cloud_firestore.dart';

/// موديل البطولة المؤرشفة
class ArchiveTournamentModel {
  final String? id;
  final String title;
  final String description;
  final String? videoUrl;
  final String? imageUrl;
  final int order;
  final DateTime createdAt;
  final String year;

  ArchiveTournamentModel({
    this.id,
    required this.title,
    required this.description,
    this.videoUrl,
    this.imageUrl,
    required this.order,
    required this.createdAt,
    required this.year,
  });

  /// تحويل من Firestore Document إلى Model
  factory ArchiveTournamentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ArchiveTournamentModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      videoUrl: data['videoUrl'],
      imageUrl: data['imageUrl'],
      order: data['order'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      year: data['year'] ?? '',
    );
  }

  /// تحويل من Model إلى Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
      'order': order,
      'createdAt': Timestamp.fromDate(createdAt),
      'year': year,
    };
  }
}
