# Libraries
React         = require 'react'    
Router        = require 'react-router'
Route         = Router.Route
DefaultRoute  = Router.DefaultRoute
RouteHandler  = Router.RouteHandler
# Parse         = require('parse').Parse

# Initialize Parse
# Parse.initialize "9mCl38L0CLSNnYzrc7EEUf8GmWleFNvCFzO0xGt9", "XAvMqgZEU9OLYj13oapjPrI9NNBa5qtnWAWb55Dr"


# Pages
Landing = require './landing'
# Index   = require './index'


# DOM Elements
{p, div, input} = React.DOM


App = React.createClass
  render: ->
    RouteHandler()


console.log 'A', Route

Routes =
  Route
    name:    'app'
    path:    '/'
    handler: App

    # Route
    #   handler: Landing



Router.run Routes, (Handler) ->
  React.render Handler(), (document.getElementById 'content')