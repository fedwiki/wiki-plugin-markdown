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
      expect(result).to.be '<h3>one</h3><h3>two</h3>'

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
      result = markdown.expand '* hello world'
      expect(result).to.be '<li>hello world</li>'

    it 'can tell * lines from italic', ->
      result = markdown.expand '* hello *world*'
      expect(result).to.be '<li>hello <i>world</i></li>'

    it 'can skip space before * lines', ->
      result = markdown.expand '  * hello world'
      expect(result).to.be '<li>hello world</li>'

    it 'can turn - lines into lists', ->
      result = markdown.expand '- hello world'
      expect(result).to.be '<li>hello world</li>'

    it 'must have at least one space after list marker', ->
      result = markdown.expand '-hello world'
      expect(result).to.be '-hello world'

    it 'can have more than one space after list marker', ->
      result = markdown.expand '-     hello world'
      expect(result).to.be '<li>hello world</li>'

    it 'can turn lines into incomplete tasks', ->
      result = markdown.expand '- [ ] hello world'
      expect(result).to.be '<li><input type=checkbox data-line=0> hello world</li>'

    it 'can turn lines into complete tasks', ->
      result = markdown.expand '- [x] hello world'
      expect(result).to.be '<li><input type=checkbox data-line=0 checked> hello world</li>'

    it 'must have at least one space after list marker and before incomplete tasks', ->
      result = markdown.expand '-[ ] hello world'
      expect(result).to.be '-[ ] hello world'

    it 'must have at least one space after list marker and before complete tasks', ->
      result = markdown.expand '-[x] hello world'
      expect(result).to.be '-[x] hello world'

  describe 'code blocks', ->

    it 'can turn ` ... ` into code block', ->
      result = markdown.expand 'hello `world`'
      expect(result).to.be 'hello <code>world</code>'

    it 'can convert multipe code blocks per line', ->
      result = markdown.expand '`hello` `world`'
      expect(result).to.be '<code>hello</code> <code>world</code>'

    it 'ignores last back tick on odd number of back ticks', ->
      result = markdown.expand '`hello` `world'
      expect(result).to.be '<code>hello</code> `world'

  describe 'breaks', ->

    it 'adds a break element at the end of a line', ->
      result = markdown.expand 'hello\nworld'
      expect(result).to.be 'hello<br>world'

    it 'adds a break element at the end of lines ending with inline elements', ->
      result = markdown.expand '__Lorem__\n*ipsum*\ndolor\n`code`\nlast element'
      expect(result).to.be '<b>Lorem</b><br><i>ipsum</i><br>dolor<br><code>code</code><br>last element'

    it "doesn't add a break element after block elements", ->
      result = markdown.expand '- [x] hello world\n###lorem ipsum'
      expect(result).to.be '<li><input type=checkbox data-line=0 checked> hello world</li><h3>lorem ipsum</h3>'
