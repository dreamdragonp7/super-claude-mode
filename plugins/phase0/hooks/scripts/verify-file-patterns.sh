#!/bin/bash
# Phase 0 v3.0 - PostToolUse hook for Write/Edit
# Warns if component created without test file

# Read input from stdin
INPUT=$(cat)

# Try to parse tool info (if jq available)
if ! command -v jq &> /dev/null; then
    exit 0
fi

TOOL=$(echo "$INPUT" | jq -r '.tool_name // .toolName // empty' 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.path // .tool_input.file_path // .toolInput.path // .toolInput.file_path // empty' 2>/dev/null)

# Only check Write operations
if [ "$TOOL" != "write" ] && [ "$TOOL" != "Write" ]; then
    exit 0
fi

# If no file path, skip
if [ -z "$FILE_PATH" ] || [ "$FILE_PATH" == "null" ]; then
    exit 0
fi

# If no patterns.yaml, skip checks
if [ ! -f "patterns.yaml" ]; then
    exit 0
fi

# Check if this is a React component (.tsx)
if echo "$FILE_PATH" | grep -qE '\.tsx$'; then
    COMPONENT_DIR=$(dirname "$FILE_PATH")
    COMPONENT_NAME=$(basename "$FILE_PATH" .tsx)

    # Skip test files, index files, and story files
    if echo "$COMPONENT_NAME" | grep -qE '\.test$|\.spec$|^index$|\.stories$'; then
        exit 0
    fi

    # Skip if in __tests__ directory
    if echo "$FILE_PATH" | grep -qE '__tests__'; then
        exit 0
    fi

    # Check if test file exists
    TEST_EXISTS=0
    if [ -f "${COMPONENT_DIR}/${COMPONENT_NAME}.test.tsx" ]; then
        TEST_EXISTS=1
    fi
    if [ -f "${COMPONENT_DIR}/__tests__/${COMPONENT_NAME}.test.tsx" ]; then
        TEST_EXISTS=1
    fi

    if [ "$TEST_EXISTS" -eq 0 ]; then
        echo "⚠️ Component created without test file."
        echo "   Expected: ${COMPONENT_NAME}.test.tsx"
        echo "   Run /audit fix to generate, or create manually."
    fi

    # Check if index.ts exists (for re-exports)
    if [ ! -f "${COMPONENT_DIR}/index.ts" ] && [ ! -f "${COMPONENT_DIR}/index.tsx" ]; then
        echo "⚠️ Component directory missing index.ts export."
        echo "   Consider adding for cleaner imports."
    fi
fi

# Check if this is a Python route
if echo "$FILE_PATH" | grep -qE 'routers/.*\.py$'; then
    ROUTE_DIR=$(dirname "$FILE_PATH")
    ROUTE_NAME=$(basename "$FILE_PATH" .py)

    # Skip __init__.py and test files
    if [ "$ROUTE_NAME" == "__init__" ] || echo "$ROUTE_NAME" | grep -qE '^test_'; then
        exit 0
    fi

    # Check if schema exists
    SCHEMA_DIR=$(dirname "$ROUTE_DIR")/schemas
    if [ ! -f "${SCHEMA_DIR}/${ROUTE_NAME}.py" ]; then
        echo "⚠️ API route created without schema file."
        echo "   Expected: schemas/${ROUTE_NAME}.py"
        echo "   Run /audit fix to generate, or create manually."
    fi
fi

exit 0
