import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudNote {
  final String documentId;
  final String date;
  final String ownerUserId;
  final String title;
  final String text;
  const CloudNote({
    required this.documentId,
    required this.title,
    required this.ownerUserId,
    required this.date,
    required this.text,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        title = snapshot.data()["title"],
        date = snapshot.data()['date'],
        text = snapshot.data()[textFieldName] as String;
}
