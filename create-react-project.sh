read -p "Enter name for React project: " project_name

if [ -z "$project_name" ]; then
    echo "Project name cannot be empty."
    exit 1
fi

echo "Creating Express project directory '$project_name'"

# Create project folder
mkdir "$project_name" & sleep 1;
cd "$project_name"

# Create initial README.md
echo "# $project_name" > README.md

# Create initial folders
mkdir public src src/components src/assets src/lib src/pages


# Install React and other common dependencies
npm init -y
npm install react react-dom react-icons axios
npm install --save-dev webpack webpack-cli style-loader sass-loader babel-loader css-loader @babel/core @babel/preset-env @babel/preset-react eslint eslint-plugin-react sass jest @testing-library/jest-dom @testing-library/react live-server html-webpack-plugin

# Adding scripts to package.json
npm pkg set scripts.test="jest"
npm pkg set scripts.coverage="jest coverage"
npm pkg set scripts.client-dev="npx webpack --watch --mode development & npx live-server --open=./public/index.html"
npm pkg set scripts.build-dev="npx webpack --mode development"
npm pkg set scripts.dev-server="npx live-server --open=./public/index.html"

# Set up index.jsx and App.jsx
echo "import React from 'react';
import { createRoot } from 'react-dom/client';
import './assets/reset.css';
import './assets/styles.sass';
import App from './components/App.jsx';

const domNode = document.getElementById('root');
const root = createRoot(domNode);
root.render(<App />);
" > ./src/index.jsx

echo "import React from 'react';

const App = () => {
  return (
    <>
      Hello world!
    </>
  );
};

export default App;
" > ./src/components/App.jsx

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
</html>
" > ./src/assets/index.html

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
}
" > ./src/assets/reset.css

# Add global styles file
touch ./src/assets/styles.sass

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
}
" > .babelrc

# Set up initial eslint config
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
    'space-before-blocks': 1,
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

# Set up initial webpack config
echo "const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: path.join(__dirname, '/src/index.jsx'),
  output: {
    path: path.join(__dirname, '/public/'),
    filename: 'bundle.js'
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: '$project_name',
      template: path.join(__dirname, '/src/assets/index.html')
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
};
" > webpack.config.js

# Set up initial .gitignore
echo "node_modules/
.env
.DS_Store
bundle.js
bundle.js.map
bundle.js.br
config.js
coverage/
jest.config.js
bundle.js.LICENSE.txt
bundle.js.br
" > .gitignore

# git init
git init
git add .
git commit -m "Initial commit"

echo "
Project directory inititialized!
cd into '$project_name' to get started.
run 'npm run client-dev' to compile and serve your React app.
"