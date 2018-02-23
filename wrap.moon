U = string.char 27
ESC = U .. '['
str = ESC .. 'K'
print string.find str, pattern .. '|' .. p2

strip = () ->
