"""
Knowledge base with daily routine and task templates for the Daily Planner RAG.
"""

DAILY_TEMPLATES = [
    {
        "category": "Routine Matinale",
        "prompt": "organiser ma matinée",
        "tasks": [
            "Se réveiller à 7h00",
            "Boire un grand verre d'eau",
            "Faire 15 minutes d'étirements ou yoga",
            "Prendre une douche rapide",
            "Préparer un petit-déjeuner sain",
            "Relire les objectifs de la journée",
            "Éviter les réseaux sociaux avant 9h00"
        ]
    },
    {
        "category": "Travail / Productivité",
        "prompt": "planifier ma journée de travail",
        "tasks": [
            "Identifier les 3 tâches les plus importantes (MITs)",
            "Session de Deep Work (90 min) sur la tâche #1",
            "Pause de 10 minutes (marche ou respiration)",
            "Gérer les e-mails et messages (30 min)",
            "Session de travail (90 min) sur la tâche #2",
            "Réunion d'équipe ou appels",
            "Ranger le bureau en fin de journée"
        ]
    },
    {
        "category": "Santé / Sport",
        "prompt": "ajouter du sport à ma journée",
        "tasks": [
            "Préparer ses affaires de sport la veille",
            "Session d'entraînement (45-60 min)",
            "Bien s'hydrater après l'effort",
            "Préparer un repas riche en protéines",
            "Prendre 5 minutes pour méditer après la séance"
        ]
    },
    {
        "category": "Maison / Personnel",
        "prompt": "tâches ménagères aujourd'hui",
        "tasks": [
            "Faire une lessive",
            "Passer l'aspirateur dans le salon",
            "Nettoyer le plan de travail de la cuisine",
            "Sortir les poubelles",
            "Arroser les plantes"
        ]
    },
    {
        "category": "Courses / Alimentation",
        "prompt": "organiser mes courses et repas",
        "tasks": [
            "Vérifier le contenu du frigo et des placards",
            "Établir la liste de courses",
            "Aller au supermarché ou marché",
            "Ranger les courses",
            "Préparer le dîner et le lunch pour demain"
        ]
    },
    # English Daily Templates
    {
        "category": "Morning Routine",
        "prompt": "organize my morning",
        "tasks": [
            "Wake up at 7:00 AM",
            "Drink a large glass of water",
            "Do 15 minutes of stretching or yoga",
            "Take a quick shower",
            "Prepare a healthy breakfast",
            "Review today's goals",
            "Avoid social media until 9:00 AM"
        ]
    },
    {
        "category": "Work / Productivity",
        "prompt": "plan my workday",
        "tasks": [
            "Identify top 3 Most Important Tasks (MITs)",
            "Deep Work session (90 min) on task #1",
            "10-minute break (walk or breathing)",
            "Handle emails and messages (30 min)",
            "Work session (90 min) on task #2",
            "Team meeting or calls",
            "Organize workspace at the end of the day"
        ]
    },
    {
        "category": "Errands / Household",
        "prompt": "daily chores and errands",
        "tasks": [
            "Do the laundry",
            "Vacuum the living room",
            "Clean the kitchen counters",
            "Take out the trash",
            "Water the plants",
            "Go grocery shopping"
        ]
    }
]

def get_daily_kb_text() -> list:
    """
    Convert daily templates to text format.
    """
    texts = []
    for template in DAILY_TEMPLATES:
        text = f"Catégorie: {template['category']}\n"
        text += f"Objectif du jour: {template['prompt']}\n"
        text += "Activités suggérées:\n"
        for i, task in enumerate(template['tasks'], 1):
            text += f"{i}. {task}\n"
        texts.append(text)
    return texts
