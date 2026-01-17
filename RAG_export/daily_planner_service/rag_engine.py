"""
RAG Engine for Daily Planner.
"""

import os
from typing import List, Dict
from langchain_groq import ChatGroq
from langchain_core.prompts import ChatPromptTemplate
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain_community.vectorstores import Chroma
from langchain_core.documents import Document
from knowledge_base import get_daily_kb_text
from dotenv import load_dotenv

load_dotenv()

class DailyRAGEngine:
    def __init__(self, groq_api_key: str):
        self.groq_api_key = groq_api_key
        
        print("Initializing Daily Planner embeddings...")
        self.embeddings = HuggingFaceEmbeddings(
            model_name="sentence-transformers/all-MiniLM-L6-v2",
            model_kwargs={'device': 'cpu'}
        )
        
        print("Initializing Daily Planner Groq LLM...")
        self.llm = ChatGroq(
            groq_api_key=groq_api_key,
            model_name="llama-3.3-70b-versatile",
            temperature=0.5,
            max_tokens=1500
        )
        
        print("Initializing Daily Planner ChromaDB...")
        self.vector_store = self._initialize_vector_store()
        
        print("Daily Planner RAG Engine ready!")
    
    def _initialize_vector_store(self) -> Chroma:
        kb_texts = get_daily_kb_text()
        documents = [
            Document(page_content=text, metadata={"source": f"daily_{i}"})
            for i, text in enumerate(kb_texts)
        ]
        
        persist_directory = "./chroma_db_daily"
        
        if os.path.exists(persist_directory):
            vector_store = Chroma(
                persist_directory=persist_directory,
                embedding_function=self.embeddings
            )
        else:
            vector_store = Chroma.from_documents(
                documents=documents,
                embedding=self.embeddings,
                persist_directory=persist_directory
            )
        
        return vector_store
    
    def _detect_language(self, text: str) -> str:
        french_indicators = [
            'journée', 'matin', 'soir', 'aujourd\'hui', 'faire', 'manger',
            'sport', 'travail', 'maison', 'routine', 'organiser', 'planifier'
        ]
        text_lower = text.lower()
        french_count = sum(1 for word in french_indicators if word in text_lower)
        return 'fr' if french_count >= 1 else 'en'
    
    def generate_daily_plan(self, user_prompt: str) -> Dict[str, any]:
        language = self._detect_language(user_prompt)
        
        # Detection logic for specific tasks
        list_indicators = ['-', '*', '1.', '•', '\n', ',', ';', ':']
        # Check if the user is providing specific tasks or just asking for a plan
        is_custom_plan = any(ind in user_prompt for ind in list_indicators) or len(user_prompt.split()) > 15
        
        if is_custom_plan:
            context = "L'utilisateur a fourni son propre plan. Extrais UNIQUEMENT ses tâches. NE PAS ajouter de suggestions."
        else:
            relevant_docs = self.vector_store.similarity_search(user_prompt, k=3)
            context = "\n\n".join([doc.page_content for doc in relevant_docs])
        
        mode_label = "STRICT (Extraire uniquement)" if is_custom_plan else "SUGGESTION (RAG)"
        
        if language == 'fr':
            system_message = """Tu es un assistant qui organise des plannings.
Ta mission est d'extraire ou de suggérer des tâches de manière structurée.

MODE ACTUEL : {mode}

RÈGLES :
1. Si l'utilisateur donne des tâches précises, tu dois EXTRAIRE UNIQUEMENT ces tâches.
2. Si l'utilisateur demande une organisation générale sans donner de tâches, utilise le contexte pour SUGGÉRER un plan pertinent.
3. NE JAMAIS ajouter "Se réveiller" ou "Boire de l'eau" SAUF si c'est dans le contexte ou demandé.
4. Pour chaque tâche : 'time', 'duration', 'activity', 'description'. Utilise null si inconnu.

Format JSON attendu :
{{
    "title": "Ma journée : [Thème]",
    "tasks": [
        {{
            "time": "HH:MM ou null",
            "duration": "durée ou null",
            "activity": "Action",
            "description": "Détails ou null"
        }}
    ]
}}"""
        else:
            system_message = """You are a planning assistant.
Your mission is to extract or suggest tasks in a structured way.

CURRENT MODE: {mode}

RULES:
1. If the user provides specific tasks, you MUST EXTRACT ONLY those tasks.
2. If the user asks for a general plan without providing tasks, use the context to SUGGEST a relevant plan.
3. NEVER add "Wake up" or "Drink water" UNLESS it's in the context or explicitly requested.
4. For each task: 'time', 'duration', 'activity', 'description'. Use null if unknown.

Expected JSON Format:
{{
    "title": "My Day: [Theme]",
    "tasks": [
        {{
            "time": "HH:MM or null",
            "duration": "duration or null",
            "activity": "Action",
            "description": "Details or null"
        }}
    ]
}}"""
        
        prompt_template = ChatPromptTemplate.from_messages([
            ("system", system_message),
            ("user", "Context:\n{context}\n\nUser's day request: {user_prompt}")
        ])
        
        chain = prompt_template | self.llm
        response = chain.invoke({
            "context": context, 
            "user_prompt": user_prompt,
            "mode": mode_label
        })
        
        import json
        try:
            content = response.content.strip()
            if "```json" in content:
                content = content.split("```json")[1].split("```")[0].strip()
            elif "```" in content:
                content = content.split("```")[1].strip()
            return json.loads(content)
        except:
            return {
                "title": "Planning du jour",
                "tasks": [
                    {
                        "time": "7h00",
                        "duration": "N/A",
                        "activity": "Organiser ma journée",
                        "description": "Démarrer les activités"
                    }
                ]
            }
