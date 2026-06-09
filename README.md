# Blackjack - Projet Application Mobile

Une application de Blackjack moderne réalisée avec **Flutter**. Ce projet permet de simuler une expérience de jeu de casino complète avec gestion de compte, système de mise et interface réactive.

## Fonctionnalités

### 1. Menu & Authentification
- **Création de compte** : Enregistrement d'un pseudo et d'un mot de passe sécurisé.
- **Système de Connexion** : Vérification des informations via un service dédié.
- **Gestion du Budget** : Sélection de la mise de départ (de 50 à 1000 jetons) via un slider interactif.

### 2. Gameplay (Le Jeu)
- **Distribution Automatique** : Le joueur et le croupier reçoivent leurs cartes au lancement.
- **Actions de jeu** :
    - **HIT** : Tirer une carte supplémentaire.
    - **STAND** : S'arrêter et laisser le croupier jouer.
- **Logique de Dealer** : Le croupier joue automatiquement selon les règles classiques (s'arrête à 17).
- **Gestion des Gains/Pertes** : Calcul automatique des scores et mise à jour de la banque en temps réel.

### 3. Interface Utilisateur (UI)
- **Design Immersif** : Fond vert "tapis de jeu" avec assets de cartes personnalisés.
- **Panneau d'actions transparent** : Pour une meilleure visibilité du plateau.
- **Optimisation Mobile** : Interface adaptative gérant l'ouverture du clavier et évitant les débordements (overflow).

---

## Architecture du Projet

Le projet suit une structure modulaire pour séparer la logique de données de l'interface utilisateur.

### Structure des dossiers
- **`lib/models/`** : Contient les classes de données (entités).
    - `card.dart` : Définit une carte (valeur, suite).
    - `deck52.dart` : Gère le paquet de 52 cartes (mélange, tirage).
    - `player.dart` : Gère l'état du joueur (main, score, solde).
    - `pop_up_msg.dart` : Enumération centralisant tous les messages de l'application.
- **`lib/services/`** : Logique métier et persistence.
    - `joueur_service.dart` : Gère la sauvegarde du profil, l'authentification et les données du joueur.
- **`lib/pages/`** : Écrans de l'application (UI).
    - `menu.dart` : Écran d'accueil, login et configuration de la partie.
    - `game.dart` : Cœur du jeu et boucle de gameplay.
- **`assets/`** : Images des cartes et éléments graphiques.