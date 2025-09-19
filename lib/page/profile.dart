// Page pour le profil de l'utilisateur en utilisant Firebase Authentication
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_do/auth/register_page.dart';
import 'package:i_do/page/home_page.dart';

//import '../main.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

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
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/images/images.png"),
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Profil"),
              onTap: () {
                Navigator.pop(context); // Ferme le drawer
                // Navigue vers la page profil ou autre
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Deconnexion"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                // Redirection vers la page de login après la déconnexion
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
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/images.png"),
              ),
              SizedBox(height: 16),
              Text(
                user?.email?.split('@')[0] ?? "Utilisateur",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(user?.email ?? "Email", style: TextStyle(fontSize: 18)),
              Padding(
                padding: const EdgeInsets.all((30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),

                          //Action pour retourner à la page d'accueil
                        );
                      },
                      label: Text("Retour"),
                      icon: Icon(Icons.arrow_back),
                    ),

                    ElevatedButton.icon(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      label: Text("Deconnexion"),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                      ),
                      icon: Icon(Icons.logout, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
