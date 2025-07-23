import { markdown } from '../src/markdown.js'
import { describe, it } from 'node:test'
import assert from 'node:assert/strict'
import { JSDOM } from 'jsdom'

// inspired by https://guides.github.com/features/mastering-markdown/

describe('markdown plugin', () => {
  describe('headers', () => {
    // test headers as we have a renderer to make all headers level 3

    it('can turn ### into h3', () => {
      const result = markdown.expand('### heading')
      assert.equal('<h3>heading</h3>', result)
    })

    it('will turn # into h3 too', () => {
      const result = markdown.expand('# heading')
      assert.equal('<h3>heading</h3>', result)
    })

    it('can do ### on many lines', () => {
      const result = markdown.expand('# one\n## two')
      assert.equal('<h3>one</h3><h3>two</h3>', result)
    })
  })

  describe('task lists', () => {
    it('can turn lines into incomplete tasks', () => {
      const result = markdown.expand('- [ ] hello world')
      const dom = new JSDOM(result)
      // we are expecting HTML like `<ul><li class="task-list-item"><input data-line="1" class="task-list-item-checkbox" type="checkbox">hello world</li></ul>`
      const ul = dom.window.document.querySelector('ul')
      assert.ok(ul, 'ul element missing')
      assert.equal(1, ul.childElementCount)
      const li = ul.querySelector('li')
      assert.ok(li, 'li element missing')
      assert.equal('task-list-item', li.className)
      assert.equal('hello world', li.textContent)
      assert.equal(1, li.childElementCount)
      const input = li.querySelector('input')
      assert.ok(input, 'input element missing')
      assert.equal('task-list-item-checkbox', input.className)
      const inputAttrib = input.attributes
      assert.equal('1', inputAttrib.getNamedItem('data-line').value)
      assert.equal('checkbox', inputAttrib.getNamedItem('type').value)
      assert.equal(null, inputAttrib.getNamedItem('checked'))
    })

    it('can turn lines into complete tasks', () => {
      const result = markdown.expand('- [x] hello world')
      const dom = new JSDOM(result)
      // we are expecting HTML like `<ul><li class="task-list-item"><input checked="" data-line="1" class="task-list-item-checkbox" type="checkbox">hello world</li></ul>`,
      const ul = dom.window.document.querySelector('ul')
      assert.ok(ul, 'ul element missing')
      assert.equal(1, ul.childElementCount)
      const li = ul.querySelector('li')
      assert.ok(li, 'li element missing')
      assert.equal('task-list-item', li.className)
      assert.equal('hello world', li.textContent)
      assert.equal(1, li.childElementCount)
      const input = li.querySelector('input')
      assert.ok(input, 'input element missing')
      assert.equal('task-list-item-checkbox', input.className)
      const inputAttrib = input.attributes
      assert.equal('1', inputAttrib.getNamedItem('data-line').value)
      assert.equal('checkbox', inputAttrib.getNamedItem('type').value)
      assert.ok(inputAttrib.getNamedItem('checked'))
    })
  })
})
