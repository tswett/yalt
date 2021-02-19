local freeze = {}

function freeze.frozen(t)
  local metatable = {}
  
  metatable.__index = t
  
  function metatable.__newindex(table, key, value)
    error('tried to set an index on a frozen table', 2)
  end
  
  local result = {}
  setmetatable(result, metatable)
  
  return result
end

return freeze