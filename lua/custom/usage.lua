local M = {}

local state_file = vim.fn.stdpath('state') .. '/nvim-usage.json'
local namespace = vim.api.nvim_create_namespace('nvim_usage')
local augroup = vim.api.nvim_create_augroup('NvimUsage', { clear = true })

local state = {
  version = 1,
  key_sequences = {},
  commands = {},
  modes = {},
}

-- The key sequence is written with spaces so that control keys are clear.
-- The displayed key string is shown in the report.
local known_sequences = {
  ['i'] = { name = 'insert_mode', keys = 'i' },
  ['a'] = { name = 'append_mode', keys = 'a' },
  ['v'] = { name = 'visual_mode', keys = 'v' },
  ['V'] = { name = 'visual_line_mode', keys = 'V' },
  ['G'] = { name = 'go_to_last_line', keys = 'G' },
  ['K'] = { name = 'show_documentation', keys = 'K' },
  ['Y'] = { name = 'neo_tree_copy_path', keys = 'Y' },
  ['A'] = { name = 'neo_tree_add_directory', keys = 'A' },
  ['\\'] = { name = 'open_neo_tree', keys = '\\' },
  ['y'] = { name = 'yank', keys = 'y' },
  ['p'] = { name = 'paste', keys = 'p' },
  ['P'] = { name = 'paste_before', keys = 'P' },
  ['<C-O>'] = { name = 'jump_back', keys = 'Ctrl-o' },
  -- Ctrl-i is sent as <Tab> by the terminal.
  ['<Tab>'] = { name = 'jump_forward', keys = 'Ctrl-i' },
  ['<C-I>'] = { name = 'jump_forward', keys = 'Ctrl-i' },
  ['<C-^>'] = { name = 'previous_buffer', keys = 'Ctrl-^' },

  ['g g'] = { name = 'go_to_first_line', keys = 'gg' },
  ['g d'] = { name = 'go_to_definition', keys = 'gd' },
  ['g D'] = { name = 'go_to_declaration', keys = 'gD' },
  ['g r r'] = { name = 'find_references', keys = 'grr' },
  ['g r i'] = { name = 'find_implementations', keys = 'gri' },
  ['g r d'] = { name = 'go_to_definition', keys = 'grd' },
  ['g r t'] = { name = 'go_to_type_definition', keys = 'grt' },

  ['<C-W> h'] = { name = 'move_to_left_split', keys = 'Ctrl-w h' },
  ['<C-W> j'] = { name = 'move_to_lower_split', keys = 'Ctrl-w j' },
  ['<C-W> k'] = { name = 'move_to_upper_split', keys = 'Ctrl-w k' },
  ['<C-W> l'] = { name = 'move_to_right_split', keys = 'Ctrl-w l' },
  ['<C-W> ='] = { name = 'equalize_splits', keys = 'Ctrl-w =' },
  ['<C-W> +'] = { name = 'increase_split_height', keys = 'Ctrl-w +' },
  ['<C-W> -'] = { name = 'decrease_split_height', keys = 'Ctrl-w -' },
  ['<C-W> >'] = { name = 'increase_split_width', keys = 'Ctrl-w >' },
  ['<C-W> <'] = { name = 'decrease_split_width', keys = 'Ctrl-w <' },
}

local pending = {}
local pending_timer = vim.uv.new_timer()
local save_pending = false

local function load()
  if vim.fn.filereadable(state_file) == 0 then return end

  local ok, data = pcall(function()
    local content = table.concat(vim.fn.readfile(state_file), '\n')
    return vim.json.decode(content)
  end)

  if ok and type(data) == 'table' then
    state = vim.tbl_deep_extend('force', state, data)
  end
end

local function save()
  vim.fn.mkdir(vim.fn.fnamemodify(state_file, ':h'), 'p')

  local temporary_file = state_file .. '.tmp'
  vim.fn.writefile({ vim.json.encode(state) }, temporary_file)
  vim.fn.rename(temporary_file, state_file)
end

local function schedule_save()
  if save_pending then return end

  save_pending = true
  vim.defer_fn(function()
    save_pending = false
    save()
  end, 1000)
end

local function record(bucket, name)
  if not name or name == '' then return end

  state[bucket][name] = (state[bucket][name] or 0) + 1
  schedule_save()
end

local function record_key_sequence(sequence)
  local command = known_sequences[sequence]
  if not command then return end

  local entry = state.key_sequences[command.name] or {
    keys = command.keys,
    count = 0,
  }

  entry.count = entry.count + 1
  state.key_sequences[command.name] = entry
  schedule_save()
end

local function is_prefix(sequence)
  for candidate in pairs(known_sequences) do
    if candidate:sub(1, #sequence) == sequence then return true end
  end

  return false
end

local function clear_pending()
  pending = {}
end

local function start_pending_timer()
  pending_timer:stop()
  pending_timer:start(500, 0, vim.schedule_wrap(clear_pending))
end

local function process_key(key)
  local token = vim.fn.keytrans(key)
  table.insert(pending, token)

  local sequence = table.concat(pending, ' ')

  if known_sequences[sequence] then
    record_key_sequence(sequence)
    clear_pending()
    return
  end

  if is_prefix(sequence) then
    start_pending_timer()
    return
  end

  local last_token = token
  clear_pending()

  if is_prefix(last_token) then
    table.insert(pending, last_token)
    start_pending_timer()
  end
end

local function record_command_line()
  local command_type = vim.fn.getcmdtype()
  local command_line = vim.fn.getcmdline()

  if command_type == '/' or command_type == '?' then
    record('commands', 'search')
    return
  end

  if command_type ~= ':' then return end

  -- Keep arguments out of the usage file. This also hides shell arguments.
  if command_line:match('^%s*!') then
    record('commands', 'shell')
    return
  end

  local command_name = command_line:match('^%s*([^%s|]+)')
  if command_name then record('commands', command_name) end
end

local function sorted_entries(bucket)
  local entries = {}

  for name, value in pairs(bucket) do
    local count = type(value) == 'table' and value.count or value
    table.insert(entries, { name = name, value = value, count = count })
  end

  table.sort(entries, function(left, right) return left.count > right.count end)
  return entries
end

local function report()
  local lines = { 'Neovim usage report', '' }

  local function add_section(title, bucket, formatter)
    table.insert(lines, title)
    table.insert(lines, string.rep('-', #title))

    local entries = sorted_entries(state[bucket])
    local maximum = entries[1] and entries[1].count or 1

    for _, entry in ipairs(entries) do
      local width = math.floor((entry.count / maximum) * 30)
      local bar = string.rep('█', math.max(width, 1))
      table.insert(lines, formatter(entry, bar))
    end

    table.insert(lines, '')
  end

  add_section('Key sequences', 'key_sequences', function(entry, bar)
    return string.format('%-28s %-12s %5d %s', entry.name, '(' .. entry.value.keys .. ')', entry.count, bar)
  end)

  add_section('Colon commands', 'commands', function(entry, bar)
    return string.format('%-28s %5d %s', ':' .. entry.name, entry.count, bar)
  end)

  add_section('Modes', 'modes', function(entry, bar)
    return string.format('%-28s %5d %s', entry.name, entry.count, bar)
  end)

  vim.notify(table.concat(lines, '\n'))
end

function M.reset()
  state = {
    version = 1,
    key_sequences = {},
    commands = {},
    modes = {},
  }
  save()
end

function M.setup()
  if vim.g.nvim_usage_started then return end
  vim.g.nvim_usage_started = true

  load()
  record('modes', vim.fn.mode())

  vim.on_key(function(key)
    local mode = vim.fn.mode():sub(1, 1)
    if mode ~= 'i' and mode ~= 'c' then process_key(key) end
  end, namespace)

  vim.api.nvim_create_autocmd('CmdlineLeave', {
    group = augroup,
    callback = record_command_line,
  })

  vim.api.nvim_create_autocmd('ModeChanged', {
    group = augroup,
    callback = function() record('modes', vim.fn.mode()) end,
  })

  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = augroup,
    callback = function()
      pending_timer:stop()
      pending_timer:close()
    end,
  })

  vim.api.nvim_create_user_command('UsageReport', report, {})
  vim.api.nvim_create_user_command('UsageReset', M.reset, {})
end

return M
