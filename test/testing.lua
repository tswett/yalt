local testing = require 'src/testing'

_ENV = freeze.frozen(_ENV)

local suite = {}

local function make_reporter()
  local container = {output = ''}
  
  local function report(...)
    local report_text = table.concat({...}, ' ')
    container.output = container.output .. report_text .. ';'
  end
  
  return container, report
end

function suite.empty_test_suite_report()
  local container, report = make_reporter()
  
  local suite_to_test = {}
  
  testing.run_all_in_suite(suite_to_test, report)
  
  return container.output == 'summary 0 ok;summary 0 failed;ok;'
end

function suite.failed_test_suite_reports_failed()
  local container, report = make_reporter()
  
  local suite_to_test = {}
  
  function suite_to_test.always_fails()
    return false
  end
  
  testing.run_all_in_suite(suite_to_test, report)
  
  return container.output == 'running always_fails;failed always_fails;summary 0 ok;summary 1 failed;failed;'
end

function suite.ok_test_suite_reports_ok()
  local container, report = make_reporter()
  
  local suite_to_test = {}
  
  function suite_to_test.always_ok()
    return true
  end
  
  testing.run_all_in_suite(suite_to_test, report)
  
  return container.output == 'running always_ok;ok always_ok;summary 1 ok;summary 0 failed;ok;'
end

testing.run_all_in_suite(suite, print)