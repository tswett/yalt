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

function sexpressions.chars(str, index)
  index = index or 1
  
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

sexpressions.sexpression_metatable = {}

function sexpressions.sexpression_metatable.__tostring(sexpr)
  local contents_strings = {}
  
  for i, v in ipairs(sexpr) do
    contents_strings[i] = tostring(v)
  end
  
  return '(' .. table.concat(contents_strings, ' ') .. ')'
end

function sexpressions.sexpression_metatable.__eq(sexpr1, sexpr2)
  if #sexpr1 ~= #sexpr2 then
    return false
  end
  
  for i, v in ipairs(sexpr1) do
    if sexpr1[i] ~= sexpr2[i] then
      return false
    end
  end
  
  return true
end

function sexpressions.sexpression(input)
  local sexpr = {}
  
  for i, v in ipairs(input) do
    if type(v) == 'table' then
      sexpr[i] = sexpressions.sexpression(v)
    else
      sexpr[i] = v
    end
  end
  
  setmetatable(sexpr, sexpressions.sexpression_metatable)
  
  return sexpr
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

function sexpressions.parse_atom_from(input, index)
  index = index or 1
  
  if type(input) ~= 'string' then
    return false
  end
  
  if #input < index then
    return false
  end
  
  local atom = ''
  
  for char in sexpressions.chars(input, index) do
    if char == '_' or sexpressions.is_letter(char) then
      atom = atom .. char
      index = index + 1
    else
      break
    end
  end
  
  if atom == '' then
    return false
  else
    return true, atom, index
  end
end

return sexpressions