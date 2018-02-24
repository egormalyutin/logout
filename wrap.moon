-- U = string.char 27
-- ESC = U .. '['
-- str = ESC .. 'K'
-- print string.find str, pattern .. '|' .. p2

-- strip = () ->

-- https://github.com/sindresorhus/is-fullwidth-code-point/blob/master/index.js
-- all numbers are encoded to 10th system because perfomance
isFullwidth = (x) ->
	return (x >= 4352) and (
		x <= 4447 or  -- Hangul Jamo
		x == 9001 or -- LEFT-POINTING ANGLE BRACKET
		x == 9002 or -- RIGHT-POINTING ANGLE BRACKET
		-- CJK Radicals Supplement .. Enclosed CJK Letters and Months
		(11904 <= x and x <= 12871 and x ~= 12351) or
		-- Enclosed CJK Letters and Months .. CJK Unified Ideographs Extension A
		(12880 <= x and x <= 19903) or
		-- CJK Unified Ideographs .. Yi Radicals
		(19968 <= x and x <= 42182) or
		-- Hangul Jamo Extended-A
		(43360 <= x and x <= 43388) or
		-- Hangul Syllables
		(44032 <= x and x <= 55203) or
		-- CJK Compatibility Ideographs
		(63744 <= x and x <= 64255) or
		-- Vertical Forms
		(65040 <= x and x <= 65049) or
		-- CJK Compatibility Forms .. Small Form Variants
		(65072 <= x and x <= 65131) or
		-- Halfwidth and Fullwidth Forms
		(65281 <= x and x <= 65376) or
		(65504 <= x and x <= 65510) or
		-- Kana Supplement
		(110592 <= x and x <= 110593) or
		-- Enclosed Ideographic Supplement
		(127488 <= x and x <= 127569) or
		-- CJK Unified Ideographs Extension B .. Tertiary Ideographic Plane
		(131072 <= x and x <= 262141)
	)

stripPattern = "[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]"

escapes = require 'escapes'
cursor  = require 'cursor'
utf = require 'utf8lib'

stripAnsi = (text) ->
	return string.gsub text, stripPattern, ''

stringWidth = (str) ->
	str = stripAnsi str

	w = 0

	i = 1
	while i <= utf8.len str
		local code

		sb = utf.sub str, i, i
		for _, c in utf8.codes sb
			code = c
			break

		if code <= 31 or ((code >= 127) and (code <= 159))
			continue

		if (code >= 768) and (code <= 879)
			continue

		if isFullwidth code
			w += 2
		else
			w += 1

		i += 1

	return w

return stringWidth
