local tbl = { }
local U = string.char(27)
local ESC = U .. '['
local isTerminalApp = (os.getenv('TERM_PROGRAM') == 'Apple_Terminal')
tbl.cursorTo = function(x, y)
  if type(x) ~= 'number' then
    error('`x` must be a number')
  end
  if type(y) ~= 'number' then
    return ESC .. (x + 1) .. 'G'
  end
  return ESC .. (y + 1) .. ';' .. (x + 1) .. 'H'
end
tbl.cursorMove = function(x, y)
  if type(x) ~= 'number' then
    error('`x` must be a number')
  end
  local ret = ''
  if x < 0 then
    ret = ret .. (ESC .. (-x) .. 'D')
  elseif x > 0 then
    ret = ret .. (ESC .. x .. 'C')
  end
  if y < 0 then
    ret = ret .. (ESC .. (-y) .. 'A')
  elseif y > 0 then
    ret = ret .. (ESC .. y .. 'B')
  end
  return ret
end
tbl.cursorUp = function(count)
  if type(count) == 'number' then
    return ESC .. count .. 'A'
  else
    return ESC .. 1 .. 'A'
  end
end
tbl.cursorDown = function(count)
  if type(count) == 'number' then
    return ESC .. count .. 'B'
  else
    return ESC .. 1 .. 'B'
  end
end
tbl.cursorForward = function(count)
  if type(count) == 'number' then
    return ESC .. count .. 'C'
  else
    return ESC .. 1 .. 'C'
  end
end
tbl.cursorBackward = function(count)
  if type(count) == 'number' then
    return ESC .. count .. 'D'
  else
    return ESC .. 1 .. 'D'
  end
end
tbl.cursorLeft = ESC .. 'G'
if isTerminalApp then
  tbl.cursorSavePosition = ESC .. '7'
  tbl.cursorRestorePosition = ESC .. '8'
else
  tbl.cursorSavePosition = ESC .. 's'
  tbl.cursorRestorePosition = ESC .. 'u'
end
tbl.cursorGetPosition = ESC .. '6n'
tbl.cursorNextLine = ESC .. 'E'
tbl.cursorPrevLine = ESC .. 'F'
tbl.cursorHide = ESC .. '?25l'
tbl.cursorShow = ESC .. '?25h'
tbl.clearScreen = U .. 'c'
tbl.beep = string.char(7)
tbl.eraseEndLine = ESC .. 'K'
tbl.eraseStartLine = ESC .. '1K'
tbl.eraseLine = ESC .. '2K'
tbl.eraseDown = ESC .. 'J'
tbl.eraseUp = ESC .. '1J'
tbl.eraseScreen = ESC .. '2J'
tbl.scrollUp = ESC .. 'S'
tbl.scrollDown = ESC .. 'T'
tbl.eraseLines = function(count)
  local clear = ''
  local i = 0
  while i < count do
    local s = ''
    if i < (count - 1) then
      s = tbl.cursorUp()
    end
    clear = clear .. (tbl.eraseLine .. s)
    i = i + 1
  end
  if count then
    clear = clear .. tbl.cursorLeft
  end
  return clear
end
return tbl
