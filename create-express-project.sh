read -p "Enter the project name: " project_name

if [ -z "$project_name" ]; then
    echo "Project name cannot be empty."
    exit 1
fi

echo "Creating Express project directory '$project_name'"

mkdir "$project_name" & sleep 1;
cd "$project_name"

touch app.js routes.js
mkdir controllers db models middleware spec

# Initialize Node project
echo "Initializing node project"
npm init -y

# Install express and other common dependencies
echo "Installing dependencies"
npm install express axios cors dotenv morgan pg
npm install --save-dev eslint jest nodemon

# Add scripts to package.json
echo "Adding scripts to package.json"
npm pkg set scripts.start="nodemon app.js"
npm pkg set scripts.test="jest"

# Setting up initial files
echo "Setting up .env for postgres"
echo "PGUSER=postgres
  PGHOST=localhost
  PGPASSWORD=postgres
  PGDATABASE=$project_name
  PGPORT=5432
  PORT=3001
" > .env

# Set up barebones app.js
echo "Setting up app.js"
echo "require('dotenv').config();
const express = require('express');
const routes = require('./routes');
const morgan = require('morgan');

const app = express();

app.use(express.json());

app.use(morgan(':method :url :status - :response-time ms :remote-addr'));

app.get('/', (req, res) => {
  res.send('Hello world.');
});

app.use('/api', routes);

app.all('*', (req, res) => {
  res.status(404).end();
});

const PORT = process.env.PORT || 3001;

app.listen(PORT);
console.log(\`Listening on port \${PORT}\`);
" > app.js

# Set up barebones routes.js
echo "Setting up routes.js"
echo "const routes = require('express').Router();
const controllers = require('./controllers');

// === Add routes here ===

module.exports = routes;
" > routes.js

# Set up simple controller
echo "Setting up barebones controller"
echo "const models = require('../models');

module.exports = {
  // === Add controller methods here ===

};

" > controllers/index.js

# Set up simple model
echo "Setting up barebones model"
echo "const db = require('../db');

module.exports = {
  // === Add model methods here ===

};
" > models/index.js

# Set up db connection
echo "Setting up db connection"
echo "require('dotenv').config();
const { Pool } = require('pg');

const db = new Pool({
  host: process.env.PGHOST,
  user: process.env.PGUSER,
  password: process.env.PGPASSWORD,
  database: process.env.PGDATABASE,
  port: process.env.PGPORT
});

module.exports = db;

" > db/index.js

# Setting up .gitignore
echo "Setting up .gitignore"
echo "logs
*.log
pids
*.pid
*.seed
lib-cov
coverage
.grunt
build/
dist/
node_modules/
bower_components/
.DS_Store
.env
config.js
jest.config.js
.vscode/
" > .gitignore

# Set up eslint
echo "Setting up eslint"
echo "module.exports = {
  env: {
    'es6': true
  },
  parserOptions: {
    sourceType: 'module',
    ecmaVersion: 6,
    ecmaFeatures: {
      'jsx': true
    }
  },
  ignorePatterns: ['client/dist/'],
  rules: {
    /* Indentation */
    'no-mixed-spaces-and-tabs': 2,
    'indent': [2, 2],
    /* Variable names */
    'camelcase': 2,
    /* Language constructs */
    'curly': 2,
    'eqeqeq': [2, 'smart'],
    'func-style': [2, 'expression'],
    /* Semicolons */
    'semi': 2,
    'no-extra-semi': 2,
    /* Padding & additional whitespace (perferred but optional) */
    'brace-style': [2, '1tbs', { 'allowSingleLine': true }],
    'semi-spacing': 1,
    'key-spacing': 1,
    'block-spacing': 1,
    'comma-spacing': 1,
    'no-multi-spaces': 1,
    'space-before-blocks': 1,cd
    'keyword-spacing': [1, { 'before': true, 'after': true }],
    'space-infix-ops': 1,
    /* Variable declaration */
    'one-var': [1, { 'uninitialized': 'always', 'initialized': 'never' }],
    /* Minuta */
    'comma-style': [2, 'last'],
    'quotes': [1, 'single']
  }
};
" > .eslintrc.js

# Create README.md
echo "Creating initial README.md"
touch README.md
echo "#$project_name" > README.md

# git init
echo "Initializing git"
git init
git add .
git commit -m "Initial commit"

echo "
Project directory inititialized!
cd into '$project_name' to get started.
run 'npm start' to run the server.
"



