---
to: tests/api/test_<%= name %>.py
---
"""
Tests for <%= h.changeCase.pascal(name) %> API
"""
import pytest
from fastapi.testclient import TestClient


class Test<%= h.changeCase.pascal(name) %>API:
    """Test suite for <%= name %> endpoints"""

    def test_list_<%= h.changeCase.snake(name) %>(self, client: TestClient):
        """Test listing <%= name %>"""
        response = client.get("/<%= name %>/")
        assert response.status_code == 200
        # TODO: Add assertions

    def test_get_<%= h.changeCase.snake(name) %>_not_found(self, client: TestClient):
        """Test getting non-existent <%= name %>"""
        response = client.get("/<%= name %>/nonexistent")
        assert response.status_code == 404

    def test_create_<%= h.changeCase.snake(name) %>(self, client: TestClient):
        """Test creating <%= name %>"""
        response = client.post("/<%= name %>/", json={})
        assert response.status_code == 200
        # TODO: Add assertions
