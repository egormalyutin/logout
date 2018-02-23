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
return getOS
