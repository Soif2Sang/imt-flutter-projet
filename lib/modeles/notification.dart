import 'package:cloud_firestore/cloud_firestore.dart';
import 'constantes.dart';

class NotificationCFB {
  DocumentReference reference;
  String id;
  Map<String, dynamic> data;

  NotificationCFB({
    required this.reference,
    required this.id,
    required this.data,
  });

  String get from => data[fromKey] ?? '';
  String get text => data[textKey] ?? '';
  int get date => data[dateKey] ?? 0;
  bool get isRead => data[isAsReadKey] ?? false;
  String get postId => data[postIDKey] ?? '';
}
