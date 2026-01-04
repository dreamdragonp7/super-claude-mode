---
to: src/features/<%= name %>/index.ts
---
export { <%= h.changeCase.pascal(name) %> } from './<%= h.changeCase.pascal(name) %>';
export { use<%= h.changeCase.pascal(name) %> } from './use<%= h.changeCase.pascal(name) %>';
