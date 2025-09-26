import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_do/auth/register_page.dart';
import 'package:i_do/page/home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _createUser() async {
    final usersCollection = FirebaseFirestore.instance.collection("users");
    await usersCollection.doc(user!.uid).set({
      "fullname": _fullnameController.text.trim(),
      "phone": _phoneController.text.trim(),
      "email": user?.email ?? "",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user == null) return;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        _fullnameController.text = data["fullname"] ?? "";
        _phoneController.text = data["phone"] ?? "";
      });
    } else {
      // Créer le document utilisateur si inexistant
      await _createUser();
    }
  }

  Future<void> _saveUserData() async {
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({
            "fullname": _fullnameController.text.trim(),
            "phone": _phoneController.text.trim(),
          });

      setState(() => _isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Informations mises à jour avec succès"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Erreur : $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.email?.split('@')[0] ?? 'No Name'),
              accountEmail: Text(user?.email ?? 'No Email'),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/images.png"),
              ),
              decoration: const BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Profil"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Deconnexion"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/images.png"),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.email?.split('@')[0] ?? "Utilisateur",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user?.email ?? "Email",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),

                // --- FORMULAIRE ---
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextField(
                        controller: _fullnameController,
                        decoration: InputDecoration(
                          labelText: "Prénom et Nom",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: "Numéro de téléphone",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        enabled: false,

                        decoration: InputDecoration(
                          labelText: "Adresse email",
                          hintText: user?.email ?? "Votre adresse email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _saveUserData();
                          },
                          child: const Text("Enregistrer"),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      label: const Text("Retour"),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      label: const Text("Deconnexion"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      icon: const Icon(Icons.logout, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
