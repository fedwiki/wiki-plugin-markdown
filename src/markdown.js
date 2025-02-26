/*
 * Federated Wiki : Markdown Plugin
 *
 * Licensed under the MIT license.
 * https://github.com/fedwiki/wiki-plugin-markdown/blob/master/LICENSE.txt
 */

import { marked } from 'marked'
import DOMPurify from 'isomorphic-dompurify'

let dataLine = 0

const renderer = new marked.Renderer()

// wiki headings are always h3
renderer.heading = ({ tokens, depth }) => {
  const text = renderer.parser.parseInline(tokens)
  // all sub headings will be level 3
  return '<h3>' + text + '</h3>'
}

// modify listitem renderer, so we can know which checkbox has been clicked
renderer.listitem = ({ tokens, task, checked }) => {
  let text = renderer.parser.parse(tokens)
  if (task) {
    dataLine++
    text = text.replace(/^.*?> /, '')
    return `<li class="task-list-item"><input type="checkbox" class="task-list-item-checkbox" data-line=${dataLine}${checked ? ' checked' : ''}>${text}</li>\n`
  } else {
    return `<li>${text}</li>\n`
  }
}

// we are opinionated about images - they should make use of the image plugin
renderer.image = ({ href, title, text }) => {
  return `
    ![${text}](${href} ${text ? text : ''})
  `
}

const markedOptions = {
  gfm: true,
  renderer: renderer,
  linksInNewTab: true,
  breaks: true,
  mangle: false,
  headerIds: false,
}

const expand = text => {
  dataLine = 0
  return DOMPurify.sanitize(marked.parse(text, markedOptions))
}

const emit = ($item, item) => {
  if (!$("link[href='/plugins/markdown/markdown.css']").length) {
    $('<link rel="stylesheet" href="/plugins/markdown/markdown.css" type="text/css">').appendTo('head')
  }

  $item.append(`
      ${wiki.resolveLinks(item.text, expand)}
  `)

  if (item.graph) {
    $item.addClass('graph-source')
    $item.get(0).graphData = () => {
      const graph = {}
      const title = $item.parents('.page').find('h1').text().trim()
      graph[title] = links = []
      for (const match of item.text.matchAll(/\[\[(.+?)\]\]/g)) {
        const link = match[0].slice(2, -2)
        links.push(link)
        graph[link] = []
      }
      return graph
    }
  }
}

const toggle = (item, taskNumber) => {
  let n = 0
  item.text = item.text.replace(/\[[ x]\]/g, (box, i, original) => {
    n++
    const newBox = box === '[x]' ? '[ ]' : '[x]'
    return n === taskNumber ? newBox : box
  })
}

const bind = ($item, item) => {
  $item.on('dblclick', () => wiki.textEditor($item, item))
  $item.find('[type=checkbox]').on('change', e => {
    toggle(item, $(e.target).data('line'))
    $item.empty()
    emit($item, item)
    bind($item, item)
    wiki.pageHandler.put($item.parents('.page:first'), {
      type: 'edit',
      id: item.id,
      item: item,
    })
  })
}

if (typeof window !== 'undefined') {
  window.plugins.markdown = { emit, bind }
}

export const markdown = typeof window == 'undefined' ? { expand } : undefined
