# Application de gestion des tâches - Flutter & Firebase

## 📌 Description
Cette application est une solution simple pour gérer ses tâches quotidiennes.  
Elle permet aux utilisateurs de :
- S’inscrire et se connecter avec **Firebase Authentication**.
- Ajouter, modifier et supprimer leurs propres tâches.
- Filtrer les tâches par priorité (Haute, Moyenne, Basse).
- Voir uniquement leurs tâches (chaque tâche est liée à l’utilisateur).
- Sauvegarder certaines informations comme les **produits cultivés** dans **Firestore**.

---

## 🚀 Technologies utilisées
- **Flutter** (Framework multiplateforme)
- **Dart** (Langage de programmation)
- **Firebase Authentication** (Gestion des comptes utilisateurs)
- **Firebase Firestore** (Base de données temps réel)
- **Provider / State management** (selon ton choix)

---

## 📂 Structure du projet
lib/
├── main.dart # Point d'entrée
├── auth/ # Pages d’inscription et connexion
├── page/ # Pages principales (ex: tâches)
├── models/ # Modèles de données (Task, User, etc.)
## ⚙️ Installation et configuration

### 1. Cloner le projet
git clone https://github.com/TrapCodeur/ForceN.git
cd ForceN

2. Installer les dépendances
flutter pub get

3. Configurer Firebase

Crée un projet Firebase : https://console.firebase.google.com

Active Authentication (Email/Password).

Active Cloud Firestore.

Télécharge et place le fichier google-services.json (Android) dans android/app/.

Télécharge et place le fichier GoogleService-Info.plist (iOS) dans ios/Runner/.

4. Lancer l’application
flutter run

🛠️ Difficultés rencontrées

Problème d’accès aux tâches → Résolu en filtrant avec userId.

Index Firestore requis pour certaines requêtes → Créés via la console Firebase.

Certaines fonctionnalités Firebase sont payantes (Storage, requêtes complexes) → remplacées par des alternatives gratuites.

📌 Améliorations possibles

Ajouter des notifications push pour rappeler les tâches.

Intégrer un calendrier.

Personnaliser les profils utilisateurs avec des photos.

Synchroniser avec un plan payant pour des fonctionnalités avancées.
