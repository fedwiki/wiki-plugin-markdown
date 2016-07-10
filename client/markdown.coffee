###
 * Federated Wiki : Markdown Plugin
 *
 * Licensed under the MIT license.
 * https://github.com/fedwiki/wiki-plugin-markdown/blob/master/LICENSE.txt
###

lineNumber = 0
totalLines = 0

headers = (line) ->
  line = line.replace /^#+(.*)$/, '<h3>$1</h3>'

emphasis = (line) ->
  line = line.replace /\*\*(\S.*?\S)\*\*/g, '<b>$1</b>'
  line = line.replace /\_\_(\S.*?\S)\_\_/g, '<b>$1</b>'
  line = line.replace /\*(\S.*?\S)\*/g, '<i>$1</i>'
  line = line.replace /\_(\S.*?\S)\_/g, '<i>$1</i>'
  line = line.replace /\*\*(\S)\*\*/g, '<b>$1</b>'
  line = line.replace /\_\_(\S)\_\_/g, '<b>$1</b>'
  line = line.replace /\*(\S)\*/g, '<i>$1</i>'
  line = line.replace /\_(\S)\_/g, '<i>$1</i>'

lists = (line) ->
  line = line.replace /^ *[*-] +(\[[ x]\])(.*)$/, (line, box, content) ->
    checked = if box == '[x]' then  ' checked' else ''
    "<li><input type=checkbox data-line=#{lineNumber}#{checked}>#{content}</li>"
  line = line.replace /^ *[*-] +(.*)$/, '<li>$1</li>'

escape = (line) ->
  line
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')

code = (line) ->
  line.replace /`(\S.*?\S)`/g, "<code>$1</code>"

breakLine = (line) ->
  exp = /// (
    [^>]+            # does not end with a tag
    | <\/(i|b|code)> # or the tag is an inline tag (<i>, <b> or <code>)
  ) $ ///

  if lineNumber != totalLines - 1 and exp.test line
    "#{line}<br>"
  else
    line

expand = (text) ->
  lines = text.split /\n/
  totalLines = lines.length
  lineNumber = -1

  output = for line in lines
    lineNumber++
    breakLine emphasis headers lists code escape line
  output.join ""

emit = ($item, item) ->
  $item.append """
    <p>
      #{wiki.resolveLinks item.text, expand}
    </p>
  """

toggle = (item, lineNumber) ->
  lines = item.text.split /\n/
  lines[lineNumber] = lines[lineNumber].replace /\[[ x]\]/, (box) ->
    if box == '[x]' then '[ ]' else '[x]'
  item.text = lines.join "\n"

bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item
  $item.find('[type=checkbox]').change (e) ->
    toggle item, $(e.target).data('line')
    $item.empty()
    emit($item, item)
    bind($item, item)
    wiki.pageHandler.put $item.parents('.page:first'),
      type: 'edit',
      id: item.id,
      item: item

window.plugins.markdown = {emit, bind} if window?
module.exports = {expand} if module?
