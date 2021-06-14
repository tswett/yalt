local testing = require 'src/testing'
local freeze = require 'src/freeze'
local sexpressions = require 'src/sexpressions'

_ENV = freeze.frozen(_ENV)

local suite = {}

local sx = sexpressions.sexpression

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

function suite.can_parse_an_empty_list()
  local success, result = sexpressions.parse('()')
  
  return success and (result == sx {})
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
  local sexpr = sx {}
  
  return #sexpr == 0
end

function suite.can_make_a_nonempty_sexpression()
  local sexpr = sx {'a', 'b'}
  
  return #sexpr == 2 and sexpr[1] == 'a' and sexpr[2] == 'b'
end

function suite.can_convert_an_empty_sexpression_to_string()
  local sexpr = sx {}
  
  return tostring(sexpr) == '()'
end

function suite.can_convert_a_nonempty_sexpression_to_string()
  local sexpr = sx {'a', 'b'}
  
  return tostring(sexpr) == '(a b)'
end

function suite.sexpressions_compare_correctly()
  local sexpr_a_1 = sx {'a'}
  local sexpr_a_2 = sx {'a'}
  local sexpr_b = sx {'b'}
  local sexpr_abc_1 = sx {'a', sx {'b', 'c'}}
  local sexpr_abc_2 = sx {'a', sx {'b', 'c'}}
  local sexpr_adc = sx {'a', sx {'d', 'c'}}
  local sexpr_xyz_1 = sx {sx {'x', 'y'}, 'z'}
  local sexpr_xyz_2 = sx {sx {'x', 'y'}, 'z'}
  local sexpr_xwz = sx {sx {'x', 'w'}, 'z'}
  
  local success =
    sexpr_a_1 == sexpr_a_2 and
    sexpr_a_1 ~= sexpr_b and
    sexpr_a_1 ~= 'a' and
    sexpr_abc_1 == sexpr_abc_2 and
    sexpr_abc_1 ~= sexpr_adc and
    sexpr_xyz_1 == sexpr_xyz_2 and
    sexpr_xyz_1 ~= sexpr_xwz
  
  return success
end

function suite.can_make_recursive_sexpression()
  local sexpr = sx {'a', {'b', 'c'}, {'d', 'e'}}
  
  local success = sexpr == sx {'a', sx {'b', 'c'}, sx {'d', 'e'}}
  
  return success
end

function suite.can_parse_atom_from_index()
  local test_expression = '(one (two three))'
  
  local parse_success, atom, new_index = sexpressions.parse_atom_from(test_expression, 1)
  
  if not (not parse_success) then
    return false
  end
  
  local parse_success, atom, new_index = sexpressions.parse_atom_from(test_expression, 2)
  
  if not (parse_success and atom == 'one' and new_index == 5) then
    return false
  end
  
  local parse_success, atom, new_index = sexpressions.parse_atom_from(test_expression, 7)
  
  if not (parse_success and atom == 'two' and new_index == 10) then
    return false
  end
  
  local parse_success, atom, new_index = sexpressions.parse_atom_from(test_expression, 11)
  
  if not (parse_success and atom == 'three' and new_index == 16) then
    return false
  end
  
  return true
end

testing.run_all_in_suite(suite, print, true)