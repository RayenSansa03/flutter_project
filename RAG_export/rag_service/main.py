"""
FastAPI backend for RAG-based To-Do List Generator
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
import os
from dotenv import load_dotenv
from rag_engine import RAGEngine

# Load environment variables
load_dotenv()

# Initialize FastAPI app
app = FastAPI(
    title="RAG To-Do List Generator",
    description="Generate structured to-do lists using RAG and Groq",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your frontend URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize RAG engine
groq_api_key = os.getenv("GROQ_API_KEY")
if not groq_api_key:
    raise ValueError("GROQ_API_KEY not found in environment variables. Please set it in .env file")

rag_engine = RAGEngine(groq_api_key=groq_api_key)


# Request/Response models
class TodoRequest(BaseModel):
    prompt: str
    
    class Config:
        json_schema_extra = {
            "example": {
                "prompt": "créer une application mobile de fitness"
            }
        }


class TodoResponse(BaseModel):
    title: str
    tasks: List[str]
    
    class Config:
        json_schema_extra = {
            "example": {
                "title": "Développement d'une Application Mobile de Fitness",
                "tasks": [
                    "Définir les fonctionnalités principales",
                    "Créer les maquettes UI/UX",
                    "Développer le backend",
                    "Implémenter le frontend",
                    "Tester et déployer"
                ]
            }
        }


# Endpoints
@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "RAG To-Do List Generator API",
        "version": "1.0.0",
        "endpoints": {
            "generate": "/generate-todo",
            "health": "/health"
        }
    }


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "rag_engine": "initialized",
        "llm": "Groq (llama-3.1-70b-versatile)",
        "vector_db": "ChromaDB"
    }


@app.post("/generate-todo", response_model=TodoResponse)
async def generate_todo(request: TodoRequest):
    """
    Generate a to-do list based on user prompt.
    
    Args:
        request: TodoRequest with user prompt
        
    Returns:
        TodoResponse with title and tasks
    """
    try:
        if not request.prompt or len(request.prompt.strip()) == 0:
            raise HTTPException(status_code=400, detail="Prompt cannot be empty")
        
        # Generate to-do list using RAG
        result = rag_engine.generate_todo_list(request.prompt)
        
        return TodoResponse(
            title=result.get("title", "To-Do List"),
            tasks=result.get("tasks", [])
        )
        
    except Exception as e:
        print(f"Error generating to-do list: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error generating to-do list: {str(e)}"
        )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
