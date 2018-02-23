tbl = {}
U = string.char 27
ESC = U .. '['

isTerminalApp = (os.getenv('TERM_PROGRAM') == 'Apple_Terminal')

------------------
-- CURSOR MOVES --
------------------

tbl.cursorTo = (x, y) ->
	if type(x) ~= 'number'
		error '`x` must be a number'

	if type(y) ~= 'number'
		return ESC .. (x + 1) .. 'G'

	return ESC .. (y + 1) .. ';' .. (x + 1) .. 'H'

tbl.cursorMove = (x, y) ->
	if type(x) ~= 'number'
		error '`x` must be a number'

	ret = ''

	if x < 0
		ret ..= ESC .. (-x) .. 'D'
	elseif x > 0
		ret ..= ESC .. x .. 'C'

	if y < 0
		ret ..= ESC .. (-y) .. 'A'
	elseif y > 0
		ret ..= ESC .. y .. 'B'

	return ret

-----------------------
-- CURSOR DIRECTIONS --
-----------------------

tbl.cursorUp = (count) ->
	if type(count) == 'number'
		return ESC .. count .. 'A'
	else
		return ESC .. 1 .. 'A'

tbl.cursorDown = (count) ->
	if type(count) == 'number'
		return ESC .. count .. 'B'
	else
		return ESC .. 1 .. 'B'

tbl.cursorForward = (count) ->
	if type(count) == 'number'
		return ESC .. count .. 'C'
	else
		return ESC .. 1 .. 'C'

tbl.cursorBackward = (count) ->
	if type(count) == 'number'
		return ESC .. count .. 'D'
	else
		return ESC .. 1 .. 'D'

-----------------
-- OTHER CODES --
-----------------

tbl.cursorLeft = ESC .. 'G'

if isTerminalApp
	tbl.cursorSavePosition = ESC .. '7'
	tbl.cursorRestorePosition = ESC .. '8'
else
	tbl.cursorSavePosition = ESC .. 's'
	tbl.cursorRestorePosition = ESC .. 'u'

tbl.cursorGetPosition = ESC .. '6n'

tbl.cursorNextLine    = ESC .. 'E'
tbl.cursorPrevLine    = ESC .. 'F'

tbl.cursorHide = ESC .. '?25l'
tbl.cursorShow = ESC .. '?25h'

tbl.clearScreen = U .. 'c'
tbl.beep = string.char 7

-----------
-- LINES --
-----------

tbl.eraseEndLine   = ESC .. 'K'
tbl.eraseStartLine = ESC .. '1K'
tbl.eraseLine      = ESC .. '2K'
tbl.eraseDown      = ESC .. 'J'
tbl.eraseUp        = ESC .. '1J'
tbl.eraseScreen    = ESC .. '2J'
tbl.scrollUp       = ESC .. 'S'
tbl.scrollDown     = ESC .. 'T'

tbl.eraseLines = (count) ->
	clear = ''

	i = 0
	while i < count
		s = ''
		if i < (count - 1)
			s = tbl.cursorUp!

		clear ..= tbl.eraseLine .. s

		i += 1

	if count
		clear ..= tbl.cursorLeft

	return clear

-----------------------

return tbl
