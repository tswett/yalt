local freeze = require 'src/freeze'

_ENV = freeze.frozen(_ENV)

local sexpressions = {}

function sexpressions.is_letter(char)
  local byte = string.byte(char)
  
  if byte >= string.byte('A') and byte <= string.byte('Z') then
    return true
  elseif byte >= string.byte('a') and byte <= string.byte('z') then
    return true
  else
    return false
  end
end

function sexpressions.chars(str)
  local index = 1
  
  local function next_char()
    if #str < index then
      return nil
    else
      local char = string.char(string.byte(str, index))
      index = index + 1
      return char
    end
  end
  
  return next_char
end

function sexpressions.parse(input)
  if type(input) ~= 'string' then
    return false
  end
  
  if #input == 0 then
    return false
  end
  
  for char in sexpressions.chars(input) do
    if not (char == '_' or sexpressions.is_letter(char)) then
      return false
    end
  end
  
  return true, input
end

return sexpressions