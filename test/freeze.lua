local testing = require 'src/testing'
local freeze = require 'src/freeze'

_ENV = freeze.frozen(_ENV)

local suite = {}

function suite.can_access_values_through_frozen()
  local t = {key = 'value'}
  local frozen_t = freeze.frozen(t)
  
  return frozen_t.key == 'value'
end

function suite.cannot_assign_through_frozen()
  local function try_to_assign_through_frozen()
    local t = {key = 'value'}
    local frozen_t = freeze.frozen(t)
    
    frozen_t.key = 'new value'
  end
  
  local ran_ok, result = pcall(try_to_assign_through_frozen)
  
  return not ran_ok
end

testing.run_all_in_suite(suite, print)