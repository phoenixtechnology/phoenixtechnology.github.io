# Libraries
React   = require 'react'
Parse   = require('parse').Parse
_       = require 'lodash'
Router  = require 'react-router'

# DOM Elements
{p, div, input, textarea, a, img} = React.DOM


cardTemplate = require './cardTemplate.coffee'


CardsView = React.createClass


  mixins: [ Router.Navigation, Router.State ]


  open: (event) ->
    postId = event.target.getAttribute 'data-id'
    @transitionTo '/post/' + postId


  render: ->

    div null,

      for column in [0 .. ((window.innerWidth // 610) - 1)]
        numberOfColumns = window.innerWidth // 610
        numberOfCardsPerColumn = @props.cards?.length // numberOfColumns
        numberOfCardsPerColumn++


        div
          style:
            display:        'inline-block'
            verticalAlign:  'top'

          _.map (@props.cards?.slice (column * numberOfCardsPerColumn), ((column + 1) * numberOfCardsPerColumn) ), (card, cardIndex) =>
            cardTemplate card, cardIndex, @open
      


module.exports = React.createFactory CardsView