const path = require('path');

module.exports = {
  mode: 'development',
  entry: './index.js',
  experiments: {
    outputModule: true
  },
  output: {
    libraryTarget:'module',
    path: path.resolve(__dirname, 'release'),
    filename: 'bundle.js',
  },
};