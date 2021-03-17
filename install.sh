#!/bin/bash
mkdir temp
cd temp
cdk8s init typescript-app
rm -rf package-lock.json

yarn

yarn add \
eslint \
eslint-config-airbnb-typescript \
eslint-import-resolver-typescript \
eslint-plugin-import \
eslint-plugin-prettier \
@typescript-eslint/parser \
@typescript-eslint/eslint-plugin \
jest \
prettier \
shelljs \
ts-jest \
ts-node \
typescript --dev

echo "node_modules
dist
.eslintrc.js
jest.config.js
*.d.ts
*.js
imports/*
" >> .eslintignore

echo "
 module.exports = {
  root: true,

  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: './tsconfig.json',
    ecmaVersion: 2018,
    ecmaFeatures: {
      impliedStrict: true,
      classes: true,
    },
    sourceType: 'module',
  },

  plugins: [
    'import',
    '@typescript-eslint',
    'prettier',
  ],

  extends: [
    'airbnb-typescript/base',
  ],

  env: {
    node: true,
  },

  settings: {
    'import/resolver': {
      typescript: {
        // To resolve local depedencies under paths: {}
        project: '.',
      },
      // To resolve @types like aws-lambda
      node: {
        extensions: ['.js', '.ts', '.tsx', '.d.ts'],
        paths: ['node_modules/', 'node_modules/@types/'],
      },
    },
  },

  rules: {
    // Default exports can lead to different names in import
    // whereas import with destructuring not.
    'import/prefer-default-export': 'off',
    
    'max-params': ['error', 3],

    'no-console': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'no-continue': 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',

    'no-new': 'off',

    // Functional style prefered: map, reduce, Object.entries(), ...
    'no-restricted-syntax': [
      'off',
      { selector: 'ForInStatement' },
      { selector: 'ForOfStatement' },
    ],
    
    '@typescript-eslint/member-delimiter-style': [
      'error',
      {
        'multiline': {
          'delimiter': 'semi',
          'requireLast': true
        },
        'singleline': {
          'delimiter': 'semi',
          'requireLast': true
        }
      },
    ],

    '@typescript-eslint/naming-convention': [
      'error',
      {
        // No 'I' prefix for interfaces
        // Guideline by TypeScript for contributers.
        // https://github.com/microsoft/TypeScript/wiki/Coding-guidelines#names
        selector: 'interface',
        format: ['PascalCase'],
        custom: {
          regex: '^(?![I][A-Z])',
          match: true,
        },
      },
    ],
  },
  overrides: [
    {
      files: 'scripts/**/*.ts',
      rules: {
        // To import dev dependencies in scripts/*
        'import/no-extraneous-dependencies': 'off',
      },
    },
    {
      files: '**/?(*\.)+(spec|test).ts',
      rules: {
        // To import dev dependencies in tests (e.g. @jest/globals)
        'import/no-extraneous-dependencies': ['error', { devDependencies: true }],
      },
    },
  ],
};" >> .eslintrc.js

sed -i.bak 's/npm run/yarn/g' package.json
rm -rf package.json.bak
sed -i.bak 's/"test": "jest",/"test": "jest",\n    "lint":"eslint .",\n    "lint:fix": "eslint . --fix",/g' package.json
rm -rf package.json.bak
mv .* ../
mv * ../
cd ..
rm -rf temp

