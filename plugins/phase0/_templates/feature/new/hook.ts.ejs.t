---
to: src/features/<%= name %>/use<%= h.changeCase.pascal(name) %>.ts
---
import { useState, useCallback } from 'react';

/**
 * Hook for <%= description %>
 */
export function use<%= h.changeCase.pascal(name) %>() {
  const [state, setState] = useState(null);

  // TODO: Implement hook logic

  return {
    state,
    // TODO: Return hook interface
  };
}
