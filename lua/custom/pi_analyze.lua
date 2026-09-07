local M = {}

local defaults = {
  keymap = '<leader>pa',
  model = nil,
  actions = {
    explain = 'Explain the purpose and behavior of this code.',
    review = 'Find likely bugs and unclear behavior in this code.',
    simplify = 'Suggest a simpler form of this code without changing its behavior.',
  },
}

local config = vim.deepcopy(defaults)
local jobs = {}
local request_ids = {}
local result_windows = {}
local configured_keymap

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = 'Pi Analyze' })
end

local function close_result(buffer)
  local window = result_windows[buffer]
  if window and vim.api.nvim_win_is_valid(window) then vim.api.nvim_win_close(window, true) end
  result_windows[buffer] = nil
end

local function show_result(source_buffer, text, title)
  close_result(source_buffer)

  local lines = vim.split(vim.trim(text), '\n', { plain = true })
  if #lines == 0 then lines = { 'Pi returned no text.' } end

  local columns = vim.o.columns
  local available_lines = math.max(1, vim.o.lines - vim.o.cmdheight - 4)
  local width = math.min(100, math.max(20, math.floor(columns * 0.8)), math.max(1, columns - 4))
  local height = math.max(1, math.min(#lines, available_lines, math.floor(available_lines * 0.7)))
  local row = math.max(0, math.floor((available_lines - height) / 2))
  local col = math.max(0, math.floor((columns - width) / 2))

  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
  vim.bo[buffer].buftype = 'nofile'
  vim.bo[buffer].bufhidden = 'wipe'
  vim.bo[buffer].filetype = 'markdown'
  vim.bo[buffer].modifiable = false

  local window = vim.api.nvim_open_win(buffer, true, {
    relative = 'editor',
    style = 'minimal',
    border = 'rounded',
    title = ' ' .. title .. ' ',
    title_pos = 'center',
    width = width,
    height = height,
    row = row,
    col = col,
  })
  result_windows[source_buffer] = window
  vim.wo[window].wrap = true
  vim.wo[window].linebreak = true
  vim.wo[window].conceallevel = 0

  local function close()
    if vim.api.nvim_win_is_valid(window) then vim.api.nvim_win_close(window, true) end
    if result_windows[source_buffer] == window then result_windows[source_buffer] = nil end
  end

  vim.keymap.set('n', 'q', close, { buffer = buffer, silent = true, nowait = true })
  vim.keymap.set('n', '<Esc>', close, { buffer = buffer, silent = true, nowait = true })
end

local function buffer_metadata(buffer, first_line, last_line, text)
  local path = vim.api.nvim_buf_get_name(buffer)
  if path == '' then path = '[No Name]' end

  return vim.json.encode {
    file = path,
    filetype = vim.bo[buffer].filetype,
    lines = { first_line, last_line },
    code = text,
  }
end

local function stop_request(buffer)
  local job = jobs[buffer]
  if job then
    pcall(job.kill, job, 15)
    jobs[buffer] = nil
  end
end

local function run(action, buffer, first_line, last_line, text)
  local instruction = config.actions[action]
  if not instruction then
    notify(('Unknown action: %s'):format(action), vim.log.levels.ERROR)
    return
  end
  if text == '' then
    notify('The selection is empty.', vim.log.levels.WARN)
    return
  end
  if vim.fn.executable 'pi' ~= 1 then
    notify('The pi executable is not available.', vim.log.levels.ERROR)
    return
  end

  stop_request(buffer)
  request_ids[buffer] = (request_ids[buffer] or 0) + 1
  local request_id = request_ids[buffer]

  local command = {
    'pi',
    '-p',
    '--no-session',
    '--no-tools',
    '--no-extensions',
    '--no-skills',
    '--no-prompt-templates',
    '--no-context-files',
    '--system-prompt',
    'Analyze only the code supplied by the user. Be concise. Use at most five bullets. State when the supplied code does not provide enough context.',
  }
  if config.model and config.model ~= '' then
    vim.list_extend(command, { '--model', config.model })
  end
  vim.list_extend(command, {
    instruction .. ' The input is JSON with file, filetype, lines, and code fields.',
  })

  vim.api.nvim_echo({ { ('Pi is running %s…'):format(action), 'ModeMsg' } }, false, {})
  jobs[buffer] = vim.system(command, {
    text = true,
    stdin = buffer_metadata(buffer, first_line, last_line, text),
  }, function(result)
    vim.schedule(function()
      if request_ids[buffer] ~= request_id then return end
      jobs[buffer] = nil
      vim.api.nvim_echo({ { '' } }, false, {})

      local stdout = vim.trim(result.stdout or '')
      local stderr = vim.trim(result.stderr or '')
      if result.code == 0 and stdout ~= '' then
        show_result(buffer, stdout, ('Pi: %s'):format(action))
        return
      end

      local details = stderr ~= '' and stderr or stdout
      if details ~= '' then
        show_result(buffer, details, 'Pi: error')
      else
        notify(('Pi failed with exit code %d.'):format(result.code), vim.log.levels.ERROR)
      end
    end)
  end)
end

local function analyze_current_line(action)
  local buffer = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local text = vim.api.nvim_buf_get_lines(buffer, line - 1, line, false)[1] or ''
  run(action, buffer, line, line, text)
end

local function line_range(action, line1, line2)
  local buffer = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buffer, line1 - 1, line2, false)
  run(action, buffer, line1, line2, table.concat(lines, '\n'))
end

local function choose_action(callback)
  local actions = vim.tbl_keys(config.actions)
  table.sort(actions)
  vim.ui.select(actions, { prompt = 'Pi action:' }, function(action)
    if action then callback(action) end
  end)
end

local function command_action(opts)
  local execute = function(action)
    if opts.range > 0 then
      line_range(action, opts.line1, opts.line2)
    else
      analyze_current_line(action)
    end
  end

  local action = vim.trim(opts.args)
  if action == '' then
    choose_action(execute)
  else
    execute(action)
  end
end

function M.setup(options)
  config = vim.tbl_deep_extend('force', vim.deepcopy(defaults), options or {})

  vim.api.nvim_create_user_command('PiAnalyze', command_action, {
    nargs = '?',
    range = true,
    desc = 'Analyze selected code with Pi',
    complete = function(arg_lead)
      local actions = vim.tbl_keys(config.actions)
      table.sort(actions)
      return vim.tbl_filter(function(action) return vim.startswith(action, arg_lead) end, actions)
    end,
  })

  if configured_keymap then
    pcall(vim.keymap.del, 'n', configured_keymap)
    pcall(vim.keymap.del, 'x', configured_keymap)
  end
  configured_keymap = config.keymap

  if configured_keymap and configured_keymap ~= '' then
    vim.keymap.set('n', configured_keymap, function()
      choose_action(analyze_current_line)
    end, { desc = '[P]i [A]nalyze line' })

    vim.keymap.set('x', configured_keymap, function()
      local selection_type = vim.fn.mode()
      local start_pos = vim.fn.getpos 'v'
      local end_pos = vim.fn.getpos '.'
      local lines = vim.fn.getregion(start_pos, end_pos, { type = selection_type })
      local buffer = vim.api.nvim_get_current_buf()
      local first_line = math.min(start_pos[2], end_pos[2])
      local last_line = math.max(start_pos[2], end_pos[2])
      local text = table.concat(lines, '\n')
      choose_action(function(action) run(action, buffer, first_line, last_line, text) end)
    end, { desc = '[P]i [A]nalyze selection' })
  end
end

return M
