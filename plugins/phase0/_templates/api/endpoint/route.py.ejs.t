---
to: apps/api/routers/<%= name %>.py
---
"""
<%= h.changeCase.pascal(name) %> API Router
"""
from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel

router = APIRouter(prefix="/<%= name %>", tags=["<%= name %>"])


class <%= h.changeCase.pascal(name) %>Request(BaseModel):
    """Request schema for <%= name %>"""
    # TODO: Define request fields
    pass


class <%= h.changeCase.pascal(name) %>Response(BaseModel):
    """Response schema for <%= name %>"""
    # TODO: Define response fields
    pass


@router.get("/")
async def list_<%= h.changeCase.snake(name) %>():
    """List all <%= name %>"""
    # TODO: Implement
    return []


@router.get("/{id}")
async def get_<%= h.changeCase.snake(name) %>(id: str):
    """Get a single <%= name %> by ID"""
    # TODO: Implement
    raise HTTPException(status_code=404, detail="Not found")


@router.post("/")
async def create_<%= h.changeCase.snake(name) %>(request: <%= h.changeCase.pascal(name) %>Request):
    """Create a new <%= name %>"""
    # TODO: Implement
    return {"id": "new-id"}
