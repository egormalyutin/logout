cssKeywords = require 'colors.names'
inspector = require 'inspect'
inspect = (...) -> print inspector ...

isIn = (obj, value) ->
	for key, value2 in ipairs obj
		return true if value == value2
	return false

round = (num, numDecimalPlaces) ->
	mult = 10 ^ (numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult

boolToNum = (a) ->
	if a
		return 1
	else
		return 0

reverseKeywords = {}

for key, value in pairs cssKeywords
	reverseKeywords[value] = key

convert = {
	rgb: {},
	hsl: {},
	hsv: {},
	hwb: {},
	cmyk: {},
	xyz: {},
	lab: {},
	lch: {},
	hex: {},
	keyword: {},
	ansi16: {},
	ansi256: {},
	hcg: {},
	apple: {},
	gray: {}
}

convert.rgb.rgb         = (...) -> return ...
convert.hsl.hsl         = (...) -> return ...
convert.hsv.hsv         = (...) -> return ...
convert.hwb.hwb         = (...) -> return ...
convert.cmyk.cmyk       = (...) -> return ...
convert.xyz.xyz         = (...) -> return ...
convert.lab.lab         = (...) -> return ...
convert.lch.lch         = (...) -> return ...
convert.hex.hex         = (...) -> return ...
convert.keyword.keyword = (...) -> return ...
convert.ansi16.ansi16   = (...) -> return ...
convert.ansi256.ansi256 = (...) -> return ...
convert.hcg.hcg         = (...) -> return ...
convert.apple.apple     = (...) -> return ...
convert.gray.gray       = (...) -> return ...

convert.rgb.hsl = (rgb) ->
	r = rgb[1] / 255
	g = rgb[2] / 255
	b = rgb[3] / 255
	min = math.min r, g, b
	max = math.max r, g, b
	delta = max - min
	local h, s, l

	if max == min
		h = 0
	elseif r == max
		h = (g - b) / delta
	elseif g == max
		h = 2 + (b - r) / delta
	elseif b == max
		h = 4 + (r - g) / delta

	h = math.min h * 60, 360

	if h < 0
		h += 360

	l = (min + max) / 2

	if max == min
		s = 0
	elseif l <= 0.5
		s = delta / (max + min)
	else
		s = delta / (2 - max - min)

	return {h, s * 100, l * 100}

convert.rgb.hsv = (rgb) ->
	r = rgb[1]
	g = rgb[2]
	b = rgb[3]
	min = math.min r, g, b
	max = math.max r, g, b
	delta = max - min
	local h, s, v

	if max == 0
		s = 0
	else 
		s = (delta / max * 1000) / 10
	

	if max == min
		h = 0
	elseif r == max
		h = (g - b) / delta
	elseif g == max 
		h = 2 + (b - r) / delta
	elseif b == max 
		h = 4 + (r - g) / delta

	h = math.min h * 60, 360

	if (h < 0) 
		h += 360
	
	v = ((max / 255) * 1000) / 10

	return {h, s, v}

convert.rgb.hwb = (rgb) ->
	r = rgb[1]
	g = rgb[2]
	b = rgb[3]
	h = convert.rgb.hsl(rgb)[1]
	w = 1 / 255 * math.min(r, math.min(g, b))

	b = 1 - 1 / 255 * math.max(r, math.max(g, b))

	return {h, w * 100, b * 100}

convert.rgb.cmyk = (rgb) ->
	r = rgb[1] / 255
	g = rgb[2] / 255
	b = rgb[3] / 255
	local c, m, y, k

	k = math.min(1 - r, 1 - g, 1 - b)
	c = ((1 - r - k) / (1 - k)) or 0
	m = ((1 - g - k) / (1 - k)) or 0
	y = ((1 - b - k) / (1 - k)) or 0

	return {c * 100, m * 100, y * 100, k * 100}

comparativeDistance = (x, y) ->
	return (
		(math.pow (x[1] - y[1]), 2) +
		(math.pow (x[2] - y[2]), 2) +
		(math.pow (x[3] - y[3]), 2)
	)

convert.rgb.keyword = (rgb) ->
	reversed = reverseKeywords[rgb]
	if reversed
		return reversed

	ccd = math.huge
	local cck

	for key, value in pairs cssKeywords
		distance = comparativeDistance rgb, value

		if distance < ccd
			ccd = distance
			cck = key

	return cck

convert.keyword.rgb = (keyword) ->
	unless cssKeywords[keyword]
		error 'Not found keyword ' .. keyword .. '!'
	return cssKeywords[keyword]

convert.rgb.xyz = (rgb) ->
	r = rgb[1] / 255
	g = rgb[2] / 255
	b = rgb[3] / 255

	-- assume sRGB
	r = if r > 0.04045 then math.pow(((r + 0.055) / 1.055), 2.4) else (r / 12.92)
	g = if g > 0.04045 then math.pow(((g + 0.055) / 1.055), 2.4) else (g / 12.92)
	b = if b > 0.04045 then math.pow(((b + 0.055) / 1.055), 2.4) else (b / 12.92)

	x = (r * 0.4124) + (g * 0.3576) + (b * 0.1805)
	y = (r * 0.2126) + (g * 0.7152) + (b * 0.0722)
	z = (r * 0.0193) + (g * 0.1192) + (b * 0.9505)

	return {x * 100, y * 100, z * 100}

convert.rgb.lab = (rgb) ->
	xyz = convert.rgb.xyz rgb
	x = xyz[1]
	y = xyz[2]
	z = xyz[3]
	local l, a, b

	x /= 95.047
	y /= 100
	z /= 108.883

	x = if x > 0.008856 then math.pow(x, 1 / 3) else (7.787 * x) + (16 / 116)
	y = if y > 0.008856 then math.pow(y, 1 / 3) else (7.787 * y) + (16 / 116)
	z = if z > 0.008856 then math.pow(z, 1 / 3) else (7.787 * z) + (16 / 116)

	l = (116 * y) - 16
	a = 500 * (x - y)
	b = 200 * (y - z)

	return {l, a, b}

convert.hsl.rgb = (hsl) ->
	h = hsl[1] / 360
	s = hsl[2] / 100
	l = hsl[3] / 100
	local t1, t2, t3, rgb, val

	if s == 0
		val = l * 255
		return {val, val, val}

	if l < 0.5 
		t2 = l * (1 + s)
	else
		t2 = l + s - l * s

	t1 = 2 * l - t2

	rgb = {0, 0, 0}
	i = 1
	while i <= 3
		t3 = h + (1 / 3) * (-(i - 1))
		if t3 < 0
			t3 += 1
		
		if t3 > 1
			t3 -= 1

		if (6 * t3) < 1
			val = t1 + ((t2 - t1) * 6 * t3)
		elseif 2 * t3 < 1
			val = t2
		elseif 3 * t3 < 2
			val = t1 + ((t2 - t1) * (2 / 3 - t3) * 6)
		else
			val = t1

		rgb[i] = val * 255
		i += 1

	return {rgb[3], rgb[1], rgb[2]}

convert.hsl.hsv = (hsl) ->
	h = hsl[1]
	s = hsl[2] / 100
	l = hsl[3] / 100
	smin = s
	lmin = math.max l, 0.01
	local sv, v

	l *= 2
	s *= if (l <= 1) then l else 2 - l
	smin *= if lmin <= 1 then lmin else 2 - lmin
	v = (l + s) / 2
	sv = if l == 0 then (2 * smin) / (lmin + smin) else (2 * s) / (l + s)

	return {h, sv * 100, v * 100}

convert.hsv.rgb = (hsv) ->
	h = hsv[1] / 60
	s = hsv[2] / 100
	v = hsv[3] / 100
	hi = math.fmod math.floor(h), 6

	f = h - math.floor(h)
	p = 255 * v * (1 - s)
	q = 255 * v * (1 - (s * f))
	t = 255 * v * (1 - (s * (1 - f)))
	v *= 255

	switch (hi)
		when 0
			return {v, t, p}
		when 1
			return {q, v, p}
		when 2
			return {p, v, t}
		when 3
			return {p, q, v}
		when 4
			return {t, p, v}
		when 5
			return {v, p, q}

convert.hsv.hsl = (hsv) ->
	h = hsv[1]
	s = hsv[2] / 100
	v = hsv[3] / 100
	vmin = math.max v, 0.01
	local lmin, sl, l

	l = (2 - s) * v
	lmin = (2 - s) * vmin
	sl = s * vmin
	sl /= if (lmin <= 1) then lmin else 2 - lmin
	sl = sl or 0
	l /= 2

	return {h, sl * 100, l * 100}

convert.hwb.rgb = (hwb) ->
	h = hwb[1] / 360
	wh = hwb[2] / 100
	bl = hwb[3] / 100
	ratio = wh + bl
	local i, v, f, n

	-- wh + bl cant be > 1
	if ratio > 1
		wh /= ratio
		bl /= ratio

	i = math.floor 6 * h
	v = 1 - bl
	f = 6 * h - i

	if ((i & 0x01) ~= 0)
		f = 1 - f

	n = wh + f * (v - wh) -- linear interpolation

	local r, g, b

	switch i
		when 0, 6
			r = v
			g = n
			b = wh
		when 1
			r = n
			g = v
			b = wh
		when 2
			r = wh
			g = v
			b = n
		when 3 
			r = wh
			g = n
			b = v
		when 4 
			r = n
			g = wh
			b = v
		when 5
			r = v
			g = wh
			b = n
		else
			r = v
			g = n
			b = wh

	return {r * 255, g * 255, b * 255}

convert.cmyk.rgb = (cmyk) ->
	c = cmyk[1] / 100
	m = cmyk[2] / 100
	y = cmyk[3] / 100
	k = cmyk[4] / 100
	local r, g, b

	r = 1 - math.min(1, c * (1 - k) + k)
	g = 1 - math.min(1, m * (1 - k) + k)
	b = 1 - math.min(1, y * (1 - k) + k)

	return {r * 255, g * 255, b * 255}

convert.xyz.rgb = (xyz) ->
	x = xyz[1] / 100
	y = xyz[2] / 100
	z = xyz[3] / 100
	local r, g, b

	r = (x * 3.2406) + (y * -1.5372) + (z * -0.4986)
	g = (x * -0.9689) + (y * 1.8758) + (z * 0.0415)
	b = (x * 0.0557) + (y * -0.2040) + (z * 1.0570)

	-- assume sRGB
	r = if r > 0.0031308
		((1.055 * math.pow(r, 1.0 / 2.4)) - 0.055)
	else
		r * 12.92

	g = if g > 0.0031308
		((1.055 * math.pow(g, 1.0 / 2.4)) - 0.055)
	else
		g * 12.92

	b = if b > 0.0031308
		((1.055 * math.pow(b, 1.0 / 2.4)) - 0.055)
	else
		b * 12.92

	r = math.min(math.max(0, r), 1)
	g = math.min(math.max(0, g), 1)
	b = math.min(math.max(0, b), 1)

	return {r * 255, g * 255, b * 255}

convert.xyz.lab = (xyz) ->
	x = xyz[1]
	y = xyz[2]
	z = xyz[3]
	local l, a, b

	x /= 95.047
	y /= 100
	z /= 108.883

	x = if x > 0.008856
		math.pow(x, 1 / 3)
	else 
		(7.787 * x) + (16 / 116)

	y = if y > 0.008856 
		math.pow(y, 1 / 3)
	else 
		(7.787 * y) + (16 / 116)

	z = if z > 0.008856 
		math.pow(z, 1 / 3)
	else
		(7.787 * z) + (16 / 116)

	l = (116 * y) - 16
	a = 500 * (x - y)
	b = 200 * (y - z)

	return {l, a, b}

convert.lab.xyz = (lab) ->
	l = lab[1]
	a = lab[2]
	b = lab[3]
	local x, y, z

	y = (l + 16) / 116
	x = a / 500 + y
	z = y - b / 200

	y2 = math.pow(y, 3)
	x2 = math.pow(x, 3)
	z2 = math.pow(z, 3)

	y = if y2 > 0.008856
		y2
	else
		(y - 16 / 116) / 7.787

	x = if x2 > 0.008856
		x2
	else
		(x - 16 / 116) / 7.787

	z = if z2 > 0.008856
		z2
	else
		(z - 16 / 116) / 7.787

	x *= 95.047
	y *= 100
	z *= 108.883

	return {x, y, z}

convert.lab.rgb = (lab) ->
	return convert.xyz.rgb(convert.lab.xyz(lab))

convert.lab.lch = (lab) ->
	l = lab[1]
	a = lab[2]
	b = lab[3]
	local hr, h, c

	hr = math.atan2(b, a)
	h = hr * 360 / 2 / math.pi

	if h < 0
		h += 360

	c = math.sqrt(a * a + b * b)

	return {l, c, h}

convert.lch.lab = (lch) ->
	l = lch[1]
	c = lch[2]
	h = lch[3]
	local a, b, hr

	hr = h / 360 * 2 * math.pi
	a = c * math.cos(hr)
	b = c * math.sin(hr)

	return {l, a, b}

convert.lch.rgb = (lch) ->
	return convert.lab.rgb(convert.lch.lab(lch))

convert.rgb.ansi16 = (...) ->
	arguments = {...}
	args = arguments[1]
	r = args[1]
	g = args[2]
	b = args[3]
	value = if isIn arguments, 1
		arguments[1] 
	else
		convert.rgb.hsv(args)[3] -- hsv -> ansi16 optimization

	value = round(value / 50)

	if value == 0
		return 30

	ansi = (30 + ((round(b / 255) << 2) | (round(g / 255) << 1) | round(r / 255)))

	if value == 2
		ansi += 60

	return ansi

convert.hsv.ansi16 = (args) ->
	-- optimization here; we already know the value and don't need to get it converted for us.
	return convert.rgb.ansi16(convert.hsv.rgb(args), args[3])

convert.rgb.ansi256 = (args) ->
	r = args[1]
	g = args[2]
	b = args[3]

	-- we use the extended greyscale palette here, with the exception of
	-- black and white. normal palette only has 4 greyscale shades.
	if (r == g) and (g == b) 
		if r < 8
			return 16

		if r > 248
			return 231

		return round(((r - 8) / 247) * 24) + 232

	ansi = (16 + (36 * round(r / 255 * 5)) + (6 * round(g / 255 * 5)) + round(b / 255 * 5))

	return ansi

convert.ansi16.rgb = (args) ->
	color = math.fmod args, 10 

	-- handle greyscale
	if (color == 0) or (color == 7)
		if args > 50
			color += 3.5

		color = color / 10.5 * 255

		return {color, color, color}

	mult = (boolToNum(args > 50) + 1) * 0.5
	r = ((color & 1) * mult) * 255
	g = (((color >> 1) & 1) * mult) * 255
	b = (((color >> 2) & 1) * mult) * 255

	return {r, g, b}

convert.ansi256.rgb = (args) ->
	-- handle greyscale
	if args >= 232
		c = (args - 232) * 10 + 8
		return {c, c, c}

	args -= 16

	local rem
	r = math.floor(args / 36) / 5 * 255
	rem = math.fmod(args, 36)
	g = math.floor(rem / 6) / 5 * 255
	b = math.fmod(rem, 6) / 5 * 255

	return {r, g, b}

convert.rgb.hex = (args) ->
	integer = (((round(args[1]) & 0xFF) << 16) + ((round(args[2]) & 0xFF) << 8) + (round(args[3]) & 0xFF))

	str = string.format('%x', integer)\upper!
	return string.sub('000000', 0, 6 - #str) .. str

convert.hex.rgb = (args) ->
	local formatted
	if type(args) ~= 'string'
		formatted = string.format('%x', args)
	else
		formatted = args\gsub '^0x', ''
		formatted = formatted\gsub '%#', ''

	formatted = formatted\lower!

	match = formatted\match('[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]')

	if not match
		match = formatted\match('[a-f0-9][a-f0-9][a-f0-9]')

	if not match
		return {0, 0, 0}

	colorString = match

	if #match == 3
		-- colorString = colorString.split('').map(function (char) {
		-- return char .. char
		-- }).join('');
		A1 = string.sub match, 1, 1
		B1 = string.sub match, 2, 2
		C1 = string.sub match, 3, 3
		colorString = A1 .. A1 .. B1 .. B1 .. C1 .. C1

	integer = tonumber colorString, 16
	r = (integer >> 16) & 0xFF
	g = (integer >> 8) & 0xFF
	b = integer & 0xFF


	return {r, g, b}

convert.rgb.hcg = (rgb) ->
	r = rgb[1] / 255
	g = rgb[2] / 255
	b = rgb[3] / 255
	max = math.max(math.max(r, g), b)
	min = math.min(math.min(r, g), b)
	chroma = (max - min)
	local grayscale, hue

	if chroma < 1
		grayscale = min / (1 - chroma)
	else
		grayscale = 0

	if chroma <= 0
		hue = 0
	elseif max == r
		hue = math.fmod ((g - b) / chroma), 6
	elseif max == g
		hue = 2 + (b - r) / chroma
	else
		hue = 4 + (r - g) / chroma + 4

	hue /= 6
	hue = math.fmod hue, 1

	return {hue * 360, chroma * 100, grayscale * 100}

convert.hsl.hcg = (hsl) ->
	s = hsl[2] / 100
	l = hsl[3] / 100
	c = 1
	f = 0

	if l < 0.5
		c = 2.0 * s * l
	else
		c = 2.0 * s * (1.0 - l)

	if c < 1.0
		f = (l - 0.5 * c) / (1.0 - c)

	return {hsl[1], c * 100, f * 100}

convert.hsv.hcg = (hsv) ->
	s = hsv[2] / 100
	v = hsv[3] / 100

	c = s * v
	f = 0

	if c < 1.0
		f = (v - c) / (1 - c)

	return {hsv[1], c * 100, f * 100}

convert.hcg.rgb = (hcg) ->
	h = hcg[1] / 360
	c = hcg[2] / 100
	g = hcg[3] / 100

	if c == 0.0
		return {g * 255, g * 255, g * 255}

	pure = {0, 0, 0}
	hi = math.fmod(h, 1) * 6
	v = math.fmod(hi, 1)
	w = 1 - v
	mg = 0

	switch math.floor(hi)
		when 0
			pure[1] = 1
			pure[2] = v
			pure[3] = 0
		when 1
			pure[1] = w
			pure[2] = 1
			pure[3] = 0
		when 2
			pure[1] = 0
			pure[2] = 1
			pure[3] = v
		when 3
			pure[1] = 0
			pure[2] = w
			pure[3] = 1
		when 4
			pure[1] = v
			pure[2] = 0
			pure[3] = 1
		else	
			pure[1] = 1
			pure[2] = 0
			pure[3] = w

	mg = (1.0 - c) * g

	return {
		(c * pure[1] + mg) * 255
		(c * pure[2] + mg) * 255
		(c * pure[3] + mg) * 255
	}

convert.hcg.hsv = (hcg) ->
	c = hcg[2] / 100
	g = hcg[3] / 100

	v = c + g * (1.0 - c)
	f = 0

	if v > 0.0
		f = c / v

	return {hcg[1], f * 100, v * 100}

convert.hcg.hsl = (hcg) ->
	c = hcg[2] / 100
	g = hcg[3] / 100

	l = g * (1.0 - c) + 0.5 * c
	s = 0

	if (l > 0.0) and (l < 0.5)
		s = c / (2 * l)
	elseif (l >= 0.5) and (l < 1.0)
		s = c / (2 * (1 - l))

	return {hcg[1], s * 100, l * 100}

convert.hcg.hwb = (hcg) ->
	c = hcg[2] / 100
	g = hcg[3] / 100
	v = c + g * (1.0 - c)
	return {hcg[1], (v - c) * 100, (1 - v) * 100}

convert.apple.rgb = (apple) ->
	return {(apple[1] / 65535) * 255, (apple[2] / 65535) * 255, (apple[3] / 65535) * 255}

convert.rgb.apple = (rgb) ->
	return {(rgb[1] / 255) * 65535, (rgb[2] / 255) * 65535, (rgb[3] / 255) * 65535}

convert.gray.rgb = (args) ->
	return {args[1] / 100 * 255, args[1] / 100 * 255, args[1] / 100 * 255}

convert.gray.hsv = (args) ->
	return {0, 0, args[1]}

convert.gray.hsl = convert.gray.hsv

convert.gray.hwb = (gray) ->
	return {0, 100, gray[1]}

convert.gray.cmyk = (gray) ->
	return {0, 0, 0, gray[1]}

convert.gray.lab = (gray) ->
	return {gray[1], 0, 0}

convert.gray.hex = (gray) ->
	val = round(gray[1] / 100 * 255) & 0xFF
	integer = (val << 16) + (val << 8) + val

	str = string.format('%x', integer)\upper!
	return string.sub('000000', 0, 6 - #str) .. str

convert.rgb.gray = (rgb) ->
	val = (rgb[1] + rgb[2] + rgb[3]) / 3
	return {val / 255 * 100}

return convert
