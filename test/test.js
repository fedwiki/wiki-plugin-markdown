import { markdown } from '../src/markdown.js'
import { describe, it } from 'node:test'
import expect from 'expect.js'

// inspired by https://guides.github.com/features/mastering-markdown/

describe('markdown plugin', () => {
  describe('headers', () => {
    // test headers as we have a renderer to make all headers level 3

    it('can turn ### into h3', () => {
      const result = markdown.expand('### heading')
      expect(result).to.be('<h3>heading</h3>')
    })

    it('will turn # into h3 too', () => {
      const result = markdown.expand('# heading')
      expect(result).to.be('<h3>heading</h3>')
    })

    it('can do ### on many lines', () => {
      const result = markdown.expand('# one\n## two')
      expect(result).to.be('<h3>one</h3><h3>two</h3>')
    })
  })

  describe('task lists', () => {
    it('can turn lines into incomplete tasks', () => {
      const result = markdown.expand('- [ ] hello world')
      expect(result).to.be(
        '<ul>\n<li class="task-list-item"><input data-line="1" class="task-list-item-checkbox" type="checkbox">hello world</li>\n</ul>\n',
      )
    })

    it('can turn lines into complete tasks', () => {
      const result = markdown.expand('- [x] hello world')
      expect(result).to.be(
        '<ul>\n<li class="task-list-item"><input checked="" data-line="1" class="task-list-item-checkbox" type="checkbox">hello world</li>\n</ul>\n',
      )
    })
  })
})
