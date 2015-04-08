# Libraries
React   = require 'react'
Parse   = require('parse').Parse
Router  = require 'react-router'
SHA256  = require 'crypto-js/sha256'
_       = require 'lodash'

Card = Parse.Object.extend 'Card'

# DOM Elements
{p, div, input, textarea, a} = React.DOM


MakeCard = React.createClass


  mixins: [ Router.Navigation, Router.State ]


  getInitialState: ->
    title:    ''
    name:     ''
    hash:     ''
    content:  ''
    tags:     []
    tag:      ''
    image:    ''

  
  titleHandle: (event) ->
    @setState title: event.target.value


  nameHandle: (event) ->
    @setState name: event.target.value


  hashHandle: (event) ->
    @setState hash: event.target.value


  tagHandle: (event) ->
    @setState tag: event.target.value


  tagPressHandle: (event) ->
    if event.key is 'Enter'
      if @state.tags.length < 7
        tags = @state.tags
        tag = @state.tag.toLowerCase()
        tag = tag.trim()
        if not (tag in tags)
          tags.push tag
          @setState tags: tags, =>
            @setState tag: ''
        else
          @setState tag: ''


  removeTag: (event) ->
    tagIndex = event.target.getAttribute 'data-index'
    tags = @state.tags
    tags.splice tagIndex, 1
    @setState tags: tags


  contentHandle: (event) ->
    if event.target.value.length < 2880
      @setState content: event.target.value


  imageHandle: (event) ->
    reader = new FileReader()
    file   = event.target.files[0]

    cardsImage = new Parse.File 'image.png', file

    cardsImage.save().then =>
      @setState image: cardsImage._url


  exit: ->
    @transitionTo 'Main'


  submitNewCard: ->

    makeNewCard = (cardNumber) =>

      newCard = new Card()
      newCard.set 'content',    @state.content
      newCard.set 'name',       @state.name
      newCard.set 'title',      @state.title
      newCard.set 'tags',       @state.tags
      newCard.set 'image',      @state.image
      newCard.set 'postNumber', cardNumber
      if @state.hash isnt ''
        newCard.set 'hash', (SHA256 @state.hash).toString()
      else
        newCard.set 'hash', ''

      newCard.save null, 
        success: ->

        error: (object, error) ->
          console.log 'did not worked :(', object, error


    PostCount = Parse.Object.extend 'PostCount'

    query = new Parse.Query PostCount
    query.get "wmVCATl0Wb",

      success: (postCount) =>
        makeNewCard( postCount.attributes.total )
    
      error: (object, error) =>
        console.log 'ERROR IS', object, error



  render: ->


    div 
      className: 'makeACard'
      style:
        width: 1000
        marginLeft: 'auto'
        marginRight: 'auto'

      div null,

        p 
          style:
            display: 'inline-block'
          className: 'point'
          'New Card'

        a
          style:
            display: 'inline-block'
            float:   'right'
            cursor:  'pointer'
          className: 'exit'
          onClick: @exit
          'X'

      input
        className:   'input'
        placeholder: 'Card Title'
        value:       @state.title
        onChange:    @titleHandle

      input
        className:   'input'
        placeholder: 'Name'
        value:       @state.name
        onChange:    @nameHandle

      input
        className:   'input'
        placeholder: 'Hash'
        value:       @state.hash
        onChange:    @hashHandle

      input
        className:   'input'
        placeholder: 'Tags'
        value:       @state.tag
        onChange:    @tagHandle
        onKeyPress:  @tagPressHandle

      div null,

        _.map @state.tags, (tag, tagIndex) =>
          p
            className:    'tag'
            style:
              display:    'inline-block'
              cursor:     'pointer'
            'data-index': tagIndex
            onClick:      @removeTag
            tag + ' X'


      textarea
        className:   'inputArea'
        placeholder: 'Content'
        style:
          height:    '300px'
        value:       @state.content
        onChange:    @contentHandle


      div null,

        input
          style:
            display: 'inline-block'
          className: 'submit'
          type:      'submit'
          value:     'Post'
          onClick:   @submitNewCard

        input
          style:
            display:    'inline-block'
            marginLeft: '1em'
          type:         'file'
          onChange:     @imageHandle



module.exports = React.createFactory MakeCard