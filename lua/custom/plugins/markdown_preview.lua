-- Preview Markdown in the browser, including Mermaid diagrams.
vim.pack.add { 'https://github.com/iamcco/markdown-preview.nvim' }

-- The preview commands only exist in Markdown buffers.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function(ev)
    vim.keymap.set('n', '<leader>tp', '<cmd>MarkdownPreviewToggle<cr>', {
      buffer = ev.buf,
      desc = '[T]oggle Markdown [P]review',
    })
  end,
})
