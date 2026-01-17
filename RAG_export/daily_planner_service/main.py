"""
FastAPI backend for Daily Planner RAG (Port 8001)
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
import os
import sys
from dotenv import load_dotenv

# Add parent directory to path to use common env
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
load_dotenv(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), ".env"))

from rag_engine import DailyRAGEngine

app = FastAPI(title="Daily Planner RAG API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

groq_api_key = os.getenv("GROQ_API_KEY")
if not groq_api_key:
    raise ValueError("GROQ_API_KEY not found in environment variables.")

rag_engine = DailyRAGEngine(groq_api_key=groq_api_key)

class PlanRequest(BaseModel):
    prompt: str

@app.post("/generate-plan")
async def generate_plan(request: PlanRequest):
    try:
        result = rag_engine.generate_daily_plan(request.prompt)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)
