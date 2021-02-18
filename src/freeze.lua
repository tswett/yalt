freeze = {}

function freeze.frozen(t)
  local metatable = {}
  
  metatable.__index = t
  
  function metatable.__newindex(table, key, value)
    error('tried to set an index on a frozen table')
  end
  
  result = {}
  setmetatable(result, metatable)
  
  return result
end

return freeze