import 'package:chti_face_bouc/services_firebase/service_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServiceAuthentification {
  // Récupère une instance de auth
  final instance = FirebaseAuth.instance;

  // Connecter à Firebase
  Future<String> signIn({required String email, required String password}) async {
    String result = "";
    return result;
  }

  // Créer un compte sur Firebase
  Future<String> createAccount({
    required String email,
    required String password,
    required String surname,
    required String name,
  }) async {
    String result = "";

    try {
      UserCredential userCredential = await instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Appel à Firestore pour ajouter un membre
      ServiceFirestore().addMember(
        id: uid,
        data: {
          'surname': surname,
          'name': name,
          'description': '',
          'profilePicture': '',
          'coverPicture': '',
        },
      );
    } on FirebaseAuthException catch (e) {
      result = e.message ?? "Erreur lors de la création du compte.";
    } catch (e) {
      result = "Erreur inattendue : $e";
    }

    return result;
  }


  // Déconnecter de Firebase
  Future<bool> signOut() async {
    bool result = false;
    return result;
  }

  // Récupérer l'id unique de l'utilisateur
  String? get myId => instance.currentUser?.uid;

  // Voir si vous êtes l'utilisateur
  bool isMe(String profileId) {
    bool result = false;
    return result;
  }
}
