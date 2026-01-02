---
to: src/features/<%= name %>/__tests__/<%= h.changeCase.pascal(name) %>.test.tsx
---
import { render, screen } from '@testing-library/react';
import { <%= h.changeCase.pascal(name) %> } from '../<%= h.changeCase.pascal(name) %>';

describe('<%= h.changeCase.pascal(name) %>', () => {
  it('renders without crashing', () => {
    render(<<%= h.changeCase.pascal(name) %> />);
    // TODO: Add assertions
  });

  it('TODO: add more tests', () => {
    // TODO: Implement tests for <%= description %>
  });
});
