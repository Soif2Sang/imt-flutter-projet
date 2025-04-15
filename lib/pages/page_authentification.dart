import 'package:flutter/material.dart';
import '../services_firebase/service_authentification.dart';

class PageAuthentification extends StatefulWidget {
  const PageAuthentification({super.key});

  @override
  State<PageAuthentification> createState() => _PageAuthentificationState();
}

class _PageAuthentificationState extends State<PageAuthentification> {
  bool accountExists = true;

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
    setState(() {
      accountExists = newValue.first;
    });
  }

  Future<void> _handleHauth() async {
    String result = '';
    if (accountExists) {
      result = await authService.signIn(
        email: mailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } else {
      result = await authService.createAccount(
        email: mailController.text.trim(),
        password: passwordController.text.trim(),
        surname: surnameController.text.trim(),
        name: nameController.text.trim(),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.isEmpty ? 'Succès' : result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset('assets/logo.png', height: 150), // Ajoutez votre logo ici
              const SizedBox(height: 20),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Connexion')),
                  ButtonSegment(value: false, label: Text('Créer un compte')),
                ],
                selected: {accountExists},
                onSelectionChanged: _onSelectedChanged,
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: mailController,
                        decoration: const InputDecoration(labelText: 'Adresse mail'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: 'Mot de passe'),
                        obscureText: true,
                      ),
                      if (!accountExists) ...[
                        const SizedBox(height: 10),
                        TextField(
                          controller: surnameController,
                          decoration: const InputDecoration(labelText: 'Prénom'),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Nom'),
                        ),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _handleHauth,
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
  }
}
