local ESC = string.char(27) .. "["
local HIDE_CURSOR = ESC .. '?25l'
local SHOW_CURSOR = ESC .. '?25h'
local showed = false
local tbl = { }
tbl.hide = function()
  io.write(HIDE_CURSOR)
  showed = false
end
tbl.show = function()
  io.write(SHOW_CURSOR)
  showed = true
end
tbl.toggle = function()
  if showed then
    return tbl.hide()
  else
    return tbl.show()
  end
end
local restorer = {
  onexit = function()
    return tbl.show()
  end
}
if _VERSION >= "Lua 5.2" then
  setmetatable(restorer, {
    __gc = restorer.onexit
  })
else
  restorer.sentinel = newproxy(true)
  getmetatable(restorer.sentinel).__gc = restorer.onexit
end
return tbl
