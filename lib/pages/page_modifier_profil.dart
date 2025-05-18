import 'package:flutter/material.dart';
import '../modeles/constantes.dart';
import '../modeles/membre.dart';
import '../services_firebase/service_firestore.dart';
import '../services_firebase/service_authentification.dart';

class ModifierProfil extends StatefulWidget {
  final Membre member;

  const ModifierProfil({super.key, required this.member});

  @override
  State<ModifierProfil> createState() => _ModifierProfilState();
}

class _ModifierProfilState extends State<ModifierProfil> {
  late TextEditingController surnameController;
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    surnameController = TextEditingController(text: widget.member.surname);
    nameController = TextEditingController(text: widget.member.name);
    descriptionController = TextEditingController(text: widget.member.description);
  }

  @override
  void dispose() {
    surnameController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _onValidate() {
    FocusScope.of(context).requestFocus(FocusNode());
    Map<String, dynamic> map = {};
    final member = widget.member;

    if (nameController.text.isNotEmpty && nameController.text != member.name) {
      map[nameKey] = nameController.text;
    }

    if (surnameController.text.isNotEmpty && surnameController.text != member.surname) {
      map[surnameKey] = surnameController.text;
    }

    if (descriptionController.text.isNotEmpty && descriptionController.text != member.description) {
      map[descriptionKey] = descriptionController.text;
    }

    if (map.isNotEmpty) {
      ServiceFirestore().updateMember(id: member.id, data: map).then((_) {
        // Show success banner
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Member details updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }).catchError((error) {
        // Show error banner if update fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update member details. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      });
    }
  }

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
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst); // Retour à l'accueil
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _onValidate,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: surnameController,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),

            // Ajout d'un espace entre les champs de texte
            const SizedBox(height: 16), // Ajustez la hauteur selon vos besoins

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),

            // Ajout d'un espace entre les champs de texte
            const SizedBox(height: 16), // Ajustez la hauteur selon vos besoins

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _onLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error, // Couleur d'erreur pour le bouton de déconnexion
                foregroundColor: Theme.of(context).colorScheme.onError, // Couleur du texte sur la couleur d'erreur
              ),
              child: const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
