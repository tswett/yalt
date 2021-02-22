local freeze = require 'src/freeze'
local sexpressions = require 'src/sexpressions'

_ENV = freeze.frozen(_ENV)

local combcalc = {}

local sx = sexpressions.sexpression

function combcalc.ski_reduce(input)
  if type(input) == 'table' then
    local fn = input[1]
    
    local fn_evaluated = combcalc.ski_reduce(fn)
    if fn_evaluated ~= fn then
      return combcalc.ski_reduce(sx {fn_evaluated, input[2]})
    end
    
    if input[1] == 'i' then
      return combcalc.ski_reduce(input[2])
    end
  end
  
  return input
end

return combcalc