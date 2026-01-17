"""
RAG Engine for generating to-do lists using LangChain, ChromaDB, and Groq.
"""

import os
from typing import List, Dict
from langchain_groq import ChatGroq
from langchain_core.prompts import ChatPromptTemplate
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain_community.vectorstores import Chroma
from langchain_core.documents import Document
from knowledge_base import get_knowledge_base_text


class RAGEngine:
    def __init__(self, groq_api_key: str):
        """
        Initialize the RAG engine with Groq LLM and ChromaDB.
        
        Args:
            groq_api_key: API key for Groq
        """
        self.groq_api_key = groq_api_key
        
        # Initialize embeddings (local, free)
        print("Initializing embeddings model...")
        self.embeddings = HuggingFaceEmbeddings(
            model_name="sentence-transformers/all-MiniLM-L6-v2",
            model_kwargs={'device': 'cpu'}
        )
        
        # Initialize Groq LLM
        print("Initializing Groq LLM...")
        self.llm = ChatGroq(
            groq_api_key=groq_api_key,
            model_name="llama-3.3-70b-versatile",  # Updated to supported model
            temperature=0.7,
            max_tokens=2000
        )
        
        # Initialize ChromaDB vector store
        print("Initializing ChromaDB...")
        self.vector_store = self._initialize_vector_store()
        
        print("RAG Engine initialized successfully!")
    
    def _initialize_vector_store(self) -> Chroma:
        """
        Initialize ChromaDB with knowledge base.
        """
        # Get knowledge base texts
        kb_texts = get_knowledge_base_text()
        
        # Create documents
        documents = [
            Document(page_content=text, metadata={"source": f"template_{i}"})
            for i, text in enumerate(kb_texts)
        ]
        
        # Create or load vector store
        persist_directory = "./chroma_db"
        
        # Check if database already exists
        if os.path.exists(persist_directory):
            print("Loading existing ChromaDB...")
            vector_store = Chroma(
                persist_directory=persist_directory,
                embedding_function=self.embeddings
            )
        else:
            print("Creating new ChromaDB with knowledge base...")
            vector_store = Chroma.from_documents(
                documents=documents,
                embedding=self.embeddings,
                persist_directory=persist_directory
            )
        
        return vector_store
    
    def _detect_language(self, text: str) -> str:
        """
        Detect if the text is in French or English.
        Simple heuristic based on common French words.
        
        Returns:
            'fr' for French, 'en' for English
        """
        french_indicators = [
            'créer', 'développer', 'apprendre', 'organiser', 'lancer',
            'mettre', 'faire', 'pour', 'avec', 'dans', 'une', 'des',
            'application', 'projet', 'système', 'événement'
        ]
        
        text_lower = text.lower()
        french_count = sum(1 for word in french_indicators if word in text_lower)
        
        # If we find French indicators, it's likely French
        return 'fr' if french_count >= 2 else 'en'
    
    def generate_todo_list(self, user_prompt: str) -> Dict[str, any]:
        """
        Generate a to-do list based on user prompt using RAG.
        Automatically detects language and responds in the same language.
        
        Args:
            user_prompt: User's request/prompt
            
        Returns:
            Dictionary with title and tasks
        """
        # Detect language
        language = self._detect_language(user_prompt)
        print(f"Detected language: {language}")
        
        # Retrieve relevant context from vector store
        print(f"Searching for relevant context for: {user_prompt}")
        relevant_docs = self.vector_store.similarity_search(user_prompt, k=2)
        
        # Combine context
        context = "\n\n".join([doc.page_content for doc in relevant_docs])
        
        # Create prompt template based on language
        if language == 'fr':
            system_message = """Tu es un assistant expert en gestion de projet et organisation de tâches.
Ta mission est de créer des to-do lists détaillées et actionnables basées sur les demandes des utilisateurs.

Utilise le contexte fourni comme inspiration, mais adapte-le à la demande spécifique de l'utilisateur.
Crée une liste de tâches logique, ordonnée et complète EN FRANÇAIS.

Réponds UNIQUEMENT au format JSON suivant (sans markdown, sans backticks):
{{
    "title": "Titre descriptif du projet en français",
    "tasks": [
        "Tâche 1 - description claire et actionnable en français",
        "Tâche 2 - description claire et actionnable en français",
        ...
    ]
}}

IMPORTANT: Réponds uniquement avec le JSON, rien d'autre. Toutes les tâches doivent être en français."""
        else:  # English
            system_message = """You are an expert assistant in project management and task organization.
Your mission is to create detailed and actionable to-do lists based on user requests.

Use the provided context as inspiration, but adapt it to the user's specific request.
Create a logical, ordered, and complete task list IN ENGLISH.

Respond ONLY in the following JSON format (no markdown, no backticks):
{{
    "title": "Descriptive project title in English",
    "tasks": [
        "Task 1 - clear and actionable description in English",
        "Task 2 - clear and actionable description in English",
        ...
    ]
}}

IMPORTANT: Respond only with JSON, nothing else. All tasks must be in English."""
        
        prompt_template = ChatPromptTemplate.from_messages([
            ("system", system_message),
            ("user", """Reference context:
{context}

User request: {user_prompt}

Generate a complete and structured to-do list.""")
        ])
        
        # Create chain
        chain = prompt_template | self.llm
        
        # Generate response
        print("Generating to-do list with Groq...")
        response = chain.invoke({
            "context": context,
            "user_prompt": user_prompt
        })
        
        # Parse response
        import json
        try:
            # Clean response if it contains markdown code blocks
            content = response.content.strip()
            if content.startswith("```"):
                # Remove markdown code blocks
                content = content.split("```")[1]
                if content.startswith("json"):
                    content = content[4:]
                content = content.strip()
            
            result = json.loads(content)
            return result
        except json.JSONDecodeError as e:
            print(f"Error parsing JSON: {e}")
            print(f"Raw response: {response.content}")
            # Fallback response
            return {
                "title": "To-Do List",
                "tasks": [
                    "Analyser la demande en détail",
                    "Planifier les étapes principales",
                    "Commencer l'implémentation"
                ]
            }
    
    def add_to_knowledge_base(self, text: str, metadata: Dict = None):
        """
        Add new content to the knowledge base.
        
        Args:
            text: Text content to add
            metadata: Optional metadata
        """
        doc = Document(page_content=text, metadata=metadata or {})
        self.vector_store.add_documents([doc])
        print("Added new content to knowledge base")
