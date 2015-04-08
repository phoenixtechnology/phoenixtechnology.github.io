React   = require 'react'
_       = require 'lodash'

{formatPostNumber, formatDate, makeTwoDigits, shortener, breakIntoParagraphs} = require './functionsOfConvenience.coffee'

# DOM Elements
{p, div, input, textarea, a, img} = React.DOM

module.exports = (card, cardIndex, open) ->

  div
    className:  'card'
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
        href:           card.image
        style:
          display:      'inline-block'
        img
          src:          card.image
          style:
            width:      'auto'
            height:     'auto'
            maxHeight:  425
            maxWidth:   425
      
      div
        style:
          verticalAlign:  'top'
          marginLeft:     '1em'
          display:        'inline-block'

        p
          className:    'tiny'
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
