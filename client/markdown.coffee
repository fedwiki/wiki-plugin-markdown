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
  line = line.replace /^ *[*-](.*)$/, '<li>$1</li>'

expand = (text) ->
  (emphasis headers lists line for line in text.split /\n/).join "\n"

emit = ($item, item) ->
  $item.append """
    <p>
      #{expand wiki.resolveLinks item.text}
    </p>
  """

bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item

window.plugins.markdown = {emit, bind} if window?
module.exports = {expand} if module?
