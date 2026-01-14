# Guide de Configuration et Démarrage

Ce guide vous aidera à configurer et démarrer le projet après la création de l'architecture.

## 📋 Prérequis

### Backend
- Node.js (v18 ou supérieur)
- PostgreSQL (v14 ou supérieur)
- npm ou yarn

### Frontend
- Flutter SDK (v3.10 ou supérieur)
- Dart SDK
- Android Studio / Xcode (pour mobile)
- Chrome / Edge (pour web)

## 🚀 Installation

### Backend

1. **Installer les dépendances** (déjà fait)
```bash
cd Backend
npm install
```

2. **Configurer la base de données PostgreSQL**
   - Créer une base de données : `productivity_db`
   - Créer un fichier `.env` à la racine du dossier `Backend` :

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=productivity_db

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRES_IN=24h

# Server
PORT=3000
NODE_ENV=development
CORS_ORIGIN=http://localhost:8080
```

3. **Démarrer le serveur**
```bash
npm run start:dev
```

Le serveur sera accessible sur `http://localhost:3000/api`

### Frontend

1. **Installer les dépendances** (déjà fait)
```bash
cd FrontEndFlutter
flutter pub get
```

2. **Générer le code** (pour injectable, json_serializable, etc.)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. **Configurer l'URL de l'API** (optionnel)
   - Modifier `lib/core/config/app_config.dart` si nécessaire
   - Ou utiliser des variables d'environnement lors du build :
```bash
flutter run --dart-define=API_BASE_URL=http://localhost:3000/api
```

4. **Lancer l'application**
```bash
# Mobile
flutter run

# Web
flutter run -d chrome

# iOS (sur Mac)
flutter run -d ios

# Android
flutter run -d android
```

## 📁 Structure des Projets

### Backend Structure
```
Backend/
├── src/
│   ├── main.ts                 # Point d'entrée
│   ├── app.module.ts            # Module racine
│   ├── config/                  # Configuration
│   ├── auth/                    # Authentification
│   ├── sessions/                # Sessions de travail
│   ├── projects/                # Projets
│   ├── tasks/                   # Tâches
│   ├── habits/                  # Habitudes
│   ├── capsules/                # Capsules/Mémoires
│   ├── circle/                  # Cercle privé
│   └── common/                  # Code partagé
```

### Frontend Structure
```
FrontEndFlutter/
├── lib/
│   ├── main.dart                # Point d'entrée
│   ├── core/                    # Infrastructure
│   ├── features/                # Modules fonctionnels
│   │   ├── auth/
│   │   ├── sessions/
│   │   ├── projects/
│   │   ├── tasks/
│   │   ├── habits/
│   │   ├── capsules/
│   │   └── circle/
│   └── shared/                  # Composants partagés
```

## 🔧 Commandes Utiles

### Backend

```bash
# Développement avec hot reload
npm run start:dev

# Production
npm run start:prod

# Tests
npm run test
npm run test:e2e

# Linting
npm run lint

# Formatage
npm run format

# Migrations TypeORM
npm run migration:generate -- -n MigrationName
npm run migration:run
npm run migration:revert
```

### Frontend

```bash
# Installer les dépendances
flutter pub get

# Générer le code
flutter pub run build_runner build
flutter pub run build_runner watch  # Mode watch

# Analyser le code
flutter analyze

# Tests
flutter test

# Build
flutter build apk          # Android APK
flutter build ios          # iOS
flutter build web          # Web

# Nettoyer
flutter clean
```

## 📚 Documentation

- **Architecture complète** : Voir `ARCHITECTURE.md`
- **Structure détaillée** : Voir `STRUCTURE.md`
- **API Backend** : Accessible sur `http://localhost:3000/api` (Swagger à configurer)

## 🎯 Prochaines Étapes

1. **Créer les entités TypeORM** dans le backend
2. **Créer les DTOs** pour chaque module
3. **Implémenter les services et repositories**
4. **Créer les entités domain** dans le frontend
5. **Implémenter les datasources et repositories**
6. **Créer les use cases et BLoCs**
7. **Développer l'interface utilisateur**

## ⚠️ Notes Importantes

- Les fichiers créés contiennent des **TODOs** pour guider l'implémentation
- L'architecture est prête mais le code fonctionnel doit être implémenté
- Assurez-vous de configurer correctement les variables d'environnement
- En production, désactivez `synchronize: true` dans la config TypeORM et utilisez les migrations

## 🐛 Dépannage

### Backend ne démarre pas
- Vérifiez que PostgreSQL est démarré
- Vérifiez les variables d'environnement dans `.env`
- Vérifiez que le port 3000 n'est pas utilisé

### Frontend ne se connecte pas au backend
- Vérifiez que le backend est démarré
- Vérifiez l'URL dans `app_config.dart`
- Vérifiez les paramètres CORS dans le backend

### Erreurs de génération de code
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📞 Support

Pour toute question ou problème, consultez :
- La documentation NestJS : https://docs.nestjs.com
- La documentation Flutter : https://flutter.dev/docs
- Le document ARCHITECTURE.md pour les détails techniques
