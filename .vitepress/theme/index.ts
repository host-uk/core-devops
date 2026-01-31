import { h } from 'vue'
import DefaultTheme from 'vitepress/theme'
import type { Theme } from 'vitepress'
import './custom.css'

const Banner = () => {
  return h('div', { class: 'dev-banner' }, [
    h('span', '📚 Developer preview. '),
    h('a', { href: 'https://core.help/packages/devops/', target: '_blank' }, 'Visit core.help'),
    h('span', ' for the complete documentation.')
  ])
}

export default {
  extends: DefaultTheme,
  Layout() {
    return h(DefaultTheme.Layout, null, {
      'layout-top': () => h(Banner)
    })
  }
} satisfies Theme
