import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modeles/notification.dart';
import '../modeles/post.dart';
import '../services_firebase/service_firestore.dart';
import '../pages/page_detail_post_page.dart';
import 'widget_member_header.dart';

class Notif extends StatelessWidget {
  final NotificationCFB notif;

  const Notif({super.key, required this.notif});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Marquer comme lu et naviguer vers le post
        ServiceFirestore()
            .firestorePost
            .doc(notif.postId)
            .get()
            .then((snapshot) {
          ServiceFirestore().markRead(notif.reference);
          final post = Post(
            reference: snapshot.reference,
            id: snapshot.id,
            map: snapshot.data() as Map<String, dynamic>,
          );

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PageDetailPost(post: post),
            ),
          );
        });
      },
      child: Container(
        color: notif.isRead
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.primaryContainer,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 5, right: 5, top: 8),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MemberHeader(
              memberId: notif.from,
              date: notif.date,
            ),
            const SizedBox(height: 4),
            Text(notif.text),
          ],
        ),
      ),
    );
  }
}
