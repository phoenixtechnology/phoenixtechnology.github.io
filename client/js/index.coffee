# Libraries
React   = require 'react'
Parse   = require('parse').Parse
Router  = require 'react-router'

Route         = Router.Route
RouteHandler  = Router.RouteHandler
DefaultRoute  = Router.DefaultRoute

# Pages
MakeCard          = require './makeCard.coffee'
SpecificCardView = require './specificCard.coffee'
CardsView         = require './cardsView.coffee'

# Loader
CardsLoader = require './cards.loader.coffee'

Parse.initialize "9FkdyLJQwebUZOEZxQtxMgXSPIEoz2nDGjlexCtM", "vbqwWBuaejePM5qWO0n1OsMJLUPEnLA7yKM7yay1"

# DOM Elements
{p, a, div, input, img} = React.DOM

IndexClass = React.createClass


  mixins: [ Router.Navigation, Router.State ]


  getInitialState: ->
    CardsLoader.getAllCards (cards) =>
      @setState cards: cards

    searchValue: ''


  makeACardToggle: ->
    @transitionTo 'makeACard'


  searchHandle: (event) ->
    @setState searchValue: event.target.value


  searchPressHandle: (event) ->
    if event.key is 'Enter'
      CardsLoader.getSearchedCards @state.searchValue, (cards) =>
        @setState cards: [], =>
          @setState cards: cards


  render: ->

    div null,
      div className:    'indent',
        div className:  'spacer'

        div
          style:
            display:  'table'
            width:    '100%'

          a
            href: 'http://www.lmlabs.us'
            img
              src:            './LM3.png'
              style:
                height:       '4em'
                float:        'left'
                marginRight:  '1em'
                boxShadow:    '2px 2px 1px #59595b'

          div 
            className:      'makeACard'
            style:
              padding:      '1em'
              height:       '4em'
              marginBottom: '1em'
              marginRight:  '1em'
              display:      'inline-block'

            p 
              className: 'header'
              style:
                display: 'inline-block'
              'Phoenix Tech Card Board'


            p
              className:    'header hilight'
              style:
                display:    'inline-block'
                marginLeft: '1em'
              '|'


            a 
              className:     'header button'
              onClick:       @makeACardToggle
              style:
                cursor:      'pointer'
                marginLeft:  '1em'
              'Make a New Card'


            p
              className:    'header hilight'
              style:
                display:    'inline-block'
                marginLeft: '1em'
              '|'

            input
              className:    'bigInput'
              placeholder:  'search tags'
              onChange:     @searchHandle
              onKeyPress:   @searchPressHandle
              value:        @state.searchValue

          RouteHandler
            cards: @state.cards

          div className: 'spacer'



routes =
  Route
    name:    'Main'
    path:    '/'
    handler: IndexClass

    DefaultRoute
      handler: CardsView

    Route
      name:    'post'
      path:    'post/:postId'
      handler: SpecificCardView

    Route
      name:    'makeACard'
      path:    'make'
      handler: MakeCard

Router.run routes, (handler) ->
  React.render handler(), (document.getElementById 'content')


