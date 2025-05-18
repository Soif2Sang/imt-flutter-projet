import 'dart:io'; // Import for File

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../modeles/membre.dart';
import '../services_firebase/service_firestore.dart';

class PageEcrirePost extends StatefulWidget {
  final Membre member;
  final void Function(int) newDestination;

  const PageEcrirePost({
    super.key,
    required this.member,
    required this.newDestination,
  });

  @override
  State<PageEcrirePost> createState() => _PageEcrirePostState();
}

class _PageEcrirePostState extends State<PageEcrirePost> {
  final TextEditingController textController = TextEditingController();
  XFile? xFile;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _takePic(ImageSource source) async {
    final XFile? newFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 500,
    );
    setState(() {
      xFile = newFile;
    });
  }

  void _sendPost() {
    FocusScope.of(context).requestFocus(FocusNode());

    if (xFile == null && textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add text or an image to your post.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return; // Prevent sending an empty post
    }

    ServiceFirestore().createPost(
      member: widget.member,
      text: textController.text,
      image: xFile,
    );

    // Clear the fields after sending
    textController.clear();
    setState(() {
      xFile = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post created successfully! You may need to wait a bit to see the modification.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    widget.newDestination(0); // Redirects to the Accueil page
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the content in a Scaffold to add an AppBar
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Créer un Post'), // Added AppBar title
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align card content to start
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.border_color),
                        SizedBox(width: 8),
                        Text(
                          "Écrire un post",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Optional styling
                        ),
                      ],
                    ),
                    const Divider(),
                    TextField(
                      controller: textController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Votre post",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Display the selected image if available
                    if (xFile != null) ...[
                      Image.file(
                        File(xFile!.path),
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                      const SizedBox(height: 12),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.photo),
                          tooltip: 'Choisir depuis la galerie',
                          onPressed: () => _takePic(ImageSource.gallery),
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          tooltip: 'Prendre une photo',
                          onPressed: () => _takePic(ImageSource.camera),
                        ),
                        // Optional: Add a button to clear the selected image
                        if (xFile != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            tooltip: 'Supprimer l\'image',
                            onPressed: () {
                              setState(() {
                                xFile = null;
                              });
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _sendPost,
              child: const Text("Envoyer"),
            ),
          ],
        ),
      ),
    );
  }
}
