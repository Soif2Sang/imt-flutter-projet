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
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a placeholder with fixed size to avoid layout jumps
          return const SizedBox(
            width: 50, // Match avatar size roughly
            height: 50,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
          );
        }

        if (snapshot.hasError) {
          // Handle error case, maybe show an error icon or placeholder
          return const CircleAvatar(child: Icon(Icons.error_outline));
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!;
          final member = Membre(
            reference: data.reference,
            id: data.id,
            map: data.data() as Map<String, dynamic>,
          );

          // --- REVISED STRUCTURE ---
          // Use a Row: Avatar on the left, Column (Name + Date) on the right
          return Row(
            mainAxisSize: MainAxisSize.min, // Crucial: Row takes minimum space needed
            children: [
              CircleAvatar(
                radius: 24, // Optional: customize size
                backgroundImage: member.profilePicture.isNotEmpty
                    ? NetworkImage(member.profilePicture)
                    : null,
                backgroundColor: Colors.grey.shade800, // fallback background
                child: member.profilePicture.isEmpty
                    ? const Icon(Icons.person_off_outlined, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 8), // Add some spacing between avatar and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text left
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically if needed
                children: [
                  Text(
                    member.fullName,
                    style: Theme.of(context).textTheme.titleSmall, // Adjusted style? Maybe smaller fits better in leading
                    overflow: TextOverflow.ellipsis, // Prevent long names breaking layout
                  ),
                  Text(
                    FormatageDate().formatted(date),
                    style: Theme.of(context).textTheme.bodySmall, // Adjusted style? labelSmall might be too small here
                  ),
                ],
              ),
            ],
          );
          // --- END REVISED STRUCTURE ---

        } else {
          // Handle member not found case
          return const CircleAvatar(child: Icon(Icons.person_off_outlined));
        }
      },
    );
  }
}