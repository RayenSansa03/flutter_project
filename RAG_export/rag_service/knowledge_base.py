"""
Knowledge base with sample task templates for the RAG system.
This provides context for generating relevant to-do lists.
"""

TASK_TEMPLATES = [
    {
        "category": "Développement Web",
        "prompt": "créer une application web moderne",
        "tasks": [
            "Définir les fonctionnalités principales de l'application",
            "Choisir la stack technologique (frontend, backend, base de données)",
            "Créer la structure du projet et initialiser les dépôts Git",
            "Développer l'interface utilisateur (UI/UX)",
            "Implémenter le backend et les APIs",
            "Configurer la base de données et les modèles",
            "Ajouter l'authentification et la sécurité",
            "Tester l'application (tests unitaires et d'intégration)",
            "Déployer l'application sur un serveur",
            "Documenter le code et créer un guide utilisateur"
        ]
    },
    {
        "category": "Apprentissage",
        "prompt": "apprendre Python pour la data science",
        "tasks": [
            "Installer Python et configurer l'environnement (Anaconda/Jupyter)",
            "Apprendre les bases de Python (variables, boucles, fonctions)",
            "Maîtriser NumPy pour le calcul numérique",
            "Étudier Pandas pour la manipulation de données",
            "Apprendre Matplotlib et Seaborn pour la visualisation",
            "Comprendre les statistiques de base",
            "Suivre un cours sur le machine learning (scikit-learn)",
            "Réaliser un projet pratique avec un dataset réel",
            "Apprendre les bases du deep learning (TensorFlow/PyTorch)",
            "Créer un portfolio avec vos projets"
        ]
    },
    {
        "category": "Organisation d'événement",
        "prompt": "organiser une conférence technique",
        "tasks": [
            "Définir le thème et les objectifs de la conférence",
            "Établir un budget prévisionnel",
            "Choisir la date et réserver le lieu",
            "Créer un site web pour l'événement",
            "Identifier et contacter les speakers potentiels",
            "Mettre en place un système d'inscription",
            "Planifier la communication et le marketing",
            "Organiser la logistique (restauration, matériel AV)",
            "Préparer les supports et badges pour les participants",
            "Assurer le suivi post-événement et collecter les feedbacks"
        ]
    },
    {
        "category": "Projet Mobile",
        "prompt": "développer une application mobile",
        "tasks": [
            "Définir les fonctionnalités et le public cible",
            "Choisir la plateforme (iOS, Android, ou cross-platform)",
            "Créer les wireframes et maquettes UI/UX",
            "Configurer l'environnement de développement",
            "Développer les écrans principaux de l'application",
            "Implémenter la navigation entre les écrans",
            "Intégrer les APIs et services backend",
            "Ajouter la gestion des données locales",
            "Tester sur différents appareils et tailles d'écran",
            "Publier sur App Store / Google Play Store"
        ]
    },
    {
        "category": "Business",
        "prompt": "lancer une startup",
        "tasks": [
            "Valider l'idée avec une étude de marché",
            "Créer un business plan détaillé",
            "Définir le business model et les sources de revenus",
            "Constituer l'équipe fondatrice",
            "Enregistrer l'entreprise et gérer les aspects légaux",
            "Développer un MVP (Minimum Viable Product)",
            "Rechercher des financements (investisseurs, subventions)",
            "Créer une stratégie marketing et communication",
            "Lancer le produit auprès des premiers clients",
            "Itérer selon les retours utilisateurs"
        ]
    },
    {
        "category": "Data Science",
        "prompt": "créer un modèle de machine learning",
        "tasks": [
            "Définir le problème et les objectifs du modèle",
            "Collecter et explorer les données (EDA)",
            "Nettoyer et prétraiter les données",
            "Sélectionner les features pertinentes",
            "Diviser les données (train/validation/test)",
            "Choisir et entraîner plusieurs algorithmes",
            "Optimiser les hyperparamètres",
            "Évaluer les performances du modèle",
            "Déployer le modèle en production",
            "Monitorer et maintenir le modèle"
        ]
    },
    {
        "category": "DevOps",
        "prompt": "mettre en place un pipeline CI/CD",
        "tasks": [
            "Choisir les outils CI/CD (Jenkins, GitLab CI, GitHub Actions)",
            "Configurer le repository et les branches",
            "Créer les scripts de build automatisés",
            "Mettre en place les tests automatisés",
            "Configurer l'analyse de code (linting, security)",
            "Créer les environnements (dev, staging, production)",
            "Automatiser le déploiement",
            "Configurer le monitoring et les alertes",
            "Documenter le pipeline",
            "Former l'équipe aux nouveaux processus"
        ]
    },
    {
        "category": "Design",
        "prompt": "créer une identité visuelle pour une marque",
        "tasks": [
            "Analyser la marque et ses valeurs",
            "Rechercher les tendances et la concurrence",
            "Créer un moodboard et définir la direction artistique",
            "Concevoir le logo et ses variations",
            "Définir la palette de couleurs",
            "Choisir les typographies",
            "Créer les éléments graphiques (icônes, patterns)",
            "Développer une charte graphique complète",
            "Créer des mockups d'application",
            "Préparer les fichiers pour la production"
        ]
    },
    # English Templates
    {
        "category": "Web Development",
        "prompt": "create a modern web application",
        "tasks": [
            "Define the main features of the application",
            "Choose the technology stack (frontend, backend, database)",
            "Create project structure and initialize Git repositories",
            "Develop the user interface (UI/UX)",
            "Implement the backend and APIs",
            "Configure the database and models",
            "Add authentication and security",
            "Test the application (unit and integration tests)",
            "Deploy the application to a server",
            "Document the code and create a user guide"
        ]
    },
    {
        "category": "Learning",
        "prompt": "learn Python for data science",
        "tasks": [
            "Install Python and set up the environment (Anaconda/Jupyter)",
            "Learn Python basics (variables, loops, functions)",
            "Master NumPy for numerical computing",
            "Study Pandas for data manipulation",
            "Learn Matplotlib and Seaborn for visualization",
            "Understand basic statistics",
            "Take a course on machine learning (scikit-learn)",
            "Complete a practical project with a real dataset",
            "Learn deep learning basics (TensorFlow/PyTorch)",
            "Create a portfolio with your projects"
        ]
    },
    {
        "category": "Mobile Development",
        "prompt": "develop a mobile application",
        "tasks": [
            "Define features and target audience",
            "Choose the platform (iOS, Android, or cross-platform)",
            "Create wireframes and UI/UX mockups",
            "Set up the development environment",
            "Develop the main screens of the application",
            "Implement navigation between screens",
            "Integrate APIs and backend services",
            "Add local data management",
            "Test on different devices and screen sizes",
            "Publish to App Store / Google Play Store"
        ]
    },
    {
        "category": "Business",
        "prompt": "launch a startup",
        "tasks": [
            "Validate the idea with market research",
            "Create a detailed business plan",
            "Define the business model and revenue streams",
            "Build the founding team",
            "Register the company and handle legal aspects",
            "Develop an MVP (Minimum Viable Product)",
            "Seek funding (investors, grants)",
            "Create a marketing and communication strategy",
            "Launch the product to first customers",
            "Iterate based on user feedback"
        ]
    },
    {
        "category": "Machine Learning",
        "prompt": "create a machine learning model",
        "tasks": [
            "Define the problem and model objectives",
            "Collect and explore data (EDA)",
            "Clean and preprocess the data",
            "Select relevant features",
            "Split the data (train/validation/test)",
            "Choose and train multiple algorithms",
            "Optimize hyperparameters",
            "Evaluate model performance",
            "Deploy the model to production",
            "Monitor and maintain the model"
        ]
    }
]

def get_knowledge_base_text() -> str:
    """
    Convert task templates to text format for embedding in the vector database.
    """
    texts = []
    for template in TASK_TEMPLATES:
        text = f"Catégorie: {template['category']}\n"
        text += f"Exemple de prompt: {template['prompt']}\n"
        text += "Tâches à accomplir:\n"
        for i, task in enumerate(template['tasks'], 1):
            text += f"{i}. {task}\n"
        texts.append(text)
    return texts
