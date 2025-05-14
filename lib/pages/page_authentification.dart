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
  void initState() {
    super.initState();
  }

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter email and password.')),
        );
      }
      return;
    }

    if (!accountExists) {
      if (surnameController.text.trim().isEmpty || nameController.text.trim().isEmpty) {
        if (mounted) { // Check if widget is still mounted before showing SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your first name and last name.')),
          );
        }
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

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
      String errorMessage = "Authentication failed. ${e.message}";

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is invalid.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      // --- End Stop Loading ---
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/my_icon.png', height: 150),
              const SizedBox(height: 20),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Connexion')),
                  ButtonSegment(value: false, label: Text('Créer un compte')),
                ],
                selected: {accountExists},
                onSelectionChanged: _isLoading ? null : _onSelectedChanged,
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: mailController,
                        decoration: const InputDecoration(labelText: 'Adresse mail'),
                        enabled: !_isLoading,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: 'Mot de passe'),
                        obscureText: true,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      if (!accountExists) ...[
                        const SizedBox(height: 10),
                        TextField(
                          controller: surnameController,
                          decoration: const InputDecoration(labelText: 'Prénom'),
                          enabled: !_isLoading,
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Nom'),
                          enabled: !_isLoading,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ],
                      const SizedBox(height: 20),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                        onPressed: _handleAuth, // Button is only active when not loading
                        child: Text(accountExists ? 'Se connecter' : 'Créer un compte'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
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
  }
}