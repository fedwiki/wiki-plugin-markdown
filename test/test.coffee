markdown = require '../client/markdown'
expect = require 'expect.js'

# inspired by https://guides.github.com/features/mastering-markdown/

describe 'markdown plugin', ->

  describe 'headers', ->

    it 'can turn ### into h3', ->
      result = markdown.expand '###heading'
      expect(result).to.be '<h3>heading</h3>'

    it 'will ignore ### most places', ->
      result = markdown.expand '  ###heading'
      expect(result).to.be '  ###heading'

    it 'will turn # into h3 too', ->
      result = markdown.expand '#heading'
      expect(result).to.be '<h3>heading</h3>'

    it 'can do ### on many lines', ->
      result = markdown.expand '###one\n###two'
      expect(result).to.be '<h3>one</h3>\n<h3>two</h3>'

  describe 'emphasis', ->

    it 'can turn * ... * into italic', ->
      result = markdown.expand 'hello *world*'
      expect(result).to.be 'hello <i>world</i>'

    it 'can turn _ ... _ into italic', ->
      result = markdown.expand 'hello _world_'
      expect(result).to.be 'hello <i>world</i>'

    it 'can convert multipe italic per line', ->
      result = markdown.expand '_hello_ _world_'
      expect(result).to.be '<i>hello</i> <i>world</i>'

    it 'can convert multiple words per italic', ->
      result = markdown.expand '_hello world_'
      expect(result).to.be '<i>hello world</i>'

    it 'must start with non-blank', ->
      result = markdown.expand 'hello_ world_'
      expect(result).to.be 'hello_ world_'

    it 'must end with non-blank', ->
      result = markdown.expand '_hello _world'
      expect(result).to.be '_hello _world'

    it 'can convert a single non-blank', ->
      result = markdown.expand '_x_'
      expect(result).to.be '<i>x</i>'

    it 'can turn ** ... ** into bold', ->
      result = markdown.expand 'hello **world**'
      expect(result).to.be 'hello <b>world</b>'

    it 'can turn __ ... __ into bold', ->
      result = markdown.expand 'hello __world__'
      expect(result).to.be 'hello <b>world</b>'

    it 'can convert multipe bold per line', ->
      result = markdown.expand '__hello__ __world__'
      expect(result).to.be '<b>hello</b> <b>world</b>'

    it 'can convert multiple words per bold', ->
      result = markdown.expand '__hello world__'
      expect(result).to.be '<b>hello world</b>'

#   it 'must start with non-blank', ->
#     result = markdown.expand 'hello__ world__'
#     expect(result).to.be 'hello__ world__'

#   it 'must end with non-blank', ->
#     result = markdown.expand '__hello __world'
#     expect(result).to.be '__hello __world'

#   it 'can convert a single non-blank', ->
#     result = markdown.expand '__x__'
#     expect(result).to.be '<b>x</b>'

  describe 'unordered lists', ->

    it 'can turn * lines into lists', ->
      result = markdown.expand '*hello world'
      expect(result).to.be '<li>hello world</li>'

    it 'can tell * lines from italic', ->
      result = markdown.expand '*hello *world*'
      expect(result).to.be '<li>hello <i>world</i></li>'

    it 'can skip space before * lines', ->
      result = markdown.expand '  *hello world'
      expect(result).to.be '<li>hello world</li>'

    it 'can turn - lines into lists', ->
      result = markdown.expand '-hello world'
      expect(result).to.be '<li>hello world</li>'

    it 'can turn lines into incomplete tasks', ->
      result = markdown.expand '-[ ] hello world'
      expect(result).to.be '<li><span class=task line=0>[ ]</span> hello world</li>'

    it 'can turn lines into complete tasks', ->
      result = markdown.expand '-[x] hello world'
      expect(result).to.be '<li><span class=task line=0>[x]</span> hello world</li>'

