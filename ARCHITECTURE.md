# Architecture de l'Application de Productivité

## Vue d'ensemble

Cette application de productivité personnelle est construite avec une architecture moderne et scalable, utilisant :
- **Frontend** : Flutter (iOS, Android, Web) avec Clean Architecture
- **Backend** : NestJS avec architecture modulaire
- **Base de données** : PostgreSQL avec TypeORM

---

## 1. Architecture Backend (NestJS)

### 1.1 Structure des Modules

Chaque module de fonctionnalité suit le pattern **Module-Controller-Service-Repository** :

```
src/
├── main.ts                          # Point d'entrée de l'application
├── app.module.ts                    # Module racine
├── config/                          # Configuration
│   ├── database.config.ts          # Configuration TypeORM
│   └── app.config.ts               # Configuration générale
│
├── auth/                            # Module d'authentification
│   ├── auth.module.ts
│   ├── auth.controller.ts          # Endpoints: /api/auth/login, /api/auth/register
│   ├── auth.service.ts             # Logique métier d'authentification
│   ├── strategies/                 # Passport strategies
│   │   ├── jwt.strategy.ts
│   │   └── local.strategy.ts
│   ├── dto/                        # Data Transfer Objects
│   │   ├── login.dto.ts
│   │   └── register.dto.ts
│   └── entities/
│       └── user.entity.ts
│
├── sessions/                        # Module Sessions de travail
│   ├── sessions.module.ts
│   ├── sessions.controller.ts      # CRUD sessions
│   ├── sessions.service.ts         # Logique métier sessions
│   ├── sessions.repository.ts      # Accès données (TypeORM Repository)
│   ├── dto/
│   │   ├── create-session.dto.ts
│   │   ├── update-session.dto.ts
│   │   └── session-response.dto.ts
│   └── entities/
│       └── session.entity.ts
│
├── projects/                        # Module Projets
│   ├── projects.module.ts
│   ├── projects.controller.ts
│   ├── projects.service.ts
│   ├── projects.repository.ts
│   ├── dto/
│   │   ├── create-project.dto.ts
│   │   ├── update-project.dto.ts
│   │   └── project-response.dto.ts
│   └── entities/
│       └── project.entity.ts
│
├── tasks/                           # Module Tâches
│   ├── tasks.module.ts
│   ├── tasks.controller.ts
│   ├── tasks.service.ts
│   ├── tasks.repository.ts
│   ├── dto/
│   │   ├── create-task.dto.ts
│   │   ├── update-task.dto.ts
│   │   └── task-response.dto.ts
│   └── entities/
│       └── task.entity.ts
│
├── habits/                          # Module Habitudes
│   ├── habits.module.ts
│   ├── habits.controller.ts
│   ├── habits.service.ts
│   ├── habits.repository.ts
│   ├── dto/
│   │   ├── create-habit.dto.ts
│   │   ├── update-habit.dto.ts
│   │   └── habit-response.dto.ts
│   └── entities/
│       └── habit.entity.ts
│
├── capsules/                        # Module Capsules (notes/mémoires)
│   ├── capsules.module.ts
│   ├── capsules.controller.ts
│   ├── capsules.service.ts
│   ├── capsules.repository.ts
│   ├── dto/
│   │   ├── create-capsule.dto.ts
│   │   ├── update-capsule.dto.ts
│   │   └── capsule-response.dto.ts
│   └── entities/
│       └── capsule.entity.ts
│
├── circle/                          # Module Cercle privé (réseau social)
│   ├── circle.module.ts
│   ├── circle.controller.ts
│   ├── circle.service.ts
│   ├── circle.repository.ts
│   ├── dto/
│   │   ├── create-circle.dto.ts
│   │   ├── invite-member.dto.ts
│   │   └── circle-response.dto.ts
│   └── entities/
│       ├── circle.entity.ts
│       └── circle-member.entity.ts
│
└── common/                          # Code partagé
    ├── decorators/
    │   └── current-user.decorator.ts
    ├── guards/
    │   └── auth.guard.ts           # JWT Guard
    ├── filters/
    │   └── http-exception.filter.ts # Gestion erreurs globales
    ├── interceptors/
    │   ├── logging.interceptor.ts
    │   └── transform.interceptor.ts
    ├── pipes/
    │   └── validation.pipe.ts
    └── utils/
        └── helpers.ts
```

### 1.2 Flux de Données Backend

```
Client (Flutter) 
    ↓ HTTP Request
Controller (Endpoint)
    ↓ Validation DTO
Service (Logique métier)
    ↓ Appel Repository
Repository (TypeORM)
    ↓ Query SQL
PostgreSQL Database
```

### 1.3 Relations Base de Données

#### Entités Principales et Relations

1. **User** (Utilisateur)
   - Relations One-to-Many avec : Sessions, Projects, Tasks, Habits, Capsules
   - Relations Many-to-Many avec : Circle (via CircleMember)

2. **Session** (Session de travail)
   - Many-to-One avec : User
   - Champs : startTime, endTime, duration, type, notes

3. **Project** (Projet)
   - Many-to-One avec : User
   - One-to-Many avec : Tasks
   - Champs : name, description, status, startDate, endDate

4. **Task** (Tâche)
   - Many-to-One avec : User, Project (optionnel)
   - Champs : title, description, status, priority, dueDate, completedAt

5. **Habit** (Habitude)
   - Many-to-One avec : User
   - One-to-Many avec : HabitTracking (suivi quotidien)
   - Champs : name, description, frequency, streak, targetDays

6. **Capsule** (Capsule/Mémoire)
   - Many-to-One avec : User
   - Champs : title, content, type, scheduledDate, isOpened

7. **Circle** (Cercle privé)
   - Many-to-Many avec : User (via CircleMember)
   - Champs : name, description, isPrivate

8. **CircleMember** (Membre du cercle)
   - Many-to-One avec : User, Circle
   - Champs : role, joinedAt

### 1.4 Sécurité et Authentification

- **JWT** : Tokens pour authentification stateless
- **Passport** : Strategies pour JWT et Local
- **Guards** : Protection des routes avec @UseGuards(AuthGuard)
- **Bcrypt** : Hashage des mots de passe
- **Validation** : class-validator pour validation des DTOs

### 1.5 API Endpoints Structure

```
/api/auth
  POST   /login
  POST   /register
  GET    /profile
  PUT    /profile

/api/sessions
  GET    /                    # Liste sessions utilisateur
  POST   /                    # Créer session
  GET    /:id                 # Détails session
  PUT    /:id                 # Modifier session
  DELETE /:id                 # Supprimer session

/api/projects
  GET    /                    # Liste projets
  POST   /                    # Créer projet
  GET    /:id                 # Détails projet
  PUT    /:id                 # Modifier projet
  DELETE /:id                 # Supprimer projet
  GET    /:id/tasks           # Tâches du projet

/api/tasks
  GET    /                    # Liste tâches
  POST   /                    # Créer tâche
  GET    /:id                 # Détails tâche
  PUT    /:id                 # Modifier tâche
  DELETE /:id                 # Supprimer tâche

/api/habits
  GET    /                    # Liste habitudes
  POST   /                    # Créer habitude
  GET    /:id                 # Détails habitude
  PUT    /:id                 # Modifier habitude
  DELETE /:id                 # Supprimer habitude
  POST   /:id/track           # Enregistrer suivi

/api/capsules
  GET    /                    # Liste capsules
  POST   /                    # Créer capsule
  GET    /:id                 # Détails capsule
  PUT    /:id                 # Modifier capsule
  DELETE /:id                 # Supprimer capsule
  POST   /:id/open            # Ouvrir capsule

/api/circle
  GET    /                    # Liste cercles
  POST   /                    # Créer cercle
  GET    /:id                 # Détails cercle
  PUT    /:id                 # Modifier cercle
  DELETE /:id                 # Supprimer cercle
  POST   /:id/invite          # Inviter membre
  DELETE /:id/members/:userId # Retirer membre
```

---

## 2. Architecture Frontend (Flutter)

### 2.1 Clean Architecture Structure

L'application Flutter suit le pattern **Clean Architecture** avec séparation en 3 couches :

```
lib/
├── main.dart                    # Point d'entrée
│
├── core/                        # Code partagé et infrastructure
│   ├── config/
│   │   ├── app_config.dart     # Configuration app
│   │   └── di_config.dart      # Dependency Injection (GetIt)
│   ├── constants/
│   │   ├── api_constants.dart  # URLs API, endpoints
│   │   └── app_constants.dart  # Constantes générales
│   ├── network/
│   │   ├── api_client.dart     # Client HTTP (Dio)
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart
│   │   │   └── error_interceptor.dart
│   │   └── api_response.dart   # Modèle réponse API
│   ├── errors/
│   │   ├── exceptions.dart     # Exceptions personnalisées
│   │   └── failures.dart       # Failures (Either pattern)
│   ├── utils/
│   │   ├── validators.dart
│   │   └── formatters.dart
│   └── widgets/
│       ├── loading_widget.dart
│       └── error_widget.dart
│
├── features/                    # Modules fonctionnels
│   ├── auth/
│   │   ├── data/               # Couche Data
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/             # Couche Domain
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── register_usecase.dart
│   │   │       └── logout_usecase.dart
│   │   └── presentation/       # Couche Presentation
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── register_page.dart
│   │       └── widgets/
│   │           └── auth_form_widget.dart
│   │
│   ├── sessions/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── sessions_remote_datasource.dart
│   │   │   │   └── sessions_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── session_model.dart
│   │   │   └── repositories/
│   │   │       └── sessions_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── session_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── sessions_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_sessions_usecase.dart
│   │   │       ├── create_session_usecase.dart
│   │   │       ├── update_session_usecase.dart
│   │   │       └── delete_session_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── sessions_bloc.dart
│   │       │   ├── sessions_event.dart
│   │       │   └── sessions_state.dart
│   │       ├── pages/
│   │       │   ├── sessions_list_page.dart
│   │       │   ├── session_detail_page.dart
│   │       │   └── create_session_page.dart
│   │       └── widgets/
│   │           └── session_card_widget.dart
│   │
│   ├── projects/               # Structure identique à sessions
│   ├── tasks/                  # Structure identique à sessions
│   ├── habits/                 # Structure identique à sessions
│   ├── capsules/               # Structure identique à sessions
│   └── circle/                 # Structure identique à sessions
│
└── shared/                     # Composants partagés
    ├── themes/
    │   ├── app_theme.dart
    │   └── color_scheme.dart
    └── widgets/
        ├── app_button.dart
        ├── app_text_field.dart
        └── app_card.dart
```

### 2.2 Flux de Données Frontend (Clean Architecture)

```
Presentation Layer (UI)
    ↓ Events
Bloc (State Management)
    ↓ UseCase
Domain Layer (Business Logic)
    ↓ Repository Interface
Data Layer
    ↓ Remote/Local DataSource
API Client / Local Storage
    ↓ HTTP / Cache
Backend API / Hive/SharedPreferences
```

### 2.3 Gestion d'État (BLoC Pattern)

Chaque feature utilise **flutter_bloc** pour la gestion d'état :

- **Events** : Actions utilisateur (LoadSessions, CreateSession, etc.)
- **States** : États de l'UI (Loading, Loaded, Error)
- **Bloc** : Logique de transformation Events → States

### 2.4 Routing (GoRouter)

Navigation centralisée avec **go_router** :

```dart
Routes:
  /login
  /register
  /home
  /sessions
  /sessions/:id
  /projects
  /projects/:id
  /tasks
  /tasks/:id
  /habits
  /habits/:id
  /capsules
  /capsules/:id
  /circle
  /circle/:id
```

### 2.5 Dependency Injection (GetIt + Injectable)

- **GetIt** : Service locator pour DI
- **Injectable** : Code generation pour enregistrement automatique
- Configuration dans `core/config/di_config.dart`

### 2.6 Local Storage

- **Hive** : Stockage local structuré (cache, données offline)
- **SharedPreferences** : Préférences utilisateur simples
- **Stratégie** : Cache-first avec synchronisation backend

---

## 3. Communication Frontend-Backend

### 3.1 API Client (Dio)

- **Base URL** : Configurable via environnement
- **Intercepteurs** :
  - Auth Interceptor : Ajout token JWT automatique
  - Error Interceptor : Gestion erreurs centralisée
  - Logging Interceptor : Logs requêtes/réponses (dev)

### 3.2 Format de Réponse API

```json
{
  "success": true,
  "data": { ... },
  "message": "Success message"
}
```

### 3.3 Gestion des Erreurs

- **Network Errors** : Timeout, connexion perdue
- **API Errors** : 400, 401, 403, 404, 500
- **Validation Errors** : Erreurs de validation DTO
- **Mapping** : Conversion en Failures (Either pattern)

---

## 4. Base de Données PostgreSQL

### 4.1 Schéma de Base de Données

#### Tables Principales

1. **users**
   - id (UUID, PK)
   - email (VARCHAR, UNIQUE)
   - password (VARCHAR, hashed)
   - first_name (VARCHAR, nullable)
   - last_name (VARCHAR, nullable)
   - created_at (TIMESTAMP)
   - updated_at (TIMESTAMP)

2. **sessions**
   - id (UUID, PK)
   - user_id (UUID, FK → users)
   - start_time (TIMESTAMP)
   - end_time (TIMESTAMP, nullable)
   - duration (INTEGER, minutes)
   - type (VARCHAR)
   - notes (TEXT, nullable)
   - created_at (TIMESTAMP)
   - updated_at (TIMESTAMP)

3. **projects**
   - id (UUID, PK)
   - user_id (UUID, FK → users)
   - name (VARCHAR)
   - description (TEXT, nullable)
   - status (VARCHAR: 'active', 'completed', 'archived')
   - start_date (DATE, nullable)
   - end_date (DATE, nullable)
   - created_at (TIMESTAMP)
   - updated_at (TIMESTAMP)

4. **tasks**
   - id (UUID, PK)
   - user_id (UUID, FK → users)
   - project_id (UUID, FK → projects, nullable)
   - title (VARCHAR)
   - description (TEXT, nullable)
   - status (VARCHAR: 'todo', 'in_progress', 'completed')
   - priority (VARCHAR: 'low', 'medium', 'high')
   - due_date (TIMESTAMP, nullable)
   - completed_at (TIMESTAMP, nullable)
   - created_at (TIMESTAMP)
   - updated_at (TIMESTAMP)

5. **habits**
   - id (UUID, PK)
   - user_id (UUID, FK → users)
   - name (VARCHAR)
   - description (TEXT, nullable)
   - frequency (VARCHAR: 'daily', 'weekly', 'custom')
   - target_days (INTEGER)
   - current_streak (INTEGER, default: 0)
   - created_at (TIMESTAMP)
   - updated_at (TIMESTAMP)

6. **habit_tracking**
   - id (UUID, PK)
   - habit_id (UUID, FK → habits)
   - date (DATE)
   - completed (BOOLEAN)
   - notes (TEXT, nullable)
   - created_at (TIMESTAMP)

7. **capsules**
- id (UUID, PK)
   - user_id (UUID, FK → users)
   - title (VARCHAR)
- content (TEXT)
   - type (VARCHAR: 'note', 'memory', 'goal')
   - scheduled_date (TIMESTAMP, nullable)
   - is_opened (BOOLEAN, default: false)
   - opened_at (TIMESTAMP, nullable)
   - created_at (TIMESTAMP)
   - updated_at (TIMESTAMP)

8. **circles**
- id (UUID, PK)
   - name (VARCHAR)
   - description (TEXT, nullable)
   - is_private (BOOLEAN, default: true)
   - created_by (UUID, FK → users)
   - created_at (TIMESTAMP)
   - updated_at (TIMESTAMP)

9. **circle_members**
   - id (UUID, PK)
   - circle_id (UUID, FK → circles)
   - user_id (UUID, FK → users)
   - role (VARCHAR: 'owner', 'admin', 'member')
   - joined_at (TIMESTAMP)
   - UNIQUE(circle_id, user_id)

### 4.2 Indexes pour Performance

- `users.email` : Index unique
- `sessions.user_id` : Index pour requêtes fréquentes
- `tasks.user_id`, `tasks.project_id` : Indexes
- `habits.user_id` : Index
- `habit_tracking.habit_id`, `habit_tracking.date` : Index composite
- `capsules.user_id`, `capsules.scheduled_date` : Indexes
- `circle_members.circle_id`, `circle_members.user_id` : Indexes

### 4.3 Migrations TypeORM

- Migrations versionnées dans `src/migrations/`
- Commandes : `migration:generate`, `migration:run`, `migration:revert`

---

## 5. Bonnes Pratiques et Scalabilité

### 5.1 Backend

- **Validation** : DTOs avec class-validator
- **Error Handling** : Exception filters globaux
- **Logging** : Interceptors pour logging requêtes
- **Testing** : Unit tests (Services), E2E tests (Controllers)
- **Documentation** : Swagger/OpenAPI (à ajouter)
- **Environment** : Variables d'environnement via @nestjs/config

### 5.2 Frontend

- **State Management** : BLoC pattern pour séparation claire
- **Error Handling** : Either pattern (Success/Failure)
- **Caching** : Stratégie cache-first avec Hive
- **Offline Support** : Synchronisation automatique au retour connexion
- **Testing** : Unit tests (UseCases), Widget tests (UI)
- **Code Generation** : json_serializable, freezed, injectable

### 5.3 Performance

- **Backend** : Pagination pour listes, lazy loading relations
- **Frontend** : Lazy loading des modules, images optimisées
- **Database** : Indexes sur colonnes fréquemment requêtées
- **Caching** : Cache Redis (optionnel, future amélioration)

### 5.4 Sécurité

- **Backend** : JWT avec expiration, refresh tokens (à implémenter)
- **Frontend** : Stockage sécurisé des tokens (flutter_secure_storage)
- **Validation** : Validation côté client et serveur
- **CORS** : Configuration stricte en production

---

## 6. Compatibilité Web et Mobile

### 6.1 Responsive Design

- **Breakpoints** : Mobile (< 600px), Tablet (600-1024px), Desktop (> 1024px)
- **Layouts adaptatifs** : Utilisation de LayoutBuilder
- **Navigation** : Navigation drawer (mobile) vs sidebar (desktop)

### 6.2 Plateformes Spécifiques

- **iOS** : Respect des guidelines Apple (navigation, design)
- **Android** : Material Design 3
- **Web** : Optimisation pour navigateurs modernes

---

## 7. Déploiement et Environnements

### 7.1 Environnements

- **Development** : Local avec hot reload
- **Staging** : Environnement de test
- **Production** : Environnement de production

### 7.2 Configuration

- **Backend** : Variables d'environnement (.env)
- **Frontend** : Configuration par environnement (dev/staging/prod)

---

## 8. Prochaines Étapes (Améliorations Futures)

1. **Notifications Push** : Firebase Cloud Messaging
2. **Analytics** : Suivi d'utilisation
3. **Backup/Restore** : Export/import données
4. **Collaboration** : Partage de projets/tâches
5. **Graphiques** : Visualisation statistiques
6. **Recherche** : Recherche full-text
7. **Export** : Export PDF/Excel
8. **Intégrations** : Calendrier, email, etc.

---

## Conclusion

Cette architecture fournit une base solide, scalable et maintenable pour l'application de productivité. La séparation claire des responsabilités facilite le développement, les tests et la maintenance future.
