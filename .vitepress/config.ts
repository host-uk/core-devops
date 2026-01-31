import { defineConfig } from 'vitepress'

const pkg = 'devops'
const canonical = `https://core.help/packages/${pkg}/`

export default defineConfig({
  title: 'Host UK DevOps',
  description: 'Developer workspace orchestrator for Host UK',

  srcDir: 'doc',
  outDir: '.vitepress/dist',

  head: [
    ['link', { rel: 'canonical', href: canonical }],
    ['meta', { property: 'og:site_name', content: 'Host UK Documentation' }],
  ],

  themeConfig: {
    nav: [
      { text: 'Home', link: '/' },
      { text: 'core.help', link: 'https://core.help' },
    ],

    sidebar: [
      {
        text: 'Guide',
        items: [
          { text: 'Introduction', link: '/' },
          { text: 'Quick Start', link: '/quick-start' },
          { text: 'Commands', link: '/commands' },
        ]
      },
      {
        text: 'Configuration',
        items: [
          { text: '.core/ Folder', link: '/core-folder' },
          { text: 'repos.yaml', link: '/repos-yaml' },
        ]
      },
      {
        text: 'Reference',
        items: [
          { text: 'Package Types', link: '/package-types' },
          { text: 'Troubleshooting', link: '/troubleshooting' },
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/host-uk/core-devops' }
    ],

    footer: {
      message: 'Released under the EUPL-1.2 License.',
      copyright: 'Copyright © Host UK'
    },

    search: {
      provider: 'local'
    },

    editLink: {
      pattern: 'https://github.com/host-uk/core-devops/edit/dev/doc/:path',
      text: 'Edit this page on GitHub'
    }
  },

  sitemap: {
    hostname: canonical
  },

  transformHead({ pageData }) {
    const head: any[] = []
    const pagePath = pageData.relativePath.replace(/\.md$/, '.html').replace(/index\.html$/, '')
    head.push(['link', { rel: 'canonical', href: `${canonical}${pagePath}` }])
    return head
  }
})
