# Guide du Système RAG (Retrieval-Augmented Generation)

Ce projet intègre deux services de RAG basés sur Python pour assister l'utilisateur dans la génération de listes de tâches et de plannings quotidiens.

## 🚀 Services Disponibles

Le projet contient deux services distincts situés dans le dossier `/RAG_export` :

1.  **Daily Planner Service (Port 8001)** : Génère des plannings quotidiens détaillés avec heures et durées à partir d'un prompt utilisateur (ex: "Mon programme pour demain").
2.  **To-Do List Service (Port 8000)** : Génère des listes de tâches structurées pour des projets spécifiques (ex: "Créer une application de fitness").

## 🛠️ Prérequis

- **Python 3.10+** installé sur votre machine.
- Une clé API **Groq**.
- Les dépendances Python listées dans les fichiers `requirements.txt`.

## ⚙️ Configuration

Chaque service nécessite un fichier `.env` (ou un fichier au-dessus) contenant votre clé API Groq :
```env
GROQ_API_KEY=votre_cle_ici
```

## 🏃 Comment Démarrer les Services

### 1. Daily Planner Service (Indispensable pour le Planning)
Ouvrez un terminal et exécutez :
```bash
cd RAG_export/daily_planner_service
pip install -r requirements.txt
python main.py
```
Le service sera disponible sur `http://127.0.0.1:8001`.

### 2. To-Do List Service
Ouvrez un autre terminal et exécutez :
```bash
cd RAG_export/rag_service
pip install -r requirements.txt
python main.py
```
Le service sera disponible sur `http://127.0.0.1:8000`.

## 🧠 Comment ça marche ? (Côté Code)

### Architecture
1.  **ChromaDB** : Utilisé comme base de données vectorielle pour stocker et rechercher des informations de contexte (base de connaissances).
2.  **FastAPI** : Framework web pour exposer les endpoints de génération.
3.  **Groq (Llama 3)** : Le modèle de langage (LLM) utilisé pour transformer le contexte récupéré et le prompt utilisateur en un JSON structuré.

### Flux de Données
1.  L'utilisateur envoie un prompt depuis l'application Flutter.
2.  Le service Python reçoit le prompt.
3.  **Retrieval** : Le moteur recherche dans `knowledge_base.py` ou ChromaDB les éléments pertinents.
4.  **Augmentation** : Le prompt est enrichi avec ces informations.
5.  **Generation** : Groq génère une réponse formatée (Tâches, Heures, Durées).
6.  L'application Flutter reçoit le JSON et peuple l'interface.

## 📱 Connexion Flutter
L'application Flutter communique avec ces services via la classe `AppConfig` dans `lib/core/config/app_config.dart`. Par défaut :
- **Web/Desktop** : `http://127.0.0.1:8001`
- **Android Emulator** : `http://10.0.2.2:8001`
