import globals from 'globals';
import pluginJs from '@eslint/js';
import stylistic from '@stylistic/eslint-plugin';

export default [
  {
    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.node
      }
    },
  },
  pluginJs.configs.all,
  stylistic.configs['recommended-flat'],
  {
    plugins: {
      '@stylistic': stylistic
    },
    rules: {
      '@stylistic/brace-style': ['error', '1tbs'],
      '@stylistic/comma-dangle': ['error', 'never'],
      '@stylistic/operator-linebreak': ['error', 'before'],
      '@stylistic/quote-props': ['error', 'as-needed'],
      '@stylistic/semi': ['error', 'always'],
      '@stylistic/space-before-function-paren': ['error', 'always'],
      '@stylistic/spaced-comment': ['error', 'always', { block: { balanced: true } }],
      'arrow-body-style': ['error', 'always'],
      'no-ternary': 'off',
      'one-var': ['error', { initialized: 'never' }],
      'sort-imports': ['error', { ignoreCase: true }]
    }
  }
];
