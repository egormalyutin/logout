------------------
-- CURSOR TOOLS --
------------------

ESC = string.char(27) .. "["
HIDE_CURSOR = ESC .. '?25l'
SHOW_CURSOR = ESC .. '?25h'

showed = false

tbl = {}

tbl.hide = ->
	io.write HIDE_CURSOR
	showed = false

tbl.show = ->
	io.write SHOW_CURSOR
	showed = true

tbl.toggle = ->
	if showed
		tbl.hide!
	else
		tbl.show!

--------------------
-- RESTORE CURSOR --
--------------------

restorer = onexit: -> tbl.show! 
if _VERSION >= "Lua 5.2"
  setmetatable restorer, __gc: restorer.onexit
else
  restorer.sentinel = newproxy true
  getmetatable(restorer.sentinel).__gc = restorer.onexit

------------------

return tbl

