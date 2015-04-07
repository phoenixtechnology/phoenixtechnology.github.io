# Libraries
React   = require 'react'
Parse   = require('parse').Parse
_       = require 'lodash'
Router  = require 'react-router'

CardsStore = require './cards.store.coffee'

# DOM Elements
{p, div, input, textarea, a, img} = React.DOM


{formatPostNumber, formatDate, makeTwoDigits, shortener, breakIntoParagraphs} = require './functionsOfConvenience.coffee'


cardTemplate = (card, cardIndex, open) ->

  div
    className: 'card'
    style:
      overflow: 'hidden'

    div null,
      p
        style:
          display: 'inline-block'
        className: 'title'
        shortener card.title

      a
        style:
          display:    'inline-block'
          float:      'right'
          cursor:     'pointer'
        className:    'exit'
        'data-id':    card._id
        onClick:      open
        'open'

    div null,

      a
        href: card.image
        style:
          display: 'inline-block'
        img
          src:   card.image
          style:
            width: 'auto'
            height: 'auto'
            maxHeight: 425
            maxWidth: 425
      
      div
        style:
          verticalAlign: 'top'
          marginLeft: '1em'
          display: 'inline-block'

        p
          className: 'tiny'
          style:
            fontWeight: 'bold'
          card.name

        p
          className: 'tiny'
          card.hash.slice 0, 13

        p
          className: 'tiny'
          formatDate card.createdAt

        p
          className: 'tiny'
          formatPostNumber card.postNumber

        p
          className: 'tiny'
          'tags:'

        _.map card.tags, (tag) ->

          p
            className: 'tiny'
            tag

    _.map breakIntoParagraphs(card.content), (paragraph) ->
      
      p
        className: 'point'
        paragraph



CardsView = React.createClass


  mixins: [ Router.Navigation, Router.State ]


  # getInitialState: ->
  #   CardsStore.getAllCards (cards) =>
  #     @setState cards: cards




  open: (event) ->
    postId = event.target.getAttribute 'data-id'
    @transitionTo '/post/' + postId
    # @props.open event.target.getAttribute 'data-id'



  render: ->

    div null,

      div
        style:
          display: 'inline-block'
          verticalAlign: 'top'

        _.map (@props.cards?.slice 0, (@props.cards.length / 2)), (card, cardIndex) =>
          cardTemplate card, cardIndex, @open


      div
        style:
          display: 'inline-block'
          verticalAlign: 'top'

        _.map (@props.cards?.slice (@props.cards.length / 2), @props.cards.length), (card, cardIndex) =>
          cardTemplate card, cardIndex + (@props.cards.length / 2), @open



module.exports = React.createFactory CardsView