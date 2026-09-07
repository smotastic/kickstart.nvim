-- Nebula Foundry
-- A graphite editor with violet panels and restrained nebula accents.

local palette = {
  -- The editor and file tree use the same calm graphite background.
  bg = '#202227',
  tree = '#272930',
  panel = '#202227',
  panel_alt = '#282A32',
  panel_warm = '#303139',
  selection = '#303139',
  line = '#3A3C45',
  line_soft = '#30323A',

  fg = '#D2D0D8',
  fg_soft = '#B7B3BF',
  muted = '#85838F',
  faint = '#686B76',

  -- Keep the violet family, but give each syntax group a clearer hue.
  purple = '#A88BC7',
  magenta = '#D07DBB',
  lavender = '#BBA9D8',
  indigo = '#8490C7',
  cyan = '#7FC6CC',
  green = '#88BC8F',
  green_soft = '#91C791',
  yellow = '#D3B56D',
  orange = '#D89B68',
  red = '#D77D87',
  pink = '#C995BC',

  ink = '#202027',
}

local function set(name, value)
  vim.api.nvim_set_hl(0, name, value)
end

vim.cmd.highlight('clear')
if vim.fn.exists('syntax_on') == 1 then vim.cmd.syntax('reset') end

vim.o.background = 'dark'
vim.o.termguicolors = true
vim.g.colors_name = 'nebula-foundry'

-- Core editor UI.
set('Normal', { fg = palette.fg, bg = palette.bg })
set('NormalNC', { fg = palette.fg, bg = palette.bg })
set('NormalFloat', { fg = palette.fg, bg = palette.panel_alt })
set('FloatBorder', { fg = palette.line, bg = palette.panel_alt })
set('FloatTitle', { fg = palette.magenta, bg = palette.panel_alt, bold = true })
set('SignColumn', { fg = palette.faint, bg = palette.bg })
set('EndOfBuffer', { fg = palette.bg, bg = palette.bg })
set('Cursor', { fg = palette.bg, bg = palette.lavender })
set('lCursor', { link = 'Cursor' })
set('CursorIM', { link = 'Cursor' })
-- Match the Neo-tree focus color so the active editor line is easy to see.
set('CursorLine', { bg = '#302E3B' })
set('CursorColumn', { bg = '#302E3B' })
set('CursorLineNr', { fg = palette.yellow, bold = true })
set('LineNr', { fg = palette.faint })
set('FoldColumn', { fg = palette.faint, bg = palette.bg })
set('Folded', { fg = palette.lavender, bg = palette.panel_alt })
set('ColorColumn', { bg = '#25272D' })
set('WinSeparator', { fg = palette.line, bg = palette.bg })
set('VertSplit', { link = 'WinSeparator' })
set('Visual', { bg = palette.selection })
set('VisualNOS', { link = 'Visual' })
set('Search', { fg = palette.ink, bg = palette.yellow, bold = true })
set('IncSearch', { fg = palette.ink, bg = palette.orange, bold = true })
set('CurSearch', { link = 'IncSearch' })
set('Substitute', { fg = palette.ink, bg = palette.magenta, bold = true })
set('MatchParen', { fg = palette.cyan, bg = palette.selection, bold = true, underline = true })
set('Conceal', { fg = palette.muted })
set('NonText', { fg = palette.line_soft })
set('Whitespace', { fg = '#454851' })
set('SpecialKey', { fg = palette.muted })
set('Directory', { fg = palette.indigo })
set('Title', { fg = palette.magenta, bold = true })
set('Question', { fg = palette.green })
set('MoreMsg', { fg = palette.cyan })
set('ModeMsg', { fg = palette.fg_soft, bold = true })
set('WarningMsg', { fg = palette.yellow })
set('ErrorMsg', { fg = palette.red, bold = true })
set('WildMenu', { fg = palette.ink, bg = palette.lavender })

-- Menus and command-line completion.
set('Pmenu', { fg = palette.fg, bg = palette.panel_alt })
set('PmenuSel', { fg = palette.fg, bg = palette.selection, bold = true })
set('PmenuSbar', { bg = palette.line })
set('PmenuThumb', { bg = palette.purple })
set('PmenuKind', { fg = palette.cyan, bg = palette.panel_alt })
set('PmenuKindSel', { fg = palette.cyan, bg = palette.selection })
set('PmenuExtra', { fg = palette.muted, bg = palette.panel_alt })
set('PmenuExtraSel', { fg = palette.fg_soft, bg = palette.selection })

-- Status line and tab line.
set('StatusLine', { fg = palette.fg, bg = palette.panel })
set('StatusLineNC', { fg = palette.muted, bg = palette.bg })
set('WinBar', { fg = palette.fg_soft, bg = palette.bg, bold = true })
set('WinBarNC', { fg = palette.muted, bg = palette.bg })
set('TabLine', { fg = palette.muted, bg = palette.panel })
set('TabLineFill', { bg = palette.bg })
set('TabLineSel', { fg = palette.fg, bg = palette.panel_alt, bold = true })

-- Diagnostics and version control.
set('DiagnosticError', { fg = palette.red })
set('DiagnosticWarn', { fg = palette.yellow })
set('DiagnosticInfo', { fg = palette.cyan })
set('DiagnosticHint', { fg = palette.purple })
set('DiagnosticOk', { fg = palette.green })
set('DiagnosticUnderlineError', { sp = palette.red, undercurl = true })
set('DiagnosticUnderlineWarn', { sp = palette.yellow, undercurl = true })
set('DiagnosticUnderlineInfo', { sp = palette.cyan, undercurl = true })
set('DiagnosticUnderlineHint', { sp = palette.purple, undercurl = true })
set('DiagnosticVirtualTextError', { fg = palette.red, bg = '#2E1A1A' })
set('DiagnosticVirtualTextWarn', { fg = palette.yellow, bg = '#302817' })
set('DiagnosticVirtualTextInfo', { fg = palette.cyan, bg = '#162A30' })
set('DiagnosticVirtualTextHint', { fg = palette.purple, bg = '#251A35' })
set('LspReferenceText', { bg = palette.selection })
set('LspReferenceRead', { bg = palette.selection })
set('LspReferenceWrite', { bg = palette.selection, underline = true })
set('DiffAdd', { fg = palette.green, bg = '#1A2E1A' })
set('DiffChange', { fg = palette.yellow, bg = '#302817' })
set('DiffDelete', { fg = palette.red, bg = '#2E1A1A' })
set('DiffText', { fg = palette.fg, bg = '#4A3A20', bold = true })
set('Added', { fg = palette.green })
set('Changed', { fg = palette.yellow })
set('Removed', { fg = palette.red })
set('GitSignsAdd', { fg = palette.green })
set('GitSignsChange', { fg = palette.yellow })
set('GitSignsDelete', { fg = palette.red })

-- Built-in syntax groups.
set('Comment', { fg = palette.muted })
set('Constant', { fg = palette.orange })
set('String', { fg = palette.green_soft })
set('Character', { fg = palette.green })
set('Number', { fg = palette.orange })
set('Boolean', { fg = palette.orange, bold = true })
set('Float', { fg = palette.orange })
set('Identifier', { fg = palette.fg })
set('Function', { fg = palette.purple })
set('Statement', { fg = palette.magenta })
set('Conditional', { fg = palette.magenta })
set('Repeat', { fg = palette.magenta })
set('Label', { fg = palette.cyan })
set('Operator', { fg = palette.cyan })
set('Keyword', { fg = palette.magenta })
set('Exception', { fg = palette.red })
set('PreProc', { fg = palette.pink })
set('Include', { fg = palette.pink })
set('Define', { fg = palette.pink })
set('Macro', { fg = palette.pink })
set('Type', { fg = palette.lavender })
set('StorageClass', { fg = palette.lavender })
set('Structure', { fg = palette.lavender })
set('Typedef', { fg = palette.lavender })
set('Special', { fg = palette.cyan })
set('SpecialChar', { fg = palette.cyan })
set('Tag', { fg = palette.magenta })
set('Delimiter', { fg = palette.fg_soft })
set('SpecialComment', { fg = palette.cyan })
set('Debug', { fg = palette.red })
set('Underlined', { fg = palette.indigo, underline = true })
set('Error', { fg = palette.red, undercurl = true })
set('Todo', { fg = palette.ink, bg = palette.yellow, bold = true })

-- Treesitter captures. Treesitter is Neovim's syntax parser.
set('@comment', { link = 'Comment' })
set('@none', {})
set('@variable', { fg = palette.fg })
set('@variable.builtin', { fg = palette.cyan })
set('@variable.parameter', { fg = palette.fg_soft })
set('@variable.member', { fg = palette.fg })
set('@constant', { fg = palette.orange })
set('@constant.builtin', { fg = palette.orange, bold = true })
set('@module', { fg = palette.lavender })
set('@label', { fg = palette.cyan })
set('@string', { fg = palette.green_soft })
set('@string.escape', { fg = palette.cyan })
set('@string.special', { fg = palette.cyan })
set('@character', { fg = palette.green })
set('@number', { fg = palette.orange })
set('@boolean', { fg = palette.orange, bold = true })
set('@float', { fg = palette.orange })
set('@function', { fg = palette.purple })
set('@function.builtin', { fg = palette.cyan })
set('@function.call', { fg = palette.purple })
set('@function.method', { fg = palette.purple })
set('@function.method.call', { fg = palette.purple })
set('@constructor', { fg = palette.lavender })
set('@keyword', { fg = palette.magenta })
set('@keyword.function', { fg = palette.magenta })
set('@keyword.operator', { fg = palette.cyan })
set('@keyword.return', { fg = palette.magenta })
set('@operator', { fg = palette.cyan })
set('@type', { fg = palette.lavender })
set('@type.builtin', { fg = palette.lavender, italic = true })
set('@type.definition', { fg = palette.lavender })
set('@property', { fg = palette.fg })
set('@field', { fg = palette.fg })
set('@attribute', { fg = palette.pink })
set('@parameter', { fg = palette.fg_soft })
set('@punctuation.delimiter', { fg = palette.fg_soft })
set('@punctuation.bracket', { fg = palette.fg_soft })
set('@punctuation.special', { fg = palette.cyan })
set('@tag', { fg = palette.magenta })
set('@tag.attribute', { fg = palette.lavender })
set('@tag.delimiter', { fg = palette.fg_soft })
set('@markup.heading', { fg = palette.magenta, bold = true })
set('@markup.strong', { fg = palette.fg, bold = true })
set('@markup.italic', { fg = palette.lavender, italic = true })
set('@markup.link', { fg = palette.indigo, underline = true })
set('@markup.link.url', { fg = palette.muted, underline = true })
set('@markup.raw', { fg = palette.green_soft, bg = palette.panel_alt })
set('@diff.plus', { fg = palette.green })
set('@diff.minus', { fg = palette.red })

-- Telescope.
set('TelescopeNormal', { fg = palette.fg, bg = palette.panel_alt })
set('TelescopeBorder', { fg = palette.line, bg = palette.panel_alt })
set('TelescopePromptNormal', { fg = palette.fg, bg = palette.panel })
set('TelescopePromptBorder', { fg = palette.line, bg = palette.panel })
set('TelescopePromptTitle', { fg = palette.ink, bg = palette.purple, bold = true })
set('TelescopePreviewTitle', { fg = palette.ink, bg = palette.green_soft, bold = true })
set('TelescopeResultsTitle', { fg = palette.ink, bg = palette.cyan, bold = true })
set('TelescopeSelection', { fg = palette.fg, bg = '#302E3B', bold = true })
set('TelescopeSelectionCaret', { fg = palette.magenta, bg = '#302E3B' })
set('TelescopeMatching', { fg = palette.yellow, bold = true })
set('TelescopeMultiSelection', { fg = palette.purple, bg = palette.selection })
set('TelescopePreviewNormal', { fg = palette.fg, bg = palette.bg })
set('TelescopePreviewBorder', { fg = palette.line, bg = palette.bg })
set('TelescopePreviewMatch', { fg = palette.yellow, bg = '#302817', bold = true })

-- Common navigation and completion plugins.
set('WhichKey', { fg = palette.cyan })
set('WhichKeyGroup', { fg = palette.purple })
set('WhichKeyDesc', { fg = palette.fg })
set('WhichKeySeparator', { fg = palette.muted })
set('WhichKeyValue', { fg = palette.green })
set('NvimTreeNormal', { fg = palette.fg, bg = palette.tree })
set('NvimTreeNormalNC', { fg = palette.fg_soft, bg = palette.tree })
set('NvimTreeFolderName', { fg = palette.fg_soft })
set('NvimTreeOpenedFolderName', { fg = palette.lavender, bold = true })
set('NvimTreeRootFolder', { fg = palette.magenta, bold = true })
set('NvimTreeGitNew', { fg = palette.green })
set('NvimTreeGitDirty', { fg = palette.yellow })
set('NeoTreeNormal', { fg = palette.fg, bg = palette.tree })
set('NeoTreeNormalNC', { fg = palette.fg_soft, bg = palette.tree })
-- Make the active Neo-tree row clear without using a bright background.
set('NeoTreeCursorLine', { fg = palette.fg, bg = '#302E3B', bold = true })
set('NeoTreeDirectoryName', { fg = palette.fg_soft })
set('NeoTreeRootName', { fg = palette.magenta, bold = true })
set('NeoTreeGitAdded', { fg = palette.green })
set('NeoTreeGitModified', { fg = palette.yellow })
set('NeoTreeGitDeleted', { fg = palette.red })
set('BlinkCmpMenu', { fg = palette.fg, bg = palette.panel_alt })
set('BlinkCmpMenuBorder', { fg = palette.line, bg = palette.panel_alt })
set('BlinkCmpMenuSelection', { fg = palette.fg, bg = palette.selection, bold = true })
set('BlinkCmpLabel', { fg = palette.fg })
set('BlinkCmpLabelMatch', { fg = palette.yellow, bold = true })
set('BlinkCmpKind', { fg = palette.cyan })
set('BlinkCmpDoc', { fg = palette.fg, bg = palette.panel_alt })
set('BlinkCmpDocBorder', { fg = palette.line, bg = palette.panel_alt })
set('BlinkCmpSignatureHelp', { fg = palette.fg, bg = palette.panel_alt })
set('BlinkCmpSignatureHelpBorder', { fg = palette.line, bg = palette.panel_alt })

-- mini.nvim, todo-comments, and LSP progress.
set('MiniStatuslineModeNormal', { fg = palette.ink, bg = palette.lavender, bold = true })
set('MiniStatuslineModeInsert', { fg = palette.ink, bg = palette.green_soft, bold = true })
set('MiniStatuslineModeVisual', { fg = palette.ink, bg = palette.cyan, bold = true })
set('MiniStatuslineModeReplace', { fg = palette.ink, bg = palette.red, bold = true })
set('MiniStatuslineModeCommand', { fg = palette.ink, bg = palette.yellow, bold = true })
set('MiniStatuslineModeOther', { fg = palette.ink, bg = palette.purple, bold = true })
set('MiniStatuslineDevinfo', { fg = palette.fg_soft, bg = palette.panel })
set('MiniStatuslineFilename', { fg = palette.fg, bg = palette.panel })
set('MiniStatuslineFileinfo', { fg = palette.muted, bg = palette.panel })
set('MiniStatuslineInactive', { fg = palette.muted, bg = palette.bg })
set('TodoFgTODO', { fg = palette.cyan, bold = true })
set('TodoBgTODO', { fg = palette.ink, bg = palette.cyan, bold = true })
set('TodoFgFIX', { fg = palette.red, bold = true })
set('TodoBgFIX', { fg = palette.ink, bg = palette.red, bold = true })
set('TodoFgFIXME', { fg = palette.red, bold = true })
set('TodoBgFIXME', { fg = palette.ink, bg = palette.red, bold = true })
set('TodoFgWARN', { fg = palette.yellow, bold = true })
set('TodoBgWARN', { fg = palette.ink, bg = palette.yellow, bold = true })
set('TodoFgHACK', { fg = palette.magenta, bold = true })
set('TodoBgHACK', { fg = palette.ink, bg = palette.magenta, bold = true })
set('TodoFgNOTE', { fg = palette.green, bold = true })
set('TodoBgNOTE', { fg = palette.ink, bg = palette.green, bold = true })
set('FidgetTask', { fg = palette.muted })
set('FidgetTitle', { fg = palette.cyan, bold = true })
set('FidgetGroup', { fg = palette.purple })

-- LSP semantic tokens. These groups cover servers that provide semantic data.
set('@lsp.type.comment', { link = 'Comment' })
set('@lsp.type.keyword', { link = '@keyword' })
set('@lsp.type.function', { link = '@function' })
set('@lsp.type.method', { link = '@function.method' })
set('@lsp.type.parameter', { link = '@parameter' })
set('@lsp.type.variable', { link = '@variable' })
set('@lsp.type.property', { link = '@property' })
set('@lsp.type.type', { link = '@type' })
set('@lsp.type.class', { link = '@type' })
set('@lsp.type.interface', { link = '@type' })
set('@lsp.type.enum', { link = '@type' })
set('@lsp.type.enumMember', { link = '@constant' })
set('@lsp.type.namespace', { link = '@module' })
set('@lsp.type.string', { link = '@string' })
set('@lsp.type.number', { link = '@number' })
set('@lsp.type.operator', { link = '@operator' })

-- Terminal ANSI colors. These also affect terminal buffers inside Neovim.
vim.g.terminal_color_0 = '#202227'
vim.g.terminal_color_1 = palette.red
vim.g.terminal_color_2 = palette.green
vim.g.terminal_color_3 = palette.yellow
vim.g.terminal_color_4 = palette.indigo
vim.g.terminal_color_5 = palette.magenta
vim.g.terminal_color_6 = palette.cyan
vim.g.terminal_color_7 = palette.fg_soft
vim.g.terminal_color_8 = palette.faint
vim.g.terminal_color_9 = '#FF8FA3'
vim.g.terminal_color_10 = '#86EFAC'
vim.g.terminal_color_11 = '#FDE68A'
vim.g.terminal_color_12 = '#A5B4FC'
vim.g.terminal_color_13 = '#F0ABFC'
vim.g.terminal_color_14 = '#A5F3FC'
vim.g.terminal_color_15 = palette.fg
