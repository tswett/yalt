local testing = require 'src/testing'
local freeze = require 'src/freeze'
local sexpressions = require 'src/sexpressions'

_ENV = freeze.frozen(_ENV)

local suite = {}

function suite.can_parse_a_string_of_letters()
  local success, result = sexpressions.parse('hello')
  
  return success and (result == 'hello')
end

function suite.cannot_parse_something_that_isnt_a_string()
  local success, result = sexpressions.parse({})
  
  return not success
end

function suite.cannot_parse_an_invalid_identifier()
  local success, result = sexpressions.parse('*')
  
  return not success
end

function suite.cannot_parse_the_empty_string()
  local success, result = sexpressions.parse('')
  
  return not success
end

function suite.can_parse_an_underscore()
  local success, result = sexpressions.parse('_')
  
  return success and (result == '_')
end

function suite.these_are_letters()
  local ok =
    sexpressions.is_letter('A') and
    sexpressions.is_letter('Z') and
    sexpressions.is_letter('a') and
    sexpressions.is_letter('z')
  
  return ok
end

function suite.these_are_not_letters()
  local wrong =
    sexpressions.is_letter('@') or
    sexpressions.is_letter('[') or
    sexpressions.is_letter('`') or
    sexpressions.is_letter('{')
  
  return not wrong
end

testing.run_all_in_suite(suite, print, true)