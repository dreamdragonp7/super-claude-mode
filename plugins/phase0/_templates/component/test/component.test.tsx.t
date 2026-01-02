---
to: <%= dir %>/<%= name %>.test.tsx
---
import { render, screen } from '@testing-library/react'
import { describe, it, expect } from 'vitest'
import { <%= name %> } from './<%= name %>'

describe('<%= name %>', () => {
  it('renders without crashing', () => {
    render(<<%= name %> />)
    // TODO: Add specific assertions
    expect(document.body).toBeTruthy()
  })

  it('matches snapshot', () => {
    const { container } = render(<<%= name %> />)
    expect(container).toMatchSnapshot()
  })

  // TODO: Add more specific tests for <%= name %> behavior
})
