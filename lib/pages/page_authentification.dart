import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'page_navigation.dart';
import '../services_firebase/service_authentification.dart';

class PageAuthentification extends StatefulWidget {
  const PageAuthentification({super.key});

  @override
  State<PageAuthentification> createState() => _PageAuthentificationState();
}

class _PageAuthentificationState extends State<PageAuthentification> {
  bool accountExists = true;
  bool _isLoading = false;

  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final ServiceAuthentification authService = ServiceAuthentification();

  @override
  void dispose() {
    mailController.dispose();
    passwordController.dispose();
    surnameController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _onSelectedChanged(Set<bool> newValue) {
    if (!_isLoading) {
      setState(() {
        accountExists = newValue.first;
        mailController.clear();
        passwordController.clear();
        surnameController.clear();
        nameController.clear();
      });
    }
  }

  Future<void> _handleAuth() async {
    if (_isLoading) return;

    if (mailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      _showSnackBar('Veuillez entrer votre email et mot de passe.');
      return;
    }

    if (!accountExists &&
        (surnameController.text.trim().isEmpty || nameController.text.trim().isEmpty)) {
      _showSnackBar('Veuillez entrer votre prénom et nom.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (accountExists) {
        await authService.signIn(
          email: mailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        await authService.createAccount(
          email: mailController.text.trim(),
          password: passwordController.text.trim(),
          surname: surnameController.text.trim(),
          name: nameController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PageNavigation()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = switch (e.code) {
        'user-not-found' => 'Aucun utilisateur trouvé pour cet email.',
        'wrong-password' => 'Mot de passe incorrect.',
        'email-already-in-use' => 'Un compte existe déjà pour cet email.',
        'weak-password' => 'Le mot de passe fourni est trop faible.',
        'invalid-email' => 'L\'adresse email est invalide.',
        _ => "Échec de l'authentification. ${e.message}"
      };
      _showSnackBar(errorMessage);
    } catch (e) {
      _showSnackBar('Une erreur inattendue est survenue : ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://t3.ftcdn.net/jpg/01/02/88/40/360_F_102884000_9nDhPvgQwwaNgDWbAwUJVR0puNDOMYhL.jpg',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: Text(
                            'CHTI FACE BOUC',
                            style: TextStyle(
                              fontFamily: 'StarJedi',
                              fontSize: 40,
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4.0,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.blueAccent,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(value: true, label: Text('Connexion')),
                            ButtonSegment(value: false, label: Text('Créer un compte')),
                          ],
                          selected: {accountExists},
                          onSelectionChanged: _isLoading ? null : _onSelectedChanged,
                          style: SegmentedButton.styleFrom(
                            selectedBackgroundColor: Colors.yellowAccent.withOpacity(0.3),
                            selectedForegroundColor: Colors.yellowAccent,
                            foregroundColor: Colors.blueGrey[200],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          elevation: 8,
                          color: Colors.blueGrey[900]?.withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                _buildTextField(
                                  controller: mailController,
                                  label: 'Adresse mail',
                                  icon: Icons.email,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 15),
                                _buildTextField(
                                  controller: passwordController,
                                  label: 'Mot de passe',
                                  icon: Icons.lock,
                                  obscureText: true,
                                ),
                                if (!accountExists) ...[
                                  const SizedBox(height: 15),
                                  _buildTextField(
                                    controller: surnameController,
                                    label: 'Prénom',
                                    icon: Icons.person,
                                    textCapitalization: TextCapitalization.words,
                                  ),
                                  const SizedBox(height: 15),
                                  _buildTextField(
                                    controller: nameController,
                                    label: 'Nom',
                                    icon: Icons.person_outline,
                                    textCapitalization: TextCapitalization.words,
                                  ),
                                ],
                                const SizedBox(height: 30),
                                _isLoading
                                    ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.yellowAccent,
                                  ),
                                )
                                    : ElevatedButton(
                                  onPressed: _handleAuth,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.yellowAccent,
                                    foregroundColor: Colors.blueGrey[900],
                                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                    textStyle: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(accountExists ? 'Se connecter' : 'Créer un compte'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueGrey[200]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey[700]!),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.yellowAccent),
          borderRadius: BorderRadius.circular(8.0),
        ),
        prefixIcon: Icon(icon, color: Colors.blueGrey[300]),
      ),
      style: const TextStyle(color: Colors.white),
      enabled: !_isLoading,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
    );
  }
}