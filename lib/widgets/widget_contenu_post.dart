import 'package:chti_face_bouc/widgets/widget_member_header.dart';
import 'package:flutter/material.dart';
import '../modeles/post.dart';
import '../modeles/formatage_date.dart';
import '../pages/page_full_screen_image_screen.dart';

class ContenuPost extends StatelessWidget {
  final Post post;

  const ContenuPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MemberHeader(
          memberId: post.member,
          date: post.date,
        ),
        const SizedBox(height: 8),
        if (post.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              post.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        if (post.imageUrl.isNotEmpty)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PageFullscreenImage(
                    imageUrl: post.imageUrl,
                    heroTag: post.imageUrl,
                  ),
                ),
              );
            },
            child: Hero(
              tag: post.imageUrl,
              child: Container(
                // Constrain the image height or use AspectRatio
                // Adjust height as per your design preference
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5, // Max 50% of screen height
                ),
                child: Image.network(
                  post.imageUrl,
                  fit: BoxFit.cover, // Or BoxFit.contain if you don't want cropping
                  width: double.infinity, // Make image take full width
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      // Fixed height during loading to prevent layout jumps
                      height: 250, // You can adjust this
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2.0,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250, // Consistent height on error
                      color: Colors.grey[200],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, color: Colors.grey[500], size: 40),
                            const SizedBox(height: 8),
                            Text("Could not load image", style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
/*        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            FormatageDate().formatted(post.date),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),*/
      ],
    );
  }
}
