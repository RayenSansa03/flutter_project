# Guide de Test - Authentification avec Swagger

## 🚀 Démarrage du Serveur

```bash
cd Backend
npm run start:dev
```

Le serveur sera accessible sur :
- **API** : http://localhost:3000/api
- **Swagger** : http://localhost:3000/api/docs

## 📋 Prérequis

1. **PostgreSQL doit être démarré** avec la base de données `project_flutter`
2. **La table `users` doit exister** (créée via TypeORM ou Prisma)

## 🔐 Endpoints Disponibles

### 1. POST /api/auth/register - Inscription

**Description** : Crée un nouveau compte utilisateur

**Body (JSON)** :
```json
{
  "email": "user@example.com",
  "password": "password123",
  "firstName": "John",
  "lastName": "Doe"
}
```

**Réponse (201 Created)** :
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe"
  }
}
```

**Erreurs possibles** :
- `409 Conflict` : Email déjà utilisé
- `400 Bad Request` : Données invalides (email invalide, mot de passe trop court)

### 2. POST /api/auth/login - Connexion

**Description** : Authentifie un utilisateur existant

**Body (JSON)** :
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Réponse (200 OK)** :
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe"
  }
}
```

**Erreurs possibles** :
- `401 Unauthorized` : Email ou mot de passe incorrect
- `400 Bad Request` : Données invalides

### 3. GET /api/auth/profile - Profil Utilisateur

**Description** : Récupère le profil de l'utilisateur connecté

**Headers requis** :
```
Authorization: Bearer <access_token>
```

**Réponse (200 OK)** :
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "createdAt": "2024-01-01T00:00:00.000Z",
  "updatedAt": "2024-01-01T00:00:00.000Z"
}
```

**Erreurs possibles** :
- `401 Unauthorized` : Token invalide ou manquant

## 🧪 Test avec Swagger UI

### Étape 1 : Accéder à Swagger
1. Ouvrez votre navigateur
2. Allez sur http://localhost:3000/api/docs

### Étape 2 : Tester l'inscription
1. Cliquez sur `POST /api/auth/register`
2. Cliquez sur "Try it out"
3. Modifiez le body JSON avec vos données :
   ```json
   {
     "email": "test@example.com",
     "password": "test123",
     "firstName": "Test",
     "lastName": "User"
   }
   ```
4. Cliquez sur "Execute"
5. **Copiez le `access_token`** de la réponse

### Étape 3 : Authentifier dans Swagger
1. En haut à droite, cliquez sur le bouton **"Authorize"** 🔒
2. Dans le champ "Value", collez votre `access_token` (sans "Bearer ")
3. Cliquez sur "Authorize"
4. Cliquez sur "Close"

### Étape 4 : Tester le profil
1. Cliquez sur `GET /api/auth/profile`
2. Cliquez sur "Try it out"
3. Cliquez sur "Execute"
4. Vous devriez voir votre profil utilisateur

### Étape 5 : Tester la connexion
1. Cliquez sur `POST /api/auth/login`
2. Utilisez les mêmes identifiants que l'inscription
3. Vous devriez recevoir un nouveau token

## 🧪 Test avec cURL

### Inscription
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "test123",
    "firstName": "Test",
    "lastName": "User"
  }'
```

### Connexion
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "test123"
  }'
```

### Profil (avec token)
```bash
curl -X GET http://localhost:3000/api/auth/profile \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## 🔍 Vérification de la Base de Données

Pour vérifier que l'utilisateur a bien été créé :

```sql
-- Se connecter à PostgreSQL
psql -U amine -d project_flutter

-- Voir les utilisateurs
SELECT id, email, "firstName", "lastName", "createdAt" FROM users;

-- Vérifier que le mot de passe est hashé
SELECT id, email, password FROM users;
```

## ⚠️ Notes Importantes

1. **Mot de passe hashé** : Les mots de passe sont hashés avec bcrypt (10 rounds)
2. **Token JWT** : Les tokens expirent après 24h (configurable dans `.env`)
3. **Sécurité** : Le mot de passe n'est jamais retourné dans les réponses
4. **Validation** : Tous les champs sont validés avec class-validator
5. **Swagger persist** : L'autorisation dans Swagger est persistée (reste après rafraîchissement)

## 🐛 Dépannage

### Erreur : "Email déjà utilisé"
- L'utilisateur existe déjà, utilisez un autre email ou testez la connexion

### Erreur : "401 Unauthorized" sur /profile
- Vérifiez que vous avez bien cliqué sur "Authorize" dans Swagger
- Vérifiez que le token est valide (pas expiré)
- Vérifiez le format : `Bearer <token>` (Swagger ajoute automatiquement "Bearer")

### Erreur : "Cannot connect to database"
- Vérifiez que PostgreSQL est démarré
- Vérifiez les variables d'environnement dans `.env`
- Vérifiez que la base de données `project_flutter` existe

### Erreur : "Table 'users' does not exist"
- Créez la table avec TypeORM ou Prisma
- Ou utilisez `synchronize: true` en développement (dans `database.config.ts`)

## ✅ Checklist de Test

- [ ] Serveur démarré sans erreur
- [ ] Swagger accessible sur /api/docs
- [ ] Inscription fonctionne
- [ ] Connexion fonctionne
- [ ] Profil accessible avec token
- [ ] Erreurs gérées correctement (email existant, mauvais mot de passe)
- [ ] Validation des champs fonctionne
- [ ] Token JWT valide
