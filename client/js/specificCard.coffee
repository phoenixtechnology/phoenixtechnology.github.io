# Libraries
React   = require 'react'
Parse   = require('parse').Parse
Router  = require 'react-router'
SHA256  = require 'crypto-js/sha256'
_       = require 'lodash'

Reply = Parse.Object.extend 'Reply'
Card  = Parse.Object.extend 'Card'

# DOM Elements
{p, div, input, textarea, a, img} = React.DOM


formatPostNumber = (postNumber) ->
  asString = '' + postNumber
  while asString.length < 10
    asString = '0' + asString

  '>>' + asString  


makeTwoDigits = (digit) ->
  if (digit + '').length < 2
    '0' + digit
  else
    digit


formatDate = (date) ->
  formattedDate = ''
  formattedDate += date.getFullYear()
  formattedDate += makeTwoDigits(date.getMonth() + 1)
  formattedDate += makeTwoDigits(date.getDate() + 1)  + ' '
  formattedDate += makeTwoDigits(date.getHours())     + ':'
  formattedDate += makeTwoDigits(date.getMinutes() )  + ' '

  formattedDate


shortener = (string) ->
  if string.length > 40
    string.slice(0,40) + '..'
  else
    string


breakIntoParagraphs = (content) ->
  paragraphs = ['']
  paragraphIndex = 0

  for char in content
    if char isnt '\n'
      paragraphs[ paragraphIndex ] += char
    else
      paragraphs.push ''
      paragraphIndex++

  paragraphs


Card = React.createClass

  mixins: [ Router.Navigation, Router.State ]

  componentWillMount: ->
    
    postId = @getParams().postId

    CardObject = Parse.Object.extend 'Card'

    query = new Parse.Query(CardObject)
    query.get postId,
      success: (foundCard) =>

        @setState thisCard: foundCard, =>

          Reply = Parse.Object.extend 'Reply'

          repliesQuery = new Parse.Query(Reply)
          repliesQuery.equalTo 'parentCard', 
            __type:     'Pointer'
            className:  'Card'
            objectId:   @state.thisCard.id

          repliesQuery.find 
            success: (results) =>
              replies = _.map results, (queryItem) ->
                reply = queryItem.attributes
                reply.id = queryItem.id
                reply.createdAt = queryItem.createdAt
                reply

              @setState replies: replies

              # @setState 
              #   replies: 
              #   =>
              #     console.log @state.replies

            error: (object, error) ->
              console.log object, error




  getInitialState: ->
    replyContent: ''
    replyName:    ''
    replyHash:    ''
    replyImage:   ''


  exit: ->
    @transitionTo 'Main'


  contentHandle: (event) ->
    @setState replyContent: event.target.value


  hashHandle: (event) ->
    @setState replyHash: event.target.value


  nameHandle: (event) ->
    @setState replyName: event.target.value


  submitReply: ->

    makeNewReply = (postNumber) =>

      newReply = new Reply()
      newReply.set 'content',     @state.replyContent
      newReply.set 'name',        @state.replyName
      newReply.set 'image',       @state.replyImage
      newReply.set 'postNumber',  postNumber
      newReply.set 'parentCard',
        __type:     'Pointer'
        className:  'Card'
        objectId:   @state.thisCard.id
      if @state.replyHash isnt ''
        newReply.set 'hash', (SHA256 @state.hash).toString()
      else
        newReply.set 'hash', ''


      newReply.save null,

        success: =>
          location.reload()

        error: (object, error) ->
          console.log 'did not worked :(', object, error

    PostCount = Parse.Object.extend 'PostCount'
    query = new Parse.Query(PostCount)
    query.get "wmVCATl0Wb",

      success: (postCount) =>
        makeNewReply postCount.attributes.total

      error: (object, error) =>
        console.log 'ERROR IS', object, error


  imageHandle: ->
    reader = new FileReader()
    file   = event.target.files[0]

    replysImage = new Parse.File 'image.png', file

    replysImage.save().then =>
      @setState replyImage: replysImage._url


  render: ->

    if @state.thisCard?
      card            = @state.thisCard.attributes
      card._id        = @state.thisCard.id
      card.createdAt  = @state.thisCard.createdAt

      div
        className: 'specificCard'
        style:
          overflow: 'hidden'

        div null,
          p
            style:
              display: 'inline-block'
            className: 'title'
            card.title

          a
            style:
              display:    'inline-block'
              float:      'right'
              cursor:     'pointer'
            className:    'exit'
            'data-id':    card._id
            onClick:      @exit
            'X'

        div null,

          div
            style:
              display: 'inline-block'

            a
              href: card.image
              img
                src:   card.image
                style:
                  width: 'auto'
                  height: 'auto'
                  maxHeight: 800
                  maxWidth:  800
          
          div
            style:
              verticalAlign: 'top'
              marginLeft: '1em'
              display: 'inline-block'

            p
              className: 'point'
              style:
                fontWeight: 'bold'
              card.name

            p
              className: 'point'
              card.hash.slice 0, 13

            p
              className: 'point'
              formatDate card.createdAt

            p
              className: 'point'
              formatPostNumber card.postNumber

            p
              className: 'point'
              'tags:'

            _.map card.tags, (tag) ->

              p
                className: 'point'
                tag

        p
          className: 'point'
          ''

        div
          style:
            verticalAlign: 'top'
            marginLeft: '1em'
            display: 'inline-block'
            width: '100%'
            height: '100%'

          _.map breakIntoParagraphs(card.content), (paragraph) ->
            
            p
              className: 'point'
              paragraph

        p
          className: 'point'
          ''

        p
          className: 'tiny'
          'replies'

        _.map @state.replies, (reply) ->

          div
            style:
              marginTop: '1em'
              borderStyle: 'dotted'
              borderWidth: '1px'
              borderColor: '#9d9d9d'
              padding: '1em'

            div null,

              p 
                className: 'point'
                style:
                  display: 'inline-block'
                reply.name

              p
                className: 'point'
                style:
                  display: 'inline-block'
                  marginLeft: '1em'
                reply.hash.slice 0, 13

              p
                className: 'point'
                style:
                  display: 'inline-block'
                  marginLeft: '1em'
                formatDate reply.createdAt
              
              p
                className: 'point'
                style:
                  display: 'inline-block'
                  marginLeft: '1em'
                formatPostNumber reply.postNumber

            p
              className: 'point'
              ''

            div null,

              if reply.image
                a
                  href: reply.image
                  style:
                    display: 'inline-block'
                    marginRight: '1em'
                  img
                    src: reply.image
                    style:
                      maxWidth: 200
                      maxHeight: 200
                      width: 'auto'
                      height: 'auto'

              div
                style:
                  verticalAlign: 'top'
                  display: 'inline-block'
                  width: 675
  
                _.map breakIntoParagraphs(reply.content), (paragraph) ->

                  p
                    className: 'point'
                    paragraph

        p
          className: 'point'
          ''

        input
          className:   'input'
          placeholder: 'Name'
          value:       @state.replyName
          onChange:    @nameHandle

        input
          className:   'input'
          placeholder: 'Hash'
          value:       @state.replyHash
          onChange:    @hashHandle

        textarea
          className:   'inputArea'
          placeholder: 'Reply'
          style:
            height:    '300px'
          value:       @state.replyContent
          onChange:    @contentHandle

        div null,

          input
            style:
              display: 'inline-block'
            className: 'submit'
            type:      'submit'
            value:     'Reply'
            onClick:   @submitReply

          input
            style:
              display:    'inline-block'
              marginLeft: '1em'
            type:         'file'
            onChange:     @imageHandle

    else
      div null


module.exports = React.createFactory Card