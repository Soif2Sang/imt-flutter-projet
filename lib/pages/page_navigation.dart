import 'package:chti_face_bouc/pages/page_authentification.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'page_notification.dart';
import 'page_accueil.dart';
import 'page_ecrire_post.dart';
import 'page_membre.dart';
import 'page_profil.dart';
import '../modeles/membre.dart';
import '../services_firebase/service_authentification.dart';
import '../services_firebase/service_firestore.dart';
import '../widgets/widget_vide.dart'; // Assuming EmptyScaffold is in this file

class PageNavigation extends StatefulWidget {
  const PageNavigation({super.key});

  @override
  State<PageNavigation> createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> {
  int index = 0;

  // Logout logic copied from ModifierProfil
  void _onLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Oui'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ServiceAuthentification().signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PageAuthentification()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final memberId = ServiceAuthentification().myId;

    if (memberId == null) {
      return const EmptyScaffold(); // Ensure EmptyScaffold is defined or imported
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
            Center(child: PageEcrirePost(member: member, newDestination: (val) => setState(() => index = val))),
            Center(child: PageNotif(member: member)),
            Center(child: PageProfil(member: member)),
          ];

          return Scaffold(
            appBar: AppBar(
              title: Text(member.fullName),
              actions: <Widget>[
                IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () {
                  _onLogout();
                },
              ),
            ]
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
