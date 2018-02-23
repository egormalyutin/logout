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

return getOS
