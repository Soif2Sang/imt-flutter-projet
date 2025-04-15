import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../modeles/membre.dart';
import '../modeles/notification.dart';
import '../services_firebase/service_firestore.dart';
import '../widgets/widget_vide.dart';
import '../widgets/widget_notif.dart';

class PageNotif extends StatefulWidget {
  final Membre member;

  const PageNotif({super.key, required this.member});

  @override
  State<PageNotif> createState() => _PageNotifState();
}

class _PageNotifState extends State<PageNotif> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: StreamBuilder<QuerySnapshot>(
        stream: ServiceFirestore().notificationForUser(widget.member.id),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print('snapshot.hasData ${snapshot.hasData}');

          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;

            if (docs.isEmpty) return const EmptyBody();

            return ListView.separated(
              itemCount: docs.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notif = NotificationCFB(
                  reference: docs[index].reference,
                  id: docs[index].id,
                  data: docs[index].data() as Map<String, dynamic>,
                );
                return Notif(notif: notif);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
