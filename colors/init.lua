local inspector = require('inspect')
local convert = require('colors.convert')
local inspect
inspect = function(...)
  return print(inspector(...))
end
local concat
concat = function(a, b)
  local res = { }
  if type(a) ~= 'table' then
    a = {
      a
    }
  end
  if type(b) ~= 'table' then
    b = {
      b
    }
  end
  for _index_0 = 1, #a do
    local v = a[_index_0]
    table.insert(res, v)
  end
  for _index_0 = 1, #b do
    local v = b[_index_0]
    table.insert(res, v)
  end
  return res
end
local ESC = string.char(27) .. '['
local ESC_PATTERN = string.char(27) .. '%['
local raw = {
  bold = {
    open = ESC .. 1 .. 'm',
    close = ESC .. 22 .. 'm',
    closePattern = ESC_PATTERN .. 22 .. 'm'
  },
  dim = {
    open = ESC .. 2 .. 'm',
    close = ESC .. 22 .. 'm',
    closePattern = ESC_PATTERN .. 22 .. 'm'
  },
  italic = {
    open = ESC .. 3 .. 'm',
    close = ESC .. 23 .. 'm',
    closePattern = ESC_PATTERN .. 23 .. 'm'
  },
  underline = {
    open = ESC .. 4 .. 'm',
    close = ESC .. 24 .. 'm',
    closePattern = ESC_PATTERN .. 24 .. 'm'
  },
  inverse = {
    open = ESC .. 7 .. 'm',
    close = ESC .. 27 .. 'm',
    closePattern = ESC_PATTERN .. 27 .. 'm'
  },
  hidden = {
    open = ESC .. 8 .. 'm',
    close = ESC .. 28 .. 'm',
    closePattern = ESC_PATTERN .. 28 .. 'm'
  },
  strikethrough = {
    open = ESC .. 9 .. 'm',
    close = ESC .. 29 .. 'm',
    closePattern = ESC_PATTERN .. 29 .. 'm'
  },
  black = {
    open = ESC .. 30 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  red = {
    open = ESC .. 31 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  green = {
    open = ESC .. 32 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  yellow = {
    open = ESC .. 33 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  blue = {
    open = ESC .. 34 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  magenta = {
    open = ESC .. 35 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  cyan = {
    open = ESC .. 36 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  white = {
    open = ESC .. 37 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  gray = {
    open = ESC .. 90 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  redBright = {
    open = ESC .. 91 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  greenBright = {
    open = ESC .. 92 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  yellowBright = {
    open = ESC .. 93 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  blueBright = {
    open = ESC .. 94 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  magentaBright = {
    open = ESC .. 95 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  cyanBright = {
    open = ESC .. 96 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  whiteBright = {
    open = ESC .. 97 .. 'm',
    close = ESC .. 39 .. 'm',
    closePattern = ESC_PATTERN .. 39 .. 'm'
  },
  bgBlack = {
    open = ESC .. 40 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgRed = {
    open = ESC .. 41 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgGreen = {
    open = ESC .. 42 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgYellow = {
    open = ESC .. 43 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgBlue = {
    open = ESC .. 44 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgMagenta = {
    open = ESC .. 45 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgCyan = {
    open = ESC .. 46 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgWhite = {
    open = ESC .. 47 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgBlackBright = {
    open = ESC .. 100 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgRedBright = {
    open = ESC .. 101 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgGreenBright = {
    open = ESC .. 102 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgYellowBright = {
    open = ESC .. 103 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgBlueBright = {
    open = ESC .. 104 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgMagentaBright = {
    open = ESC .. 105 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgCyanBright = {
    open = ESC .. 106 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  },
  bgWhiteBright = {
    open = ESC .. 107 .. 'm',
    close = ESC .. 49 .. 'm',
    closePattern = ESC_PATTERN .. 49 .. 'm'
  }
}
raw.grey = raw.gray
local wrapper
wrapper = function(func, bg)
  if bg == nil then
    bg = false
  end
  return function(...)
    local color = {
      ...
    }
    if type(color[1]) == 'table' then
      color = color[1]
    end
    local code = math.floor(convert.rgb.ansi256(convert[func].rgb(color)))
    local tp
    if bg then
      tp = '48;5;'
    else
      tp = '38;5;'
    end
    local tpNum
    if bg then
      tpNum = 49
    else
      tpNum = 39
    end
    return function(text)
      local open = ESC .. tp .. code .. 'm'
      local close = ESC .. tpNum .. 'm'
      local closePattern = ESC_PATTERN .. tpNum .. 'm'
      local str = string.gsub(text, closePattern, close .. open)
      local result = open .. str .. close
      return result
    end
  end
end
local funcs = {
  ansi = function(code)
    code = math.floor(code)
    return function(text)
      local open = ESC .. code .. 'm'
      local close = ESC .. 39 .. 'm'
      local closePattern = ESC_PATTERN .. 39 .. 'm'
      local str = string.gsub(text, closePattern, close .. open)
      local result = open .. str .. close
      return result
    end
  end,
  bgAnsi = function(code)
    code = math.floor(code)
    return function(text)
      local open = ESC .. (10 + code) .. 'm'
      local close = ESC .. 49 .. 'm'
      local closePattern = ESC_PATTERN .. 49 .. 'm'
      local str = string.gsub(text, closePattern, close .. open)
      local result = open .. str .. close
      return result
    end
  end,
  ansi256 = function(code)
    code = math.floor(code)
    return function(text)
      local open = ESC .. '38;5;' .. code .. 'm'
      local close = ESC .. 39 .. 'm'
      local closePattern = ESC_PATTERN .. 39 .. 'm'
      local str = string.gsub(text, closePattern, close .. open)
      local result = open .. str .. close
      return result
    end
  end,
  bgAnsi256 = function(code)
    code = math.floor(code)
    return function(text)
      local open = ESC .. '48;5;' .. (10 + code) .. 'm'
      local close = ESC .. 49 .. 'm'
      local closePattern = ESC_PATTERN .. 49 .. 'm'
      local str = string.gsub(text, closePattern, close .. open)
      local result = open .. str .. close
      return result
    end
  end,
  rgb = wrapper('rgb'),
  bgRgb = wrapper('rgb', true),
  hsl = wrapper('hsl'),
  bgHsl = wrapper('hsl', true),
  hsv = wrapper('hsv'),
  bgHsv = wrapper('hsv', true),
  hwb = wrapper('hwb'),
  bgHwb = wrapper('hwb', true),
  cmyk = wrapper('cmyk'),
  bgCmyk = wrapper('cmyk', true),
  xyz = wrapper('xyz'),
  bgXyz = wrapper('xyz', true),
  lab = wrapper('lab'),
  bgLab = wrapper('lab', true),
  lch = wrapper('lch'),
  bgLch = wrapper('lch', true),
  hex = wrapper('hex'),
  bgLch = wrapper('hex', true),
  keyword = wrapper('keyword'),
  bgKeyword = wrapper('keyword', true),
  hcg = wrapper('hcg'),
  bgHcg = wrapper('hcg', true),
  apple = wrapper('apple'),
  bgApple = wrapper('apple', true),
  gray = wrapper('gray'),
  bgGray = wrapper('gray', true)
}
funcs.bgRGB = funcs.bgRgb
funcs.bgHSL = funcs.bgHsl
funcs.ansi16 = funcs.ansi
funcs.bgAnsi16 = funcs.bgAnsi
local chain
chain = function()
  local methods = { }
  for key, value in pairs(raw) do
    methods[key] = function(text)
      local str = string.gsub(text, value.closePattern, value.close .. value.open)
      local result = value.open .. str .. value.close
      return result
    end
  end
  local gen
  gen = function(stack)
    if stack == nil then
      stack = { }
    end
    local mt = { }
    return setmetatable(mt, {
      __call = function(self, text)
        if stack then
          for _, f in pairs(stack) do
            text = f(text)
          end
        end
        return text
      end,
      __index = function(self, key)
        if funcs[key] then
          return function(...)
            return gen(concat(stack, funcs[key](...)))
          end
        elseif methods[key] then
          return gen(concat(stack, methods[key]))
        else
          return error('Style "' .. key .. '" wasn\'t found!')
        end
      end
    })
  end
  local res = gen()
  return res
end
local chalk = chain()
local message = chalk.blue
local err = chalk.red.bold
local name = 'Egor'
print(message('All is good...'))
print(string.format(message('Your name is %s!'), name))
print(chalk.bgYellow.black('I am a black line with yellow background ' .. chalk.white.bgRed.underline.bold('with white substring with red background') .. ' that becomes black again!'))
print(chalk.red('Something is going ' .. chalk.bold('really') .. ' bad...'))
print(err('SUPIR FATAL ERROR!1!!!!11one!one'))
return print(chalk.gray(70).bold('Bold gray!'))
