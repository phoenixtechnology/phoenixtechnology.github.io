Parse   = require('parse').Parse
_       = require 'lodash'

module.exports =

  getAllCards: (next) =>

    setCards = (results) =>

      cards = _.map results, (result, resultIndex) =>
        result.attributes['createdAt'] = result.createdAt
        result.attributes['_id'] = result.id
        result.attributes

      cards = _.sortBy cards, (card) ->
        card.highestReplyChild

      next cards

    Card = Parse.Object.extend 'Card'
    query = new Parse.Query Card
    query.find

      success: setCards
    
      error: (object, error) ->
        console.log 'DANG ERROR', object, error


  getSearchedCards: (searchTerm, next) =>

    setCards = (results) =>

      cards = _.map results, (result, resultIndex) =>
        result.attributes[ 'createdAt' ]  = result.createdAt
        result.attributes[ '_id' ]        = result.id
        result.attributes

      next cards

    Card = Parse.Object.extend 'Card'

    query = new Parse.Query Card
    query.equalTo 'tags', searchTerm
    query.find

      success: (results) ->
        setCards results
      
      error: (object, error) ->
        console.log 'Did not worked :(', object, error



