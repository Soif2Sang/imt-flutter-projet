// page_fullscreen_image.dart
import 'package:flutter/material.dart';

class PageFullscreenImage extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const PageFullscreenImage({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for image focus
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow
        iconTheme: const IconThemeData(color: Colors.white), // White back button
      ),
      body: GestureDetector(
        onTap: () {
          // Optional: Tap to dismiss
          // Navigator.of(context).pop();
        },
        child: Center(
          child: Hero(
            tag: heroTag, // Unique tag for the Hero animation
            child: InteractiveViewer( // Allows pinch-to-zoom and panning
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain, // Show the whole image
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}