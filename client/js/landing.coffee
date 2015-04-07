# Libraries
React   = require 'react'
Router  = require 'react-router'
# Parse   = require('parse').Parse

# DOM Elements
{p, div, input, iframe} = React.DOM


Landing= React.createClass


  mixins: [ Router.Navigation, Router.State ]


  render: ->

    div {},
      p {},
        'DANK MEME'





module.exports = Landing