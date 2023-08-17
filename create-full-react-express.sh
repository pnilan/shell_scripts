read -p "Enter the project name: " project_name

if [ -z "$project_name" ]; then
    echo "Project name cannot be empty."
    exit 1
fi

echo "Creating Full Stack React & Express project directory '$project_name'"

mkdir "$project_name"
cd "$project_name"

# Create server folders
mkdir server server/controllers server/db server/models server/middleware server/spec

# Create client folders
mkdir client client/public client/src client/src/components client/src/assets client/src/lib client/src/pages


# Initialize Node project
echo "Initializing project"
npm init -y

# Install express, react and other dependencies
echo "Installing dependencies"
npm install express axios cors dotenv morgan pg react react-dom react-icons
npm install --save-dev webpack webpack-cli style-loader sass-loader babel-loader css-loader @babel/core @babel/preset-env @babel/preset-react eslint eslint-plugin-react sass jest @testing-library/jest-dom @testing-library/react live-server html-webpack-plugin nodemon

# Add scripts to package.json
echo "Adding scripts to package.json"
npm pkg set scripts.test="jest"
npm pkg set scripts.coverage="jest coverage"
npm pkg set scripts.start-dev="npx webpack --watch --mode development & nodemon ./server/app.js"
npm pkg set scripts.build-dev="npx webpack --mode development"
npm pkg set scripts.dev-server="nodemon ./server/app.js"

# Setting up initial files
echo "Setting up .env for postgres"
echo "PGUSER=postgres
  PGHOST=localhost
  PGPASSWORD=postgres
  PGDATABASE=$project_name
  PGPORT=5432
  PORT=3001" > .env

# Set up barebones server/app.js
echo "Setting up server/app.js"
echo "require('dotenv').config();
const express = require('express');
const routes = require('./routes');
const morgan = require('morgan');
const path = require('path');

const app = express();

app.use(express.json());

app.use(morgan(':method :url :status - :response-time ms :remote-addr'));

app.use(express.static(path.join(__dirname, '../client/public/')));

app.get('/hello', (req, res) => {
  res.send('Hello tested world.');
});

app.use('/api', routes);

app.all('*', (req, res) => {
  res.status(404).end();
});

const PORT = process.env.PORT || 3001;

app.listen(PORT);
console.log(\`Listening on port \${PORT}\`);" > server/app.js

# Set up barebones server/routes.js
echo "Setting up routes.js"
echo "const routes = require('express').Router();
const controllers = require('./controllers');

// === Add routes here ===

module.exports = routes;" > server/routes.js

# Set up simple server/controller
echo "Setting up barebones controller"
echo "const models = require('../models');

module.exports = {
  // === Add controller methods here ===

};" > server/controllers/index.js

# Set up simple server/model
echo "Setting up barebones model"
echo "const db = require('../db');

module.exports = {
  // === Add model methods here ===

};" > server/models/index.js

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

module.exports = db;" > server/db/index.js

# Set up client folders

# Set up client/src/index.jsx and client/src/components/App.jsx
echo "import React from 'react';
import { createRoot } from 'react-dom/client';
import './assets/reset.css';
import './assets/styles.sass';
import App from './components/App.jsx';

const domNode = document.getElementById('root');
const root = createRoot(domNode);
root.render(<App />);
" > client/src/index.jsx

echo "import React from 'react';

const App = () => {
  return (
    <>
      Hello world!
    </>
  );
};

export default App;" > client/src/components/App.jsx

# Add index.html template
echo "<!DOCTYPE html>
<html>
  <head>
    <meta charset=\"utf-8\">
    <title>$project_name</title>
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
  </head>
  <body>
    <div id=\"root\"></div>
  </body>
</html>" > client/src/assets/index.html

# Add CSS reset
echo "
/* http://meyerweb.com/eric/tools/css/reset/
  v2.0 | 20110126
  License: none (public domain)
*/

html, body, div, span, applet, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, img, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
b, u, i, center,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td,
article, aside, canvas, details, embed,
figure, figcaption, footer, header, hgroup,
menu, nav, output, ruby, section, summary,
time, mark, audio, video {
	margin: 0;
	padding: 0;
	border: 0;
	font-size: 100%;
	font: inherit;
	vertical-align: baseline;
}
/* HTML5 display-role reset for older browsers */
article, aside, details, figcaption, figure,
footer, header, hgroup, menu, nav, section {
	display: block;
}
body {
	line-height: 1;
}
ol, ul {
	list-style: none;
}
blockquote, q {
	quotes: none;
}
blockquote:before, blockquote:after,
q:before, q:after {
	content: '';
	content: none;
}
table {
	border-collapse: collapse;
	border-spacing: 0;
}" > client/src/assets/reset.css

# Add global styles file
touch client/src/assets/styles.sass

# Set up babel config
echo "{
  'presets': [
    '@babel/preset-env',
    [
      '@babel/preset-react',
      {
        'runtime': 'automatic'
      }
    ]
  ]
}" > .babelrc

# Set up initial webpack config
echo "const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: path.join(__dirname, 'client/src/index.jsx'),
  output: {
    path: path.join(__dirname, 'client/public/'),
    filename: 'bundle.js'
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: '$project_name',
      template: path.join(__dirname, 'client/src/assets/index.html')
    })
  ],
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /nodeModules/,
        use: {
          loader: 'babel-loader'
        },
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      },
      {
        test: /\.sass$/,
        use: ['style-loader', 'css-loader', 'sass-loader']
      },
      {
        test: /\.png/,
        type: 'asset/resource'
      }
    ]
  }
};" > webpack.config.js

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
public/
node_modules/
bower_components/
.DS_Store
.env
config.js
jest.config.js
.vscode/
bundle.js
bundle.js.map
bundle.js.br
bundle.js.LICENSE.txt" > .gitignore

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
};" > .eslintrc.js

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
run 'npm run client-dev' to build the client and run the server.
"



