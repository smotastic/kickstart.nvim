-- Render Markdown tables directly in the current buffer.
vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }

local render_markdown = require 'render-markdown'

render_markdown.setup {
  -- Keep the current Markdown appearance and improve pipe tables.
  heading = { enabled = false },
  code = { enabled = false },
  dash = { enabled = false },
  bullet = { enabled = false },
  checkbox = { enabled = false },
  quote = { enabled = false },
  link = { enabled = false },
  inline_highlight = { enabled = false },
  latex = { enabled = false },
  html = { enabled = false },
  pipe_table = {
    preset = 'round',
    cell = 'padded',
  },
}

vim.keymap.set('n', '<leader>tm', render_markdown.toggle, {
  desc = '[T]oggle [M]arkdown rendering',
})
