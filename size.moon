-------------
-- HELPERS --
-------------

getOS = ->
	if love and love.system and love.system.getOS
		switch love.system.getOS!
			when 'Linux', 'Android'
				return 'linux'
			when 'OS X', 'iOS'
				return 'darwin'
			when 'Windows'
				return 'windows'
				
	elseif jit and jit.os
		r = jit.os\lower!
		if (r\match 'windows') or (r\match '^mingw') or (r\match '^cygwin')
			return 'windows'
		elseif (r\match 'linux') or (r\match 'bsd$')
			return 'linux'
		elseif (r\match 'mac') or (r\match 'darwin')
			return 'darwin'

	else
		if package.cpath\match '%.so'
			return 'linux'
		elseif package.cpath\match '%.dylib'
			return 'darwin'
		elseif package.cpath\match '%.dll'
			return 'windows'

OS = getOS!

exec = (command) ->
	file = io.popen command
	return file\read '*all'

-- because perfomance
series = (a, b, c, d) ->
	err, obj = pcall a
	if obj and (obj[1] ~= nil) and (obj[1] ~= nil)
		return obj[1], obj[2]

	else
		err, obj = pcall b
		if obj and (obj[1] ~= nil) and (obj[1] ~= nil)
			return obj[1], obj[2]

		else
			err, obj = pcall c
			if obj and (obj[1] ~= nil) and (obj[1] ~= nil)
				return obj[1], obj[2]

			else
				err, obj = pcall d
				if obj and (obj[1] ~= nil) and (obj[1] ~= nil)
					return obj[1], obj[2]

	return nil, nil

getPath = () ->
	str = debug.getinfo(2, "S").source\sub(2)
	return (str\match("(.*/)")) or './'

-------------
-- GETTERS --
-------------

linux = ->
	return series(
		->
			w, h = os.getenv('COLUMNS'), os.getenv('LINES')
			return {w, h}

		->
			res1 = exec 'echo $COLUMNS $LINES'
			res2 = res1\gmatch '%d+'
			w, h = res2!, res2!
			return {w, h}

		->
			res1 = exec 'tput cols && tput lines'
			res2 = res1\gmatch '%d+'
			w, h = res2!, res2!
			return {w, h}

		->
			res1 = exec 'resize -u'
			res2 = res1\gmatch '%d+'
			w, h = res2!, res2!
			return {w, h}
	)

darwin = ->
	return series(
		->
			res1 = exec getPath! .. '/term-size'
			res2 = res1\gmatch '%d+'
			w, h = res2!, res2!
			return {w, h}
	)

windows = ->
	return series(
		->
			res1 = exec getPath! .. '/term-size.exe'
			res2 = res1\gmatch '%d+'
			w, h = res2!, res2!
			return {w, h}
	)

----------
-- MAIN --
----------

getSize = ->
	switch OS
		when 'linux'
			return linux!
		when 'darwin'
			return darwin!
		when 'windows'
			return windows!

return getSize
