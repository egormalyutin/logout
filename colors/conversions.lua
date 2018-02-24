local cssKeywords = require('colors.names')
local inspector = require('inspect')
local inspect
inspect = function(...)
  return print(inspector(...))
end
local reverseKeywords = { }
for key, value in pairs(cssKeywords) do
  reverseKeywords[value] = key
end
local convert = {
  rgb = {
    channels = 3,
    labels = 'rgb'
  },
  hsl = {
    channels = 3,
    labels = 'hsl'
  },
  hsv = {
    channels = 3,
    labels = 'hsv'
  },
  hwb = {
    channels = 3,
    labels = 'hwb'
  },
  cmyk = {
    channels = 4,
    labels = 'cmyk'
  },
  xyz = {
    channels = 3,
    labels = 'xyz'
  },
  lab = {
    channels = 3,
    labels = 'lab'
  },
  lch = {
    channels = 3,
    labels = 'lch'
  },
  hex = {
    channels = 1,
    labels = {
      'hex'
    }
  },
  keyword = {
    channels = 1,
    labels = {
      'keyword'
    }
  },
  ansi16 = {
    channels = 1,
    labels = {
      'ansi16'
    }
  },
  ansi256 = {
    channels = 1,
    labels = {
      'ansi256'
    }
  },
  hcg = {
    channels = 3,
    labels = {
      'h',
      'c',
      'g'
    }
  },
  apple = {
    channels = 3,
    labels = {
      'r16',
      'g16',
      'b16'
    }
  },
  gray = {
    channels = 1,
    labels = {
      'gray'
    }
  }
}
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
  if 0 == _exp_0 then
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
return inspect(convert.cmyk.rgb({
  31,
  9,
  0,
  17
}))
