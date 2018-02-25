inspector = require 'inspect'
convert = require 'colors.convert'

-------------
-- HELPERS --
-------------

inspect = (...) -> print inspector ...

concat = (a, b) ->
	res = {}
	if type(a) ~= 'table'
		a = {a}
	if type(b) ~= 'table'
		b = {b}

	for v in *a
		table.insert res, v

	for v in *b
		table.insert res, v

	return res

------------
-- CONSTS --
------------

ESC         = string.char(27) .. '['
ESC_PATTERN = string.char(27) .. '%['

--------------
-- RAW CODES -
--------------

raw = 
	bold: {open: ESC .. 1 .. 'm', close: ESC .. 22 .. 'm', closePattern: ESC_PATTERN .. 22 .. 'm'},
	dim: {open: ESC .. 2 .. 'm', close: ESC .. 22 .. 'm', closePattern: ESC_PATTERN .. 22 .. 'm'},
	italic: {open: ESC .. 3 .. 'm', close: ESC .. 23 .. 'm', closePattern: ESC_PATTERN .. 23 .. 'm'},
	underline: {open: ESC .. 4 .. 'm', close: ESC .. 24 .. 'm', closePattern: ESC_PATTERN .. 24 .. 'm'},
	inverse: {open: ESC .. 7 .. 'm', close: ESC .. 27 .. 'm', closePattern: ESC_PATTERN .. 27 .. 'm'},
	hidden: {open: ESC .. 8 .. 'm', close: ESC .. 28 .. 'm', closePattern: ESC_PATTERN .. 28 .. 'm'},
	strikethrough: {open: ESC .. 9 .. 'm', close: ESC .. 29 .. 'm', closePattern: ESC_PATTERN .. 29 .. 'm'}

	black: {open: ESC .. 30 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},
	red: {open: ESC .. 31 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},
	green: {open: ESC .. 32 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},
	yellow: {open: ESC .. 33 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},
	blue: {open: ESC .. 34 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},
	magenta: {open: ESC .. 35 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},
	cyan: {open: ESC .. 36 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},
	white: {open: ESC .. 37 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},
	gray: {open: ESC .. 90 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},

	redBright: {open: ESC .. 91 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},
	greenBright: {open: ESC .. 92 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},
	yellowBright: {open: ESC .. 93 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},
	blueBright: {open: ESC .. 94 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},
	magentaBright: {open: ESC .. 95 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},
	cyanBright: {open: ESC .. 96 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'},
	whiteBright: {open: ESC .. 97 .. 'm', close: ESC .. 39 .. 'm', closePattern: ESC_PATTERN .. 39 .. 'm'}

	bgBlack: {open: ESC .. 40 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},
	bgRed: {open: ESC .. 41 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},
	bgGreen: {open: ESC .. 42 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},
	bgYellow: {open: ESC .. 43 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},
	bgBlue: {open: ESC .. 44 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},
	bgMagenta: {open: ESC .. 45 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},
	bgCyan: {open: ESC .. 46 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},
	bgWhite: {open: ESC .. 47 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},

	bgBlackBright: {open: ESC .. 100 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},
	bgRedBright: {open: ESC .. 101 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},
	bgGreenBright: {open: ESC .. 102 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},
	bgYellowBright: {open: ESC .. 103 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},
	bgBlueBright: {open: ESC .. 104 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},
	bgMagentaBright: {open: ESC .. 105 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},
	bgCyanBright: {open: ESC .. 106 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'},
	bgWhiteBright: {open: ESC .. 107 .. 'm', close: ESC .. 49 .. 'm', closePattern: ESC_PATTERN .. 49 .. 'm'}

raw.grey = raw.gray


---------------------
-- COLOR FUNCTIONS --
---------------------

wrapper = (func, bg = false) ->
	return (...)->
		color = {...}

		if type(color[1]) == 'table'
			color = color[1]

		code = math.floor convert.rgb.ansi256(convert[func].rgb color)

		tp    = if bg then '48;5;' else '38;5;'
		tpNum = if bg then 49 else 39

		return (text) ->
			open = ESC .. tp .. code .. 'm'
			close = ESC .. tpNum .. 'm'
			closePattern = ESC_PATTERN .. tpNum .. 'm'

			str = string.gsub text, closePattern, close .. open
			result = open .. str .. close
			return result




funcs =
	ansi: (code) ->
		code = math.floor code
		return (text) ->
			open = ESC .. code .. 'm'
			close = ESC .. 39 .. 'm'
			closePattern = ESC_PATTERN .. 39 .. 'm'

			str = string.gsub text, closePattern, close .. open
			result = open .. str .. close
			return result

	bgAnsi: (code) ->
		code = math.floor code
		return (text) ->
			open = ESC .. (10 + code) .. 'm'
			close = ESC .. 49 .. 'm'
			closePattern = ESC_PATTERN .. 49 .. 'm'

			str = string.gsub text, closePattern, close .. open
			result = open .. str .. close
			return result

	ansi256: (code) ->
		code = math.floor code
		return (text) ->
			open = ESC .. '38;5;' .. code .. 'm'
			close = ESC .. 39 .. 'm'
			closePattern = ESC_PATTERN .. 39 .. 'm'

			str = string.gsub text, closePattern, close .. open
			result = open .. str .. close
			return result

	bgAnsi256: (code) ->
		code = math.floor code
		return (text) ->
			open = ESC .. '48;5;' .. (10 + code) .. 'm'
			close = ESC .. 49 .. 'm'
			closePattern = ESC_PATTERN .. 49 .. 'm'

			str = string.gsub text, closePattern, close .. open
			result = open .. str .. close
			return result

	rgb: wrapper 'rgb'
	bgRgb: wrapper 'rgb', true

	hsl: wrapper 'hsl'
	bgHsl: wrapper 'hsl', true

	hsv: wrapper 'hsv'
	bgHsv: wrapper 'hsv', true

	hwb: wrapper 'hwb'
	bgHwb: wrapper 'hwb', true

	cmyk: wrapper 'cmyk'
	bgCmyk: wrapper 'cmyk', true

	xyz: wrapper 'xyz'
	bgXyz: wrapper 'xyz', true

	lab: wrapper 'lab'
	bgLab: wrapper 'lab', true

	lch: wrapper 'lch'
	bgLch: wrapper 'lch', true

	hex: wrapper 'hex'
	bgLch: wrapper 'hex', true

	keyword: wrapper 'keyword'
	bgKeyword: wrapper 'keyword', true

	hcg: wrapper 'hcg'
	bgHcg: wrapper 'hcg', true

	apple: wrapper 'apple'
	bgApple: wrapper 'apple', true

	gray: wrapper 'gray'
	bgGray: wrapper 'gray', true

funcs.bgRGB = funcs.bgRgb
funcs.bgHSL = funcs.bgHsl


funcs.ansi16   = funcs.ansi
funcs.bgAnsi16 = funcs.bgAnsi

-----------
-- CHAIN --
-----------

chain = () ->
	methods = {}
	for key, value in pairs raw
		-- transformers
		methods[key] = (text) ->
			-- replace resets to resets & opens
			str = string.gsub text, value.closePattern, value.close .. value.open
			result = value.open .. str .. value.close
			return result

	gen = (stack = {}) ->
		-- metatable
		mt = {}
		setmetatable mt, {
			__call: (text) =>
				-- if chain is finished, call stack of transformers

				-- call stack
				if stack
					for _, f in pairs stack
						text = f text

				return text

			__index: (key) =>
				-- add new transformer to stack

				if funcs[key]
					return (...) ->
						return gen concat(stack, funcs[key](...))

				elseif methods[key] 
					return gen concat(stack, methods[key])

				else
					error 'Style "' .. key .. '" wasn\'t found!'
		}


	res = gen!

	return res

chalk = chain!

-- print c.ansi256(100)('sj' .. c.red('sdsdsd') .. 'dsidjis')

message = chalk.blue
err = chalk.red.bold
name = 'Egor'

print message 'All is good...'

print string.format message('Your name is %s!'), name

print chalk.bgYellow.black(
	'I am a black line with yellow background ' ..
	chalk.white.bgRed.underline.bold('with white substring with red background') ..
	' that becomes black again!')

print chalk.red('Something is going ' .. chalk.bold('really') .. ' bad...')

print err 'SUPIR FATAL ERROR!1!!!!11one!one'

print chalk.gray(70).bold('Bold gray!')
