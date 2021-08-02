module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
  },
  parserOptions: {
    parser: 'vue-eslint-parser',
  },
  extends: ['prettier'],
  plugins: ['prettier'],
  // add your custom rules here
  rules: {
    'prettier/prettier': 'error',
    prettier: {
      'space-before-function-paren': ['error', 'all'],
    },
  },
};
