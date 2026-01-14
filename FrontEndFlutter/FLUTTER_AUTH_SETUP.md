# Guide d'Installation et Configuration - Authentification Flutter

## ✅ Ce qui a été créé

### 1. **Architecture Clean Architecture** ✅
- **Domain** : Entités, repositories, use cases
- **Data** : Models, datasources (remote/local), repositories impl
- **Presentation** : BLoC, pages, widgets

### 2. **Pages UI** ✅
- **LoginPage** : Page de connexion avec le design spécifié
- **SignupPage** : Page d'inscription avec le design spécifié

### 3. **Widgets Personnalisés** ✅
- **CustomTextField** : Champ de texte avec design spécifié
- **CustomButton** : Bouton avec ombre portée
- **SocialButton** : Boutons sociaux (Google, Apple)

### 4. **Intégration Backend** ✅
- Connexion avec l'API NestJS
- Gestion du token JWT
- Stockage sécurisé des tokens
- Gestion des erreurs

## 🚀 Installation et Configuration

### 1. Générer les fichiers JSON
```bash
cd FrontEndFlutter
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Vérifier la configuration API
Vérifiez que `lib/core/config/app_config.dart` a la bonne URL :
```dart
static const String baseUrl = 'http://localhost:3000/api';
```

Pour Android Emulator, utilisez `10.0.2.2` au lieu de `localhost` :
```dart
static const String baseUrl = 'http://10.0.2.2:3000/api';
```

Pour iOS Simulator, `localhost` fonctionne.

### 3. Lancer l'application
```bash
flutter run
```

## 📱 Design Implémenté

### Couleurs
- **Bleu foncé** : `#1A2B4C` (Titres)
- **Bleu principal** : `#4A90E2` (Boutons, liens)
- **Gris clair** : `#F5F7FA` (Fond des inputs)
- **Blanc** : `#FFFFFF` (Arrière-plan)

### Composants
- **TextField** : Coins arrondis (12px), bordure bleue quand actif
- **Bouton** : Ombre portée bleue, texte en majuscules
- **Boutons sociaux** : Bordure grise fine, icônes à gauche
- **Marges** : 24px sur les côtés

## 🔧 Structure des Fichiers

```
lib/
├── main.dart                          # Point d'entrée avec DI et routing
├── core/
│   ├── config/
│   │   └── di_config.dart            # Injection de dépendances
│   └── routing/
│       └── app_router.dart             # Configuration GoRouter
├── features/
│   └── auth/
│       ├── domain/                   # Entités, repositories, use cases
│       ├── data/                      # Models, datasources, repositories impl
│       └── presentation/
│           ├── bloc/                  # BLoC (events, states, bloc)
│           └── pages/                 # LoginPage, SignupPage
└── shared/
    ├── themes/
    │   └── app_theme.dart            # Thème de l'application
    └── widgets/
        ├── custom_text_field.dart    # TextField personnalisé
        ├── custom_button.dart        # Bouton personnalisé
        └── social_button.dart        # Bouton social
```

## 🧪 Test de l'Application

### 1. Démarrer le backend
```bash
cd Backend
npm run start:dev
```

### 2. Tester l'inscription
1. Ouvrir l'app Flutter
2. Cliquer sur "S'inscrire"
3. Remplir le formulaire
4. Cliquer sur "S'INSCRIRE"
5. Vérifier la redirection vers `/home`

### 3. Tester la connexion
1. Cliquer sur "Se connecter"
2. Entrer email et mot de passe
3. Cliquer sur "SE CONNECTER"
4. Vérifier la redirection vers `/home`

## ⚠️ Problèmes Courants

### Erreur : "Cannot connect to API"
- Vérifiez que le backend est démarré
- Pour Android : Utilisez `10.0.2.2` au lieu de `localhost`
- Vérifiez les paramètres CORS du backend

### Erreur : "Build runner failed"
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Erreur : "Token not found"
- Vérifiez que `flutter_secure_storage` est bien installé
- Sur iOS, vérifiez les permissions dans `Info.plist`

## 📝 Prochaines Étapes

1. **Générer les fichiers JSON** :
   ```bash
   flutter pub run build_runner build
   ```

2. **Tester l'application** :
   - Inscription
   - Connexion
   - Navigation

3. **Améliorations futures** :
   - Google Sign In
   - Apple Sign In
   - Réinitialisation du mot de passe
   - Page d'accueil complète

## 🎯 Checklist

- [x] Architecture Clean Architecture
- [x] Pages Login et Signup
- [x] Widgets personnalisés
- [x] Intégration backend
- [x] Gestion d'état (BLoC)
- [x] Routing (GoRouter)
- [x] Injection de dépendances
- [ ] Génération des fichiers JSON (à faire)
- [ ] Tests

---

**L'interface signup/signin est prête !** 🎉
