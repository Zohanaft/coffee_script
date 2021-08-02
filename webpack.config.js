const path = require("path")

const HtmlWebpackPlugin = require("html-webpack-plugin")
const dotenv = require('dotenv');

Object.assign(process.env, dotenv.config({ path: '.env' }).parsed);

module.exports = {
  entry: {
    app: path.join(__dirname, 'src', 'index.coffee'),
    users: path.join(__dirname, 'src', 'users.coffee')
  },
  devServer: {
    contentBase: path.join(__dirname, 'dist'),
    port: process.env.PORT || 3000,
  },
  target: 'web',
  module: {
    rules: [
      {
        test: /\.coffee$/,
        loader: "coffee-loader",
        options: {
          sourceMap: true
        }
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      filename: 'index.html',
      template: path.join(__dirname, 'src', 'index.html'),
      chunks: ['app']
    }),
    new HtmlWebpackPlugin({
      filename: 'users.html',
      template: path.join(__dirname, 'src', 'users.html'),
      chunks: ['users']
    })
  ],
  output: {
    filename: '[name].js',
    path: path.resolve(__dirname, 'dist/')
  },
  resolve: {
    extensions: [ '.coffee', '.js' ]
  }
};
