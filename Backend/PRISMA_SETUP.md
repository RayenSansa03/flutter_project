# Configuration Prisma - Guide Complet

## ✅ Installation et Configuration Effectuées

### 1. Installation de Prisma
```bash
npm install prisma @prisma/client --save-dev
```
**Explication** : Installe Prisma CLI (outils de développement) et Prisma Client (bibliothèque pour interagir avec la base de données).

### 2. Initialisation de Prisma
```bash
npx prisma init
```
**Explication** : Crée la structure Prisma dans le projet :
- `prisma/schema.prisma` : Schéma de la base de données
- `prisma.config.ts` : Configuration Prisma (connexion DB)
- Met à jour `.env` avec `DATABASE_URL` (si non existant)

### 3. Configuration du Datasource PostgreSQL

Le fichier `prisma/schema.prisma` a été configuré avec :
```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
}
```

**Note** : Dans Prisma 7+, l'URL de connexion est définie dans `prisma.config.ts` (déjà configuré) et non plus dans `schema.prisma`.

### 4. Génération de Prisma Client
```bash
npx prisma generate
```
**Explication** : Génère le client TypeScript Prisma basé sur votre schéma. Ce client est utilisé dans votre code NestJS pour interagir avec la base de données.

### 5. Prisma Studio (Interface Graphique)

Prisma Studio est inclus avec Prisma. Pour l'utiliser :
```bash
npm run prisma:studio
```
ou
```bash
npx prisma studio
```

**Explication** : Lance une interface web (généralement sur http://localhost:5555) pour visualiser et éditer les données de votre base de données.

## 📁 Fichiers Créés/Modifiés

### `.env`
Contient la configuration de connexion PostgreSQL :
```env
DATABASE_URL="postgresql://amine:amine@localhost:5432/project_flutter?schema=public"
```

### `prisma/schema.prisma`
Schéma Prisma (modèles de données à définir ici)

### `prisma.config.ts`
Configuration Prisma avec l'URL de connexion

### `package.json`
Scripts ajoutés :
- `prisma:generate` : Régénère Prisma Client
- `prisma:studio` : Lance Prisma Studio
- `prisma:migrate` : Crée et applique une migration
- `prisma:migrate:deploy` : Applique les migrations en production
- `prisma:db:pull` : Introspecte la DB existante
- `prisma:db:push` : Pousse le schéma vers la DB (dev uniquement)

## 🚀 Utilisation dans NestJS

### Créer un Service Prisma

```typescript
import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
```

### Utiliser Prisma dans un Module

```typescript
import { Module } from '@nestjs/common';
import { PrismaService } from './prisma.service';
import { UsersService } from './users.service';

@Module({
  providers: [PrismaService, UsersService],
  exports: [PrismaService],
})
export class DatabaseModule {}
```

### Exemple d'utilisation dans un Service

```typescript
import { Injectable } from '@nestjs/common';
import { PrismaService } from './prisma.service';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async findAll() {
    return this.prisma.user.findMany();
  }

  async create(data: any) {
    return this.prisma.user.create({ data });
  }
}
```

## 📝 Prochaines Étapes

1. **Définir vos modèles** dans `prisma/schema.prisma`
   ```prisma
   model User {
     id        String   @id @default(uuid())
     email     String   @unique
     name      String?
     createdAt DateTime @default(now())
     updatedAt DateTime @updatedAt
   }
   ```

2. **Créer une migration** :
   ```bash
   npm run prisma:migrate
   ```
   Cela va :
   - Créer un fichier de migration
   - Appliquer les changements à la base de données
   - Régénérer Prisma Client

3. **Vérifier avec Prisma Studio** :
   ```bash
   npm run prisma:studio
   ```

## 🔧 Commandes Utiles

| Commande | Description |
|----------|-------------|
| `npm run prisma:generate` | Régénère Prisma Client après modification du schéma |
| `npm run prisma:studio` | Ouvre l'interface graphique Prisma Studio |
| `npm run prisma:migrate` | Crée et applique une nouvelle migration |
| `npm run prisma:db:pull` | Introspecte une base de données existante et met à jour le schéma |
| `npm run prisma:db:push` | Pousse le schéma vers la DB sans créer de migration (dev uniquement) |
| `npx prisma format` | Formate le fichier schema.prisma |
| `npx prisma validate` | Valide le schéma Prisma |

## ⚠️ Notes Importantes

- **Prisma 7+** : L'URL de connexion est dans `prisma.config.ts`, pas dans `schema.prisma`
- **Après chaque modification du schéma** : Exécutez `npm run prisma:generate`
- **En production** : Utilisez `prisma migrate deploy` pour appliquer les migrations
- **Prisma Studio** : Accessible sur http://localhost:5555 par défaut

## 🔗 Ressources

- [Documentation Prisma](https://www.prisma.io/docs)
- [Prisma avec NestJS](https://docs.nestjs.com/recipes/prisma)
- [Prisma Migrate](https://www.prisma.io/docs/concepts/components/prisma-migrate)
