---
to: src/features/<%= name %>/<%= h.changeCase.pascal(name) %>.tsx
---
import React from 'react';

interface <%= h.changeCase.pascal(name) %>Props {
  // TODO: Define props
}

/**
 * <%= description %>
 */
export function <%= h.changeCase.pascal(name) %>({}: <%= h.changeCase.pascal(name) %>Props) {
  return (
    <div className="<%= name %>">
      {/* TODO: Implement <%= name %> */}
    </div>
  );
}
