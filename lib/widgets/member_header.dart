import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modeles/membre.dart';
import '../modeles/formatage_date.dart';
import '../services_firebase/service_firestore.dart';

class MemberHeader extends StatelessWidget {
  final String memberId;
  final int date;

  const MemberHeader({super.key, required this.memberId, required this.date});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ServiceFirestore().specificMember(memberId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!;
          final member = Membre(
            reference: data.reference,
            id: data.id,
            map: data.data() as Map<String, dynamic>,
          );

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                member.fullName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                FormatageDate().formatted(date),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
