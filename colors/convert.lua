local cssKeywords = require('colors.names')
local inspector = require('inspect')
local inspect
inspect = function(...)
  return print(inspector(...))
end
local isIn
isIn = function(obj, value)
  for key, value2 in ipairs(obj) do
    if value == value2 then
      return true
    end
  end
  return false
end
local round
round = function(num, numDecimalPlaces)
  local mult = 10 ^ (numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
local boolToNum
boolToNum = function(a)
  if a then
    return 1
  else
    return 0
  end
end
local reverseKeywords = { }
for key, value in pairs(cssKeywords) do
  reverseKeywords[value] = key
end
local convert = {
  rgb = { },
  hsl = { },
  hsv = { },
  hwb = { },
  cmyk = { },
  xyz = { },
  lab = { },
  lch = { },
  hex = { },
  keyword = { },
  ansi16 = { },
  ansi256 = { },
  hcg = { },
  apple = { },
  gray = { }
}
convert.rgb.rgb = function(...)
  return ...
end
convert.hsl.hsl = function(...)
  return ...
end
convert.hsv.hsv = function(...)
  return ...
end
convert.hwb.hwb = function(...)
  return ...
end
convert.cmyk.cmyk = function(...)
  return ...
end
convert.xyz.xyz = function(...)
  return ...
end
convert.lab.lab = function(...)
  return ...
end
convert.lch.lch = function(...)
  return ...
end
convert.hex.hex = function(...)
  return ...
end
convert.keyword.keyword = function(...)
  return ...
end
convert.ansi16.ansi16 = function(...)
  return ...
end
convert.ansi256.ansi256 = function(...)
  return ...
end
convert.hcg.hcg = function(...)
  return ...
end
convert.apple.apple = function(...)
  return ...
end
convert.gray.gray = function(...)
  return ...
end
convert.rgb.hsl = function(rgb)
  local r = rgb[1] / 255
  local g = rgb[2] / 255
  local b = rgb[3] / 255
  local min = math.min(r, g, b)
  local max = math.max(r, g, b)
  local delta = max - min
  local h, s, l
  if max == min then
    h = 0
  elseif r == max then
    h = (g - b) / delta
  elseif g == max then
    h = 2 + (b - r) / delta
  elseif b == max then
    h = 4 + (r - g) / delta
  end
  h = math.min(h * 60, 360)
  if h < 0 then
    h = h + 360
  end
  l = (min + max) / 2
  if max == min then
    s = 0
  elseif l <= 0.5 then
    s = delta / (max + min)
  else
    s = delta / (2 - max - min)
  end
  return {
    h,
    s * 100,
    l * 100
  }
end
convert.rgb.hsv = function(rgb)
  local r = rgb[1]
  local g = rgb[2]
  local b = rgb[3]
  local min = math.min(r, g, b)
  local max = math.max(r, g, b)
  local delta = max - min
  local h, s, v
  if max == 0 then
    s = 0
  else
    s = (delta / max * 1000) / 10
  end
  if max == min then
    h = 0
  elseif r == max then
    h = (g - b) / delta
  elseif g == max then
    h = 2 + (b - r) / delta
  elseif b == max then
    h = 4 + (r - g) / delta
  end
  h = math.min(h * 60, 360)
  if (h < 0) then
    h = h + 360
  end
  v = ((max / 255) * 1000) / 10
  return {
    h,
    s,
    v
  }
end
convert.rgb.hwb = function(rgb)
  local r = rgb[1]
  local g = rgb[2]
  local b = rgb[3]
  local h = convert.rgb.hsl(rgb)[1]
  local w = 1 / 255 * math.min(r, math.min(g, b))
  b = 1 - 1 / 255 * math.max(r, math.max(g, b))
  return {
    h,
    w * 100,
    b * 100
  }
end
convert.rgb.cmyk = function(rgb)
  local r = rgb[1] / 255
  local g = rgb[2] / 255
  local b = rgb[3] / 255
  local c, m, y, k
  k = math.min(1 - r, 1 - g, 1 - b)
  c = ((1 - r - k) / (1 - k)) or 0
  m = ((1 - g - k) / (1 - k)) or 0
  y = ((1 - b - k) / (1 - k)) or 0
  return {
    c * 100,
    m * 100,
    y * 100,
    k * 100
  }
end
local comparativeDistance
comparativeDistance = function(x, y)
  return ((math.pow((x[1] - y[1]), 2)) + (math.pow((x[2] - y[2]), 2)) + (math.pow((x[3] - y[3]), 2)))
end
convert.rgb.keyword = function(rgb)
  local reversed = reverseKeywords[rgb]
  if reversed then
    return reversed
  end
  local ccd = math.huge
  local cck
  for key, value in pairs(cssKeywords) do
    local distance = comparativeDistance(rgb, value)
    if distance < ccd then
      ccd = distance
      cck = key
    end
  end
  return cck
end
convert.keyword.rgb = function(keyword)
  if not (cssKeywords[keyword]) then
    error('Not found keyword ' .. keyword .. '!')
  end
  return cssKeywords[keyword]
end
convert.rgb.xyz = function(rgb)
  local r = rgb[1] / 255
  local g = rgb[2] / 255
  local b = rgb[3] / 255
  if r > 0.04045 then
    r = math.pow(((r + 0.055) / 1.055), 2.4)
  else
    r = (r / 12.92)
  end
  if g > 0.04045 then
    g = math.pow(((g + 0.055) / 1.055), 2.4)
  else
    g = (g / 12.92)
  end
  if b > 0.04045 then
    b = math.pow(((b + 0.055) / 1.055), 2.4)
  else
    b = (b / 12.92)
  end
  local x = (r * 0.4124) + (g * 0.3576) + (b * 0.1805)
  local y = (r * 0.2126) + (g * 0.7152) + (b * 0.0722)
  local z = (r * 0.0193) + (g * 0.1192) + (b * 0.9505)
  return {
    x * 100,
    y * 100,
    z * 100
  }
end
convert.rgb.lab = function(rgb)
  local xyz = convert.rgb.xyz(rgb)
  local x = xyz[1]
  local y = xyz[2]
  local z = xyz[3]
  local l, a, b
  x = x / 95.047
  y = y / 100
  z = z / 108.883
  if x > 0.008856 then
    x = math.pow(x, 1 / 3)
  else
    x = (7.787 * x) + (16 / 116)
  end
  if y > 0.008856 then
    y = math.pow(y, 1 / 3)
  else
    y = (7.787 * y) + (16 / 116)
  end
  if z > 0.008856 then
    z = math.pow(z, 1 / 3)
  else
    z = (7.787 * z) + (16 / 116)
  end
  l = (116 * y) - 16
  a = 500 * (x - y)
  b = 200 * (y - z)
  return {
    l,
    a,
    b
  }
end
convert.hsl.rgb = function(hsl)
  local h = hsl[1] / 360
  local s = hsl[2] / 100
  local l = hsl[3] / 100
  local t1, t2, t3, rgb, val
  if s == 0 then
    val = l * 255
    return {
      val,
      val,
      val
    }
  end
  if l < 0.5 then
    t2 = l * (1 + s)
  else
    t2 = l + s - l * s
  end
  t1 = 2 * l - t2
  rgb = {
    0,
    0,
    0
  }
  local i = 1
  while i <= 3 do
    t3 = h + (1 / 3) * (-(i - 1))
    if t3 < 0 then
      t3 = t3 + 1
    end
    if t3 > 1 then
      t3 = t3 - 1
    end
    if (6 * t3) < 1 then
      val = t1 + ((t2 - t1) * 6 * t3)
    elseif 2 * t3 < 1 then
      val = t2
    elseif 3 * t3 < 2 then
      val = t1 + ((t2 - t1) * (2 / 3 - t3) * 6)
    else
      val = t1
    end
    rgb[i] = val * 255
    i = i + 1
  end
  return {
    rgb[3],
    rgb[1],
    rgb[2]
  }
end
convert.hsl.hsv = function(hsl)
  local h = hsl[1]
  local s = hsl[2] / 100
  local l = hsl[3] / 100
  local smin = s
  local lmin = math.max(l, 0.01)
  local sv, v
  l = l * 2
  s = s * (function()
    if (l <= 1) then
      return l
    else
      return 2 - l
    end
  end)()
  smin = smin * (function()
    if lmin <= 1 then
      return lmin
    else
      return 2 - lmin
    end
  end)()
  v = (l + s) / 2
  if l == 0 then
    sv = (2 * smin) / (lmin + smin)
  else
    sv = (2 * s) / (l + s)
  end
  return {
    h,
    sv * 100,
    v * 100
  }
end
convert.hsv.rgb = function(hsv)
  local h = hsv[1] / 60
  local s = hsv[2] / 100
  local v = hsv[3] / 100
  local hi = math.fmod(math.floor(h), 6)
  local f = h - math.floor(h)
  local p = 255 * v * (1 - s)
  local q = 255 * v * (1 - (s * f))
  local t = 255 * v * (1 - (s * (1 - f)))
  v = v * 255
  local _exp_0 = (hi)
  if 0 == _exp_0 then
    return {
      v,
      t,
      p
    }
  elseif 1 == _exp_0 then
    return {
      q,
      v,
      p
    }
  elseif 2 == _exp_0 then
    return {
      p,
      v,
      t
    }
  elseif 3 == _exp_0 then
    return {
      p,
      q,
      v
    }
  elseif 4 == _exp_0 then
    return {
      t,
      p,
      v
    }
  elseif 5 == _exp_0 then
    return {
      v,
      p,
      q
    }
  end
end
convert.hsv.hsl = function(hsv)
  local h = hsv[1]
  local s = hsv[2] / 100
  local v = hsv[3] / 100
  local vmin = math.max(v, 0.01)
  local lmin, sl, l
  l = (2 - s) * v
  lmin = (2 - s) * vmin
  sl = s * vmin
  sl = sl / (function()
    if (lmin <= 1) then
      return lmin
    else
      return 2 - lmin
    end
  end)()
  sl = sl or 0
  l = l / 2
  return {
    h,
    sl * 100,
    l * 100
  }
end
convert.hwb.rgb = function(hwb)
  local h = hwb[1] / 360
  local wh = hwb[2] / 100
  local bl = hwb[3] / 100
  local ratio = wh + bl
  local i, v, f, n
  if ratio > 1 then
    wh = wh / ratio
    bl = bl / ratio
  end
  i = math.floor(6 * h)
  v = 1 - bl
  f = 6 * h - i
  if ((i & 0x01) ~= 0) then
    f = 1 - f
  end
  n = wh + f * (v - wh)
  local r, g, b
  local _exp_0 = i
  if 0 == _exp_0 or 6 == _exp_0 then
    r = v
    g = n
    b = wh
  elseif 1 == _exp_0 then
    r = n
    g = v
    b = wh
  elseif 2 == _exp_0 then
    r = wh
    g = v
    b = n
  elseif 3 == _exp_0 then
    r = wh
    g = n
    b = v
  elseif 4 == _exp_0 then
    r = n
    g = wh
    b = v
  elseif 5 == _exp_0 then
    r = v
    g = wh
    b = n
  else
    r = v
    g = n
    b = wh
  end
  return {
    r * 255,
    g * 255,
    b * 255
  }
end
convert.cmyk.rgb = function(cmyk)
  local c = cmyk[1] / 100
  local m = cmyk[2] / 100
  local y = cmyk[3] / 100
  local k = cmyk[4] / 100
  local r, g, b
  r = 1 - math.min(1, c * (1 - k) + k)
  g = 1 - math.min(1, m * (1 - k) + k)
  b = 1 - math.min(1, y * (1 - k) + k)
  return {
    r * 255,
    g * 255,
    b * 255
  }
end
convert.xyz.rgb = function(xyz)
  local x = xyz[1] / 100
  local y = xyz[2] / 100
  local z = xyz[3] / 100
  local r, g, b
  r = (x * 3.2406) + (y * -1.5372) + (z * -0.4986)
  g = (x * -0.9689) + (y * 1.8758) + (z * 0.0415)
  b = (x * 0.0557) + (y * -0.2040) + (z * 1.0570)
  if r > 0.0031308 then
    r = ((1.055 * math.pow(r, 1.0 / 2.4)) - 0.055)
  else
    r = r * 12.92
  end
  if g > 0.0031308 then
    g = ((1.055 * math.pow(g, 1.0 / 2.4)) - 0.055)
  else
    g = g * 12.92
  end
  if b > 0.0031308 then
    b = ((1.055 * math.pow(b, 1.0 / 2.4)) - 0.055)
  else
    b = b * 12.92
  end
  r = math.min(math.max(0, r), 1)
  g = math.min(math.max(0, g), 1)
  b = math.min(math.max(0, b), 1)
  return {
    r * 255,
    g * 255,
    b * 255
  }
end
convert.xyz.lab = function(xyz)
  local x = xyz[1]
  local y = xyz[2]
  local z = xyz[3]
  local l, a, b
  x = x / 95.047
  y = y / 100
  z = z / 108.883
  if x > 0.008856 then
    x = math.pow(x, 1 / 3)
  else
    x = (7.787 * x) + (16 / 116)
  end
  if y > 0.008856 then
    y = math.pow(y, 1 / 3)
  else
    y = (7.787 * y) + (16 / 116)
  end
  if z > 0.008856 then
    z = math.pow(z, 1 / 3)
  else
    z = (7.787 * z) + (16 / 116)
  end
  l = (116 * y) - 16
  a = 500 * (x - y)
  b = 200 * (y - z)
  return {
    l,
    a,
    b
  }
end
convert.lab.xyz = function(lab)
  local l = lab[1]
  local a = lab[2]
  local b = lab[3]
  local x, y, z
  y = (l + 16) / 116
  x = a / 500 + y
  z = y - b / 200
  local y2 = math.pow(y, 3)
  local x2 = math.pow(x, 3)
  local z2 = math.pow(z, 3)
  if y2 > 0.008856 then
    y = y2
  else
    y = (y - 16 / 116) / 7.787
  end
  if x2 > 0.008856 then
    x = x2
  else
    x = (x - 16 / 116) / 7.787
  end
  if z2 > 0.008856 then
    z = z2
  else
    z = (z - 16 / 116) / 7.787
  end
  x = x * 95.047
  y = y * 100
  z = z * 108.883
  return {
    x,
    y,
    z
  }
end
convert.lab.rgb = function(lab)
  return convert.xyz.rgb(convert.lab.xyz(lab))
end
convert.lab.lch = function(lab)
  local l = lab[1]
  local a = lab[2]
  local b = lab[3]
  local hr, h, c
  hr = math.atan2(b, a)
  h = hr * 360 / 2 / math.pi
  if h < 0 then
    h = h + 360
  end
  c = math.sqrt(a * a + b * b)
  return {
    l,
    c,
    h
  }
end
convert.lch.lab = function(lch)
  local l = lch[1]
  local c = lch[2]
  local h = lch[3]
  local a, b, hr
  hr = h / 360 * 2 * math.pi
  a = c * math.cos(hr)
  b = c * math.sin(hr)
  return {
    l,
    a,
    b
  }
end
convert.lch.rgb = function(lch)
  return convert.lab.rgb(convert.lch.lab(lch))
end
convert.rgb.ansi16 = function(...)
  local arguments = {
    ...
  }
  local args = arguments[1]
  local r = args[1]
  local g = args[2]
  local b = args[3]
  local value
  if isIn(arguments, 1) then
    value = arguments[1]
  else
    value = convert.rgb.hsv(args)[3]
  end
  value = round(value / 50)
  if value == 0 then
    return 30
  end
  local ansi = (30 + ((round(b / 255) << 2) | (round(g / 255) << 1) | round(r / 255)))
  if value == 2 then
    ansi = ansi + 60
  end
  return ansi
end
convert.hsv.ansi16 = function(args)
  return convert.rgb.ansi16(convert.hsv.rgb(args), args[3])
end
convert.rgb.ansi256 = function(args)
  local r = args[1]
  local g = args[2]
  local b = args[3]
  if (r == g) and (g == b) then
    if r < 8 then
      return 16
    end
    if r > 248 then
      return 231
    end
    return round(((r - 8) / 247) * 24) + 232
  end
  local ansi = (16 + (36 * round(r / 255 * 5)) + (6 * round(g / 255 * 5)) + round(b / 255 * 5))
  return ansi
end
convert.ansi16.rgb = function(args)
  local color = math.fmod(args, 10)
  if (color == 0) or (color == 7) then
    if args > 50 then
      color = color + 3.5
    end
    color = color / 10.5 * 255
    return {
      color,
      color,
      color
    }
  end
  local mult = (boolToNum(args > 50) + 1) * 0.5
  local r = ((color & 1) * mult) * 255
  local g = (((color >> 1) & 1) * mult) * 255
  local b = (((color >> 2) & 1) * mult) * 255
  return {
    r,
    g,
    b
  }
end
convert.ansi256.rgb = function(args)
  if args >= 232 then
    local c = (args - 232) * 10 + 8
    return {
      c,
      c,
      c
    }
  end
  args = args - 16
  local rem
  local r = math.floor(args / 36) / 5 * 255
  rem = math.fmod(args, 36)
  local g = math.floor(rem / 6) / 5 * 255
  local b = math.fmod(rem, 6) / 5 * 255
  return {
    r,
    g,
    b
  }
end
convert.rgb.hex = function(args)
  local integer = (((round(args[1]) & 0xFF) << 16) + ((round(args[2]) & 0xFF) << 8) + (round(args[3]) & 0xFF))
  local str = string.format('%x', integer):upper()
  return string.sub('000000', 0, 6 - #str) .. str
end
convert.hex.rgb = function(args)
  local formatted
  if type(args) ~= 'string' then
    formatted = string.format('%x', args)
  else
    formatted = args:gsub('^0x', '')
    formatted = formatted:gsub('%#', '')
  end
  formatted = formatted:lower()
  local match = formatted:match('[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]')
  if not match then
    match = formatted:match('[a-f0-9][a-f0-9][a-f0-9]')
  end
  if not match then
    return {
      0,
      0,
      0
    }
  end
  local colorString = match
  if #match == 3 then
    local A1 = string.sub(match, 1, 1)
    local B1 = string.sub(match, 2, 2)
    local C1 = string.sub(match, 3, 3)
    colorString = A1 .. A1 .. B1 .. B1 .. C1 .. C1
  end
  local integer = tonumber(colorString, 16)
  local r = (integer >> 16) & 0xFF
  local g = (integer >> 8) & 0xFF
  local b = integer & 0xFF
  return {
    r,
    g,
    b
  }
end
convert.rgb.hcg = function(rgb)
  local r = rgb[1] / 255
  local g = rgb[2] / 255
  local b = rgb[3] / 255
  local max = math.max(math.max(r, g), b)
  local min = math.min(math.min(r, g), b)
  local chroma = (max - min)
  local grayscale, hue
  if chroma < 1 then
    grayscale = min / (1 - chroma)
  else
    grayscale = 0
  end
  if chroma <= 0 then
    hue = 0
  elseif max == r then
    hue = math.fmod(((g - b) / chroma), 6)
  elseif max == g then
    hue = 2 + (b - r) / chroma
  else
    hue = 4 + (r - g) / chroma + 4
  end
  hue = hue / 6
  hue = math.fmod(hue, 1)
  return {
    hue * 360,
    chroma * 100,
    grayscale * 100
  }
end
convert.hsl.hcg = function(hsl)
  local s = hsl[2] / 100
  local l = hsl[3] / 100
  local c = 1
  local f = 0
  if l < 0.5 then
    c = 2.0 * s * l
  else
    c = 2.0 * s * (1.0 - l)
  end
  if c < 1.0 then
    f = (l - 0.5 * c) / (1.0 - c)
  end
  return {
    hsl[1],
    c * 100,
    f * 100
  }
end
convert.hsv.hcg = function(hsv)
  local s = hsv[2] / 100
  local v = hsv[3] / 100
  local c = s * v
  local f = 0
  if c < 1.0 then
    f = (v - c) / (1 - c)
  end
  return {
    hsv[1],
    c * 100,
    f * 100
  }
end
convert.hcg.rgb = function(hcg)
  local h = hcg[1] / 360
  local c = hcg[2] / 100
  local g = hcg[3] / 100
  if c == 0.0 then
    return {
      g * 255,
      g * 255,
      g * 255
    }
  end
  local pure = {
    0,
    0,
    0
  }
  local hi = math.fmod(h, 1) * 6
  local v = math.fmod(hi, 1)
  local w = 1 - v
  local mg = 0
  local _exp_0 = math.floor(hi)
  if 0 == _exp_0 then
    pure[1] = 1
    pure[2] = v
    pure[3] = 0
  elseif 1 == _exp_0 then
    pure[1] = w
    pure[2] = 1
    pure[3] = 0
  elseif 2 == _exp_0 then
    pure[1] = 0
    pure[2] = 1
    pure[3] = v
  elseif 3 == _exp_0 then
    pure[1] = 0
    pure[2] = w
    pure[3] = 1
  elseif 4 == _exp_0 then
    pure[1] = v
    pure[2] = 0
    pure[3] = 1
  else
    pure[1] = 1
    pure[2] = 0
    pure[3] = w
  end
  mg = (1.0 - c) * g
  return {
    (c * pure[1] + mg) * 255,
    (c * pure[2] + mg) * 255,
    (c * pure[3] + mg) * 255
  }
end
convert.hcg.hsv = function(hcg)
  local c = hcg[2] / 100
  local g = hcg[3] / 100
  local v = c + g * (1.0 - c)
  local f = 0
  if v > 0.0 then
    f = c / v
  end
  return {
    hcg[1],
    f * 100,
    v * 100
  }
end
convert.hcg.hsl = function(hcg)
  local c = hcg[2] / 100
  local g = hcg[3] / 100
  local l = g * (1.0 - c) + 0.5 * c
  local s = 0
  if (l > 0.0) and (l < 0.5) then
    s = c / (2 * l)
  elseif (l >= 0.5) and (l < 1.0) then
    s = c / (2 * (1 - l))
  end
  return {
    hcg[1],
    s * 100,
    l * 100
  }
end
convert.hcg.hwb = function(hcg)
  local c = hcg[2] / 100
  local g = hcg[3] / 100
  local v = c + g * (1.0 - c)
  return {
    hcg[1],
    (v - c) * 100,
    (1 - v) * 100
  }
end
convert.apple.rgb = function(apple)
  return {
    (apple[1] / 65535) * 255,
    (apple[2] / 65535) * 255,
    (apple[3] / 65535) * 255
  }
end
convert.rgb.apple = function(rgb)
  return {
    (rgb[1] / 255) * 65535,
    (rgb[2] / 255) * 65535,
    (rgb[3] / 255) * 65535
  }
end
convert.gray.rgb = function(args)
  return {
    args[1] / 100 * 255,
    args[1] / 100 * 255,
    args[1] / 100 * 255
  }
end
convert.gray.hsv = function(args)
  return {
    0,
    0,
    args[1]
  }
end
convert.gray.hsl = convert.gray.hsv
convert.gray.hwb = function(gray)
  return {
    0,
    100,
    gray[1]
  }
end
convert.gray.cmyk = function(gray)
  return {
    0,
    0,
    0,
    gray[1]
  }
end
convert.gray.lab = function(gray)
  return {
    gray[1],
    0,
    0
  }
end
convert.gray.hex = function(gray)
  local val = round(gray[1] / 100 * 255) & 0xFF
  local integer = (val << 16) + (val << 8) + val
  local str = string.format('%x', integer):upper()
  return string.sub('000000', 0, 6 - #str) .. str
end
convert.rgb.gray = function(rgb)
  local val = (rgb[1] + rgb[2] + rgb[3]) / 3
  return {
    val / 255 * 100
  }
end
return convert
