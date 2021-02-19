local freeze = require 'src/freeze'

_ENV = freeze.frozen(_ENV)

local sexpressions = {}

function sexpressions.is_letter(char)
  local byte = string.byte(char)
  
  if (byte >= string.byte('A')) and (byte <= string.byte('Z')) then
    return true
  elseif (byte >= string.byte('a') and byte <= string.byte('z')) then
    return true
  else
    return false
  end
end

function sexpressions.parse(input)
  if type(input) ~= 'string' then
    return false
  end
  
  if #input == 0 then
    return false
  end
  
  for i = 1, #input do
    local byte = string.byte(input, i)
    if not (byte == string.byte('_') or ((byte >= string.byte('a')) and (byte <= string.byte('z')))) then
      return false
    end
  end
  
  return true, input
end

return sexpressions