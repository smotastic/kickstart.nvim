-- Color matching brackets and braces by nesting level.
vim.pack.add {
  'https://github.com/HiPhish/rainbow-delimiters.nvim',
}

require('rainbow-delimiters.setup').setup {}
