cssKeywords = require 'colors.names'
inspector = require 'inspect'
inspect = (...) -> print inspector ...

reverseKeywords = {}

for key, value in pairs cssKeywords
	reverseKeywords[value] = key

convert = {
	rgb: {channels: 3, labels: 'rgb'},
	hsl: {channels: 3, labels: 'hsl'},
	hsv: {channels: 3, labels: 'hsv'},
	hwb: {channels: 3, labels: 'hwb'},
	cmyk: {channels: 4, labels: 'cmyk'},
	xyz: {channels: 3, labels: 'xyz'},
	lab: {channels: 3, labels: 'lab'},
	lch: {channels: 3, labels: 'lch'},
	hex: {channels: 1, labels: {'hex'}},
	keyword: {channels: 1, labels: {'keyword'}},
	ansi16: {channels: 1, labels: {'ansi16'}},
	ansi256: {channels: 1, labels: {'ansi256'}},
	hcg: {channels: 3, labels: {'h', 'c', 'g'}},
	apple: {channels: 3, labels: {'r16', 'g16', 'b16'}},
	gray: {channels: 1, labels: {'gray'}}
}

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
		when 0 
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

inspect convert.cmyk.rgb {31, 9, 0, 17}
