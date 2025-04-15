import 'package:chti_face_bouc/pages/page_accueil.dart';
import 'package:chti_face_bouc/pages/page_ecrire_post.dart';
import 'package:chti_face_bouc/pages/page_membre.dart';
import 'package:chti_face_bouc/pages/page_profil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../modeles/membre.dart';
import '../services_firebase/service_authentification.dart';
import '../services_firebase/service_firestore.dart';
import '../widget_vide.dart';

class PageNavigation extends StatefulWidget {
  const PageNavigation({super.key});

  @override
  State<PageNavigation> createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final memberId = ServiceAuthentification().myId;

    if (memberId == null) {
      return const EmptyScaffold();
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: ServiceFirestore().specificMember(memberId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final Membre member = Membre(
            reference: data.reference,
            id: data.id,
            map: data.data() as Map<String, dynamic>,
          );

          List<Widget> bodies = [
            Center(child: PageAccueil(title: 'Accueil')),
            Center(child: PageMembres()),
            Center(child: PageEcrirePost(member: member, newSelection: (val) => setState(() => index = val))),
            Center(child: Text("Notifications")),
            Center(child: PageProfil(member: member)),
          ];

          return Scaffold(
            appBar: AppBar(
              title: Text(member.fullName),
            ),
            bottomNavigationBar: NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              selectedIndex: index,
              onDestinationSelected: (int newValue) {
                setState(() {
                  index = newValue;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: "Accueil",
                ),
                NavigationDestination(
                  icon: Icon(Icons.group),
                  label: "Membres",
                ),
                NavigationDestination(
                  icon: Icon(Icons.border_color),
                  label: "Écrire",
                ),
                NavigationDestination(
                  icon: Icon(Icons.notifications),
                  label: "Notification",
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: "Profil",
                ),
              ],
            ),
            body: bodies[index],
          );
        } else {
          return const EmptyScaffold();
        }
      },
    );
  }
}