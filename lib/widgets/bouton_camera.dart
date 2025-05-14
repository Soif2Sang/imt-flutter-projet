import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services_firebase/service_firestore.dart';
import '../modeles/constantes.dart';

class BoutonCamera extends StatelessWidget {
  final String type; // coverPictureKey ou profilePictureKey
  final String id;

  const BoutonCamera({super.key, required this.type, required this.id});

  Future<void> _takePicture(BuildContext context, ImageSource source, String type) async {
    final XFile? xFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 500,
    );

    if (xFile == null) return;

    final File file = File(xFile.path);

    try {
      ServiceFirestore().updateImage(
        file: file,
        folder: memberCollectionKey,
        memberId: id,
        imageName: type,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image uploaded successfully! You may need to wait a bit to see the modification.'),
          duration: Duration(seconds: 2),
        ),
      );

    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.camera_alt),
      onPressed: () {
        _takePicture(context, ImageSource.gallery, type);
      },
    );
  }
}