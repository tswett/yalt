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

function combcalc.ski_reduce(input)
  -- print('ski_reduce: entering with input ' .. tostring(input))
  
  if type(input) == 'table' then
    -- print('ski_reduce on ' .. tostring(input) .. ': head is ' .. tostring(head(input)))
    
    local head_evaluated = combcalc.ski_reduce(head(input))
    
    -- print('ski_reduce on ' .. tostring(input) .. ': head_evaluated is ' .. tostring(head(input)))
    
    if head_evaluated ~= head(input) then
      return combcalc.ski_reduce(sx {head_evaluated, tail(input)})
    end
    
    if head(input) == 'i' then
      return combcalc.ski_reduce(tail(input))
    end
    
    if head(head(input)) == 'k' then
      return combcalc.ski_reduce(tail(head(input)))
    end
    
    if head(head(head(input))) == 's' then
      local x = tail(head(head(input)))
      local y = tail(head(input))
      local z = tail(input)
      
      -- print('ski_reduce on ' .. tostring(input) .. ': evaluating s; x is ' .. tostring(x) ..
      --   ', y is ' .. tostring(y) .. ', z is ' .. tostring(z))
      
      return combcalc.ski_reduce(sx {{x, z}, {y, z}})
    end
  end
  
  -- print('ski_reduce on ' .. tostring(input) .. ': could not reduce any further')
  
  return input
end

return combcalc