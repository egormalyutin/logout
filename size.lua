local getOS
getOS = function()
  if love and love.system and love.system.getOS then
    local _exp_0 = love.system.getOS()
    if 'Linux' == _exp_0 or 'Android' == _exp_0 then
      return 'linux'
    elseif 'OS X' == _exp_0 or 'iOS' == _exp_0 then
      return 'darwin'
    elseif 'Windows' == _exp_0 then
      return 'windows'
    end
  elseif jit and jit.os then
    local r = jit.os:lower()
    if (r:match('windows')) or (r:match('^mingw')) or (r:match('^cygwin')) then
      return 'windows'
    elseif (r:match('linux')) or (r:match('bsd$')) then
      return 'linux'
    elseif (r:match('mac')) or (r:match('darwin')) then
      return 'darwin'
    end
  else
    if package.cpath:match('%.so') then
      return 'linux'
    elseif package.cpath:match('%.dylib') then
      return 'darwin'
    elseif package.cpath:match('%.dll') then
      return 'windows'
    end
  end
end
local OS = getOS()
local exec
exec = function(command)
  local file = io.popen(command)
  return file:read('*all')
end
local series
series = function(a, b, c, d)
  local err, obj = pcall(a)
  if obj and (obj[1] ~= nil) and (obj[1] ~= nil) then
    return obj[1], obj[2]
  else
    err, obj = pcall(b)
    if obj and (obj[1] ~= nil) and (obj[1] ~= nil) then
      return obj[1], obj[2]
    else
      err, obj = pcall(c)
      if obj and (obj[1] ~= nil) and (obj[1] ~= nil) then
        return obj[1], obj[2]
      else
        err, obj = pcall(d)
        if obj and (obj[1] ~= nil) and (obj[1] ~= nil) then
          return obj[1], obj[2]
        end
      end
    end
  end
  return nil, nil
end
local getPath
getPath = function()
  local str = debug.getinfo(2, "S").source:sub(2)
  return (str:match("(.*/)")) or './'
end
local linux
linux = function()
  return series(function()
    local w, h = os.getenv('COLUMNS'), os.getenv('LINES')
    return {
      w,
      h
    }
  end, function()
    local res1 = exec('echo $COLUMNS $LINES')
    local res2 = res1:gmatch('%d+')
    local w, h = res2(), res2()
    return {
      w,
      h
    }
  end, function()
    local res1 = exec('tput cols && tput lines')
    local res2 = res1:gmatch('%d+')
    local w, h = res2(), res2()
    return {
      w,
      h
    }
  end, function()
    local res1 = exec('resize -u')
    local res2 = res1:gmatch('%d+')
    local w, h = res2(), res2()
    return {
      w,
      h
    }
  end)
end
local darwin
darwin = function()
  return series(function()
    local res1 = exec(getPath() .. '/term-size')
    local res2 = res1:gmatch('%d+')
    local w, h = res2(), res2()
    return {
      w,
      h
    }
  end)
end
local windows
windows = function()
  return series(function()
    local res1 = exec(getPath() .. '/term-size.exe')
    local res2 = res1:gmatch('%d+')
    local w, h = res2(), res2()
    return {
      w,
      h
    }
  end)
end
local getSize
getSize = function()
  local _exp_0 = OS
  if 'linux' == _exp_0 then
    return linux()
  elseif 'darwin' == _exp_0 then
    return darwin()
  elseif 'windows' == _exp_0 then
    return windows()
  end
end
return getSize
