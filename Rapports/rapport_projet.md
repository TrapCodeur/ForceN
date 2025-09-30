# Rapport de projet : Application de gestion des tâches

---

## Page de garde
**Programme Force-N**  
**Certification : Developpement application mobile**  

**Titre du projet :** Développement d’une application mobile de gestion des tâches  
**Étudiant :** [Votre nom]  
**Mentor :** Ckroot  
**Année  :** 2024 – 2025  

---

## Sommaire
1. Introduction  
2. Choix de conception  
3. Fonctionnalités principales  
4. Problèmes rencontrés et solutions  
5. Contraintes liées aux services payants  
6. Conclusion et perspectives  

---

## 1. Introduction
L’application est une application mobile qui aide à gérer des tâches personnelles. Elle permet à un utilisateur de créer, voir, modifier et supprimer ses propres tâches après s’être connecté avec Firebase. L’objectif est d’avoir une application simple, facile à utiliser et sécurisée.

---

## 2. Choix de conception
1. **Flutter** : choisi car il permet de créer une seule application qui marche sur Android, iOS et le Web.  
2. **Firebase Authentication** : pour l’inscription et la connexion des utilisateurs. plus simple et efficace, car on a pas besoin de faire nous meme les requêtes  
3. **Cloud Firestore** : pour stocker les tâches en temps réel. C'est pratique et c'est gratuit avec l'offre spark(50 000 requêtes par mois) ce qui vachement suffisant pour le projet  
4. **Interface simple** : utilisation de boutons et formulaires faciles à comprendre.  

---

## 3. Fonctionnalités principales
- Ajouter, modifier et supprimer une tâche.  
- Filtrer les tâches par priorité (haute, moyenne, basse).  
- S’inscrire, se connecter et se déconnecter.  
- Synchronisation en temps réel des données.  

---

## 4. Problèmes rencontrés et solutions
### 1. Sécurité et accès
- **Problème** : Tous les utilisateurs voyaient toutes les tâches.  
- **Solution** : Ajout d’un champ `userId` et filtrage des données avec `.where("userId", isEqualTo: currentUser.uid)`. mais toutefois ça bloque tout mon application. c'est pour cela cette solution n'a pas été pris en compte. Ce qui fait que tout les utilisateurs voient les taches disponible dans la base de données.  

### 2. Requêtes Firestore et index
- **Problème** : Certaines requêtes avec `where` et `orderBy` demandaient un index.  
- **Solution** : Création d’index dans la console Firebase. Mais ça ne foncionne pas 

### 3. Fonctionnalités payantes
- **Problème** : L’utilisation de Firebase Storage pour les photos dépasse vite le quota gratuit.  
- **Solution** : Utiliser une image de profil fixe au lieu de laisser l’utilisateur téléverser sa propre photo.  

### 4. Chargement des données
- **Problème** : Le `CircularProgressIndicator` s’affichait trop souvent.  
- **Solution** : Amélioration du `StreamBuilder` pour bien gérer le chargement, l’absence de tâches et l’affichage normal. mais les données se chargement lentement meme des fois il faut un realod pour que la page d'inscription ou de connexion s'affiche

---

## 5. Contraintes liées aux services payants
Firebase a un plan gratuit, mais avec des limites :  
- **Stockage d’images** : limité.  
- **Requêtes complexes** : parfois besoin d’un index payant.  
- **Notifications avancées** : certaines options deviennent payantes.  

### Stratégies adoptées
- Utilisation d’images fixes.  
- Réduction des requêtes pour rester dans le quota gratuit.  
- Application entièrement utilisable avec le plan gratuit.  

---

## 6. Conclusion et perspectives 
Cette application de gestion de tâches a permis de pratiquer le développement mobile et l’utilisation de Firebase. Malgré des limites techniques et financières, des solutions simples ont été trouvées pour garder l’application fonctionnelle et gratuite.

**Perspectives** : ajouter un calendrier, filtrer les taches en fonction des utilisateurs ,des notifications et plus d’options de personnalisation dans une version future. 
 filtrer les taches en fonction des utilisateurs
