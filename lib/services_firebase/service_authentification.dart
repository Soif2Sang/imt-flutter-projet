import 'service_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServiceAuthentification {
  // Récupère une instance de auth
  final instance = FirebaseAuth.instance;

  Future<User> signIn({required String email, required String password}) async {
    try {
      UserCredential userCredential = await instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Return the authenticated User object
      return userCredential.user!;
    } on FirebaseAuthException {
      // Re-throw specific FirebaseAuthExceptions
      rethrow;
    } catch (e) {
      // Wrap other unexpected errors in a more informative Exception
      throw Exception("Erreur inattendue lors de la connexion : $e");
    }
  }

  // Créer un compte sur Firebase
  Future<User> createAccount({
    required String email,
    required String password,
    required String surname,
    required String name,
  }) async {
    try {
      UserCredential userCredential = await instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      ServiceFirestore().addMember(
        id: uid,
        data: {
          'surname': surname,
          'name': name,
          'memberID': uid,
          'description': '',
          'profilePicture': '',
          'coverPicture': '',
        },
      );

      // Return the created User object
      return userCredential.user!;
    } on FirebaseAuthException {
      // Re-throw specific FirebaseAuthExceptions (e.g., weak-password, email-already-in-use)
      rethrow;
    } catch (e) {
      // Wrap other unexpected errors
      throw Exception("Erreur inattendue lors de la création du compte : $e");
    }
  }

  // Déconnecter de Firebase
  Future<bool> signOut() async {
    instance.signOut();

    return true;
  }

  // Récupérer l'id unique de l'utilisateur
  String? get myId => instance.currentUser?.uid;

  // Voir si vous êtes l'utilisateur
  bool isMe(String profileId) {
    return myId == profileId;
  }
}
