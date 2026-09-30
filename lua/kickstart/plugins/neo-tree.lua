-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '<leader>e', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

require('neo-tree').setup {
  default_component_configs = {
    type = {
      enabled = false,
    },
    last_modified = {
      enabled = false,
    },
  },

  filesystem = {
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
    window = {
      position = 'left',
      auto_expand_width = false,
      mappings = {
        -- Keep <Space> available as the Neovim leader key in Neo-tree.
        ['<space>'] = 'noop',
        ['q'] = 'close_window',
        ['Y'] = function(state)
          local node = state.tree:get_node()
          if node and node.path then
            vim.fn.setreg('+', node.path)
            vim.notify('Copied path: ' .. node.path)
          end
        end,
      },
    },
  },
}
