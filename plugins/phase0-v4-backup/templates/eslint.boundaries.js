// ==============================================================================
// ESLint boundaries configuration
// ==============================================================================
// This file configures eslint-plugin-boundaries for TypeScript/JavaScript
// import boundaries. Merge this into your eslint.config.js.
//
// Install: npm install eslint-plugin-boundaries
//
// This integrates with patterns.yaml - /audit uses this when available.

import boundaries from 'eslint-plugin-boundaries';

// Add this to your eslint.config.js default export array:
export default [
  // ... your existing config

  {
    plugins: {
      boundaries,
    },
    settings: {
      // Define your packages/modules
      'boundaries/elements': [
        { type: 'web', pattern: 'apps/web/*' },
        { type: 'mobile', pattern: 'apps/mobile/*' },
        { type: 'api', pattern: 'apps/api/*' },
        { type: 'shared', pattern: 'packages/shared/*' },
        // Add more as needed:
        // { type: 'core', pattern: 'core/*' },
        // { type: 'ml', pattern: 'ml/*' },
      ],
      // Ignore patterns
      'boundaries/ignore': [
        '**/*.test.*',
        '**/*.spec.*',
        '**/__tests__/**',
      ],
    },
    rules: {
      // Main boundary rule
      'boundaries/element-types': [
        'error',
        {
          // By default, disallow all cross-package imports
          default: 'disallow',
          rules: [
            // Web app can import from web and shared
            {
              from: 'web',
              allow: ['web', 'shared'],
            },
            // Mobile app can import from mobile and shared
            {
              from: 'mobile',
              allow: ['mobile', 'shared'],
            },
            // API can import from api and shared
            {
              from: 'api',
              allow: ['api', 'shared'],
            },
            // Shared can only import from itself
            {
              from: 'shared',
              allow: ['shared'],
            },
          ],
        },
      ],

      // Prevent external dependencies from leaking (optional)
      // 'boundaries/external': [
      //   'error',
      //   {
      //     default: 'allow',
      //     rules: [
      //       {
      //         from: 'shared',
      //         disallow: ['react-dom', 'next'],
      //         message: 'Shared packages should be framework-agnostic',
      //       },
      //     ],
      //   },
      // ],
    },
  },
];

// ==============================================================================
// Usage Notes
// ==============================================================================
// 1. Copy this into your eslint.config.js (flat config format)
// 2. Adjust the 'boundaries/elements' to match your project structure
// 3. Adjust the rules to match your desired boundaries
// 4. Run: npx eslint . --plugin boundaries
//
// /audit will run this automatically if eslint-plugin-boundaries is installed.
