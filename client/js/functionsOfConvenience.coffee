module.exports =

  formatPostNumber: (postNumber) ->
    asString = '' + postNumber
    while asString.length < 10
      asString = '0' + asString

    '>>' + asString  


  makeTwoDigits: (digit) ->
    if (digit + '').length < 2
      '0' + digit
    else
      digit


  formatDate: (date) ->
  
    makeTwoDigits = (digit) ->
      if (digit + '').length < 2
        '0' + digit
      else
        digit

    formattedDate = ''
    formattedDate += date.getFullYear()
    formattedDate += makeTwoDigits(date.getMonth() + 1)
    formattedDate += makeTwoDigits(date.getDate() + 1)  + ' '
    formattedDate += makeTwoDigits(date.getHours())     + ':'
    formattedDate += makeTwoDigits(date.getMinutes() )  + ' '

    formattedDate


  shortener: (string) ->
    if string.length > 40
      string.slice(0,40) + '..'
    else
      string


  breakIntoParagraphs: (content) ->
    paragraphs = ['']
    paragraphIndex = 0

    for char in content
      if char isnt '\n'
        paragraphs[ paragraphIndex ] += char
      else
        paragraphs.push ''
        paragraphIndex++

    paragraphs