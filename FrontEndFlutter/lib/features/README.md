# Features Module

Ce module contient tous les modules fonctionnels de l'application, organisés selon l'architecture Clean Architecture.

## Structure par feature

Chaque feature suit la structure suivante :

### data/
- **datasources/** : Sources de données (Remote API, Local Storage)
- **models/** : Modèles de données (DTOs)
- **repositories/** : Implémentations des repositories

### domain/
- **entities/** : Entités métier (sans dépendances)
- **repositories/** : Interfaces des repositories
- **usecases/** : Cas d'usage métier

### presentation/
- **bloc/** : Gestion d'état avec BLoC
- **pages/** : Pages/écrans de l'application
- **widgets/** : Widgets spécifiques à la feature

## Features disponibles

- **auth** : Authentification utilisateur
- **sessions** : Gestion des sessions de travail
- **projects** : Gestion des projets
- **tasks** : Gestion des tâches
- **habits** : Suivi des habitudes
- **capsules** : Capsules temporelles
- **circle** : Cercle privé
