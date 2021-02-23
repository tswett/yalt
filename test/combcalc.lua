local testing = require 'src/testing'
local freeze = require 'src/freeze'
local sexpressions = require 'src/sexpressions'
local combcalc = require 'src/combcalc'

_ENV = freeze.frozen(_ENV)

local sx = sexpressions.sexpression

local suite = {}

function suite.constants_reduce_to_themselves()
  local success =
    combcalc.ski_reduce 's' == 's' and
    combcalc.ski_reduce 'k' == 'k' and
    combcalc.ski_reduce 'i' == 'i'
  
  return success
end

function suite.combinator_i_works()
  local success =
    combcalc.ski_reduce (sx {'i', 'k'}) == 'k' and
    combcalc.ski_reduce (sx {'i', {'k', 'i'}}) == sx {'k', 'i'}
  
  return success
end

function suite.nested_evaluation_works()
  local success =
    combcalc.ski_reduce (sx {{'i', 'i'}, 'k'}) == 'k' and
    combcalc.ski_reduce (sx {{'i', 'i'}, {'k', 'i'}}) == sx {'k', 'i'}
  
  return success
end

function suite.combinator_k_works()
  local success =
    combcalc.ski_reduce (sx {{'k', 'X'}, 'Y'}) == 'X'
  
  return success
end

function suite.combinator_s_works()
  local success =
    combcalc.ski_reduce (sx {{{'s', 'X'}, 'Y'}, 'Z'}) == sx {{'X', 'Z'}, {'Y', 'Z'}}
  
  return success
end

testing.run_all_in_suite(suite, print, true)