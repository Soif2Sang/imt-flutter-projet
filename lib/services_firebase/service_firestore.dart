import 'dart:io';
import 'package:chti_face_bouc/services_firebase/service_authentification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../modeles/constantes.dart';
import '../modeles/membre.dart';
import '../modeles/post.dart';
import 'service_storage.dart';

class ServiceFirestore {
  // Accès à la BDD
  static final instance = FirebaseFirestore.instance;

  // Accès spécifique à la collection "members"
  final firestoreMember = instance.collection(memberCollectionKey);

  // Accès spécifique à la collection "posts"
  final firestorePost = instance.collection(postCollectionKey);


  // Ajouter un membre
  void addMember({required String id, required Map<String, dynamic> data}) {
    firestoreMember.doc(id).set(data);
  }

  // Mettre à jour un membre
  void updateMember({required String id, required Map<String, dynamic> data}) {
    firestoreMember.doc(id).update(data);
  }

  // Stockage et mise à jour d'une image
  void updateImage({
    required File file,
    required String folder,
    required String memberId,
    required String imageName,
  }) {
    ServiceStorage()
        .addImage(
      file: file,
      folder: folder,
      userId: memberId,
      imageName: imageName,
    )
        .then((imageUrl) {
      updateMember(id: memberId, data: {imageName: imageUrl});
    });
  }

  allPosts() => firestorePost.orderBy(dateKey, descending: true).snapshots();

  postForMember(String id) => firestorePost.where(memberIdKey, isEqualTo: id).orderBy(dateKey, descending: true).snapshots();

  allMembers() => firestoreMember.snapshots();

  Future<void> createPost({
    required Membre member,
    required String text,
    required XFile? image,
  }) async {
    final date = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> map = {
      memberIdKey: member.id,
      likesKey: [],
      dateKey: date,
      textKey: text,
    };

    if (image != null) {
      final url = await ServiceStorage().addImage(
        file: File(image.path),
        folder: postCollectionKey,
        userId: member.id,
        imageName: date.toString(),
      );
      map[postImageKey] = url;
    }

    firestorePost.doc().set(map);
  }

  void addLike({required String memberID, required Post post}) {
    if (post.likes.contains(memberID)) {
      post.reference.update({likesKey: FieldValue.arrayRemove([memberID])});
    } else {
      post.reference.update({likesKey: FieldValue.arrayUnion([memberID])});
    }
  }

  void addComment({required Post post, required String text}) {
    final memberId = ServiceAuthentification().myId;
    if (memberId == null) return;

    final map = {
      memberIdKey: memberId,
      dateKey: DateTime.now().millisecondsSinceEpoch,
      textKey: text,
    };

    post.reference.collection(commentCollectionKey).doc().set(map);
  }

  Stream<QuerySnapshot> postComment(String postId) {
    return firestorePost
        .doc(postId)
        .collection(commentCollectionKey)
        .orderBy(dateKey, descending: true)
        .snapshots();
  }

  void sendNotification({
    required String to,
    required String text,
    required String postID,
  }) {
    final from = ServiceAuthentification().myId;
    if (from == null) return;

    final route = firestoreMember.doc(to).collection(notificationCollectionKey);
    route.doc().set({
      dateKey: DateTime.now().millisecondsSinceEpoch,
      isAsReadKey: false,
      fromKey: from,
      textKey: text,
      postIDKey: postID,
    });
  }

  markRead(DocumentReference reference) {
    reference.update({isAsReadKey: true});
  }

  notificationForUser(String id) {
    firestoreMember.doc(id).collection(notificationCollectionKey).orderBy(dateKey, descending: true).snapshots();
  }

  Stream<DocumentSnapshot> specificMember(String memberId) {
    return firestoreMember.doc(memberId).snapshots();
  }
}
