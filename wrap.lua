local isFullwidth
isFullwidth = function(x)
  return (x >= 4352) and (x <= 4447 or x == 9001 or x == 9002 or (11904 <= x and x <= 12871 and x ~= 12351) or (12880 <= x and x <= 19903) or (19968 <= x and x <= 42182) or (43360 <= x and x <= 43388) or (44032 <= x and x <= 55203) or (63744 <= x and x <= 64255) or (65040 <= x and x <= 65049) or (65072 <= x and x <= 65131) or (65281 <= x and x <= 65376) or (65504 <= x and x <= 65510) or (110592 <= x and x <= 110593) or (127488 <= x and x <= 127569) or (131072 <= x and x <= 262141))
end
local stripPattern = "[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]"
local escapes = require('escapes')
local cursor = require('cursor')
local utf = require('utf8lib')
local stripAnsi
stripAnsi = function(text)
  return string.gsub(text, stripPattern, '')
end
local stringWidth
stringWidth = function(str)
  str = stripAnsi(str)
  local w = 0
  local i = 1
  while i <= utf8.len(str) do
    local _continue_0 = false
    repeat
      local code
      local sb = utf.sub(str, i, i)
      for _, c in utf8.codes(sb) do
        code = c
        break
      end
      if code <= 31 or ((code >= 127) and (code <= 159)) then
        _continue_0 = true
        break
      end
      if (code >= 768) and (code <= 879) then
        _continue_0 = true
        break
      end
      if isFullwidth(code) then
        w = w + 2
      else
        w = w + 1
      end
      i = i + 1
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  return w
end
return stringWidth
