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

function suite.can_iterate_over_chars()
  local char_list = {}
  
  for char in sexpressions.chars('ab') do
    table.insert(char_list, char)
  end
  
  return (#char_list == 2) and (char_list[1] == 'a') and (char_list[2] == 'b')
end

function suite.can_make_an_empty_sexpression()
  local sexpr = sexpressions.sexpression {}
  
  return #sexpr == 0
end

function suite.can_make_a_nonempty_sexpression()
  local sexpr = sexpressions.sexpression {'a', 'b'}
  
  return #sexpr == 2 and sexpr[1] == 'a' and sexpr[2] == 'b'
end

function suite.can_convert_an_empty_sexpression_to_string()
  local sexpr = sexpressions.sexpression {}
  
  return tostring(sexpr) == '()'
end

function suite.can_convert_a_nonempty_sexpression_to_string()
  local sexpr = sexpressions.sexpression {'a', 'b'}
  
  return tostring(sexpr) == '(a b)'
end

testing.run_all_in_suite(suite, print, true)