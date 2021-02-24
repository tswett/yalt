local freeze = require 'src/freeze'
local sexpressions = require 'src/sexpressions'

_ENV = freeze.frozen(_ENV)

local combcalc = {}

local sx = sexpressions.sexpression

function combcalc.head(sexpr)
  if type(sexpr) == 'table' then
    return sexpr[1]
  else
    return nil
  end
end

local head = combcalc.head

function combcalc.tail(sexpr)
  if type(sexpr) == 'table' then
    return table.unpack(sexpr, 2)
  else
    return nil
  end
end

local tail = combcalc.tail

function combcalc.step_i(skip, input)
  if skip then
    return true, input
  end
  
  if head(input) == 'i' then
    local x = tail(input)
    
    return true, x
  else
    return false, input
  end
end

function combcalc.step_k(skip, input)
  if skip then
    return true, input
  end
  
  if head(head(input)) == 'k' then
    local x = tail(head(input))
    
    return true, x
  else
    return false, input
  end
end

function combcalc.step_s(skip, input)
  if skip then
    return true, input
  end
  
  if head(head(head(input))) == 's' then
    local x = tail(head(head(input)))
    local y = tail(head(input))
    local z = tail(input)
    
    return true, sx {{x, z}, {y, z}}
  else
    return false, input
  end
end

function combcalc.ski_reduce(input)
  -- print('ski_reduce: entering with input ' .. tostring(input))
  
  if type(input) == 'table' then
    -- print('ski_reduce on ' .. tostring(input) .. ': head is ' .. tostring(head(input)))
    
    local head_evaluated = combcalc.ski_reduce(head(input))
    
    -- print('ski_reduce on ' .. tostring(input) .. ': head_evaluated is ' .. tostring(head(input)))
    
    if head_evaluated ~= head(input) then
      return combcalc.ski_reduce(sx {head_evaluated, tail(input)})
    end
    
    local stepped, result = false, input
    stepped, result = combcalc.step_s(stepped, result)
    stepped, result = combcalc.step_k(stepped, result)
    stepped, result = combcalc.step_i(stepped, result)
    if stepped then
      return combcalc.ski_reduce(result)
    end
  end
  
  -- print('ski_reduce on ' .. tostring(input) .. ': could not reduce any further')
  
  return input
end

return combcalc