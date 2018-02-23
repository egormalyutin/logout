local U = string.char(27)
local ESC = U .. '['
local str = ESC .. 'K'
print(string.find(str, pattern .. '|' .. p2))
local strip
strip = function() end
