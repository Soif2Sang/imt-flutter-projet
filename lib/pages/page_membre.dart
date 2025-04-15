import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../modeles/membre.dart';
import '../services_firebase/service_firestore.dart';
import '../widgets/widget_vide.dart';
import 'page_profil.dart';

class PageMembres extends StatefulWidget {
  const PageMembres({super.key});

  @override
  State<PageMembres> createState() => _PageMembresState();
}

class _PageMembresState extends State<PageMembres> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ServiceFirestore().allMembers(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) return const EmptyBody();

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final data = docs[index];
              final member = Membre(
                reference: data.reference,
                id: data.id,
                map: data.data() as Map<String, dynamic>,
              );

              return ListTile(
                title: Text(member.fullName),
                subtitle: Text(member.description),
                // Inside PageMembres -> itemBuilder -> ListTile -> onTap:
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Wrap PageProfil in a Scaffold here
                      builder: (_) => Scaffold(
                        appBar: AppBar(
                          // Add an AppBar for back navigation and context
                          title: Text(member.fullName),
                        ),
                        // Use the PageProfil as the body of this new Scaffold
                        body: PageProfil(member: member),
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return const EmptyBody();
        }
      },
    );
  }
}
