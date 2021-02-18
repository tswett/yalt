local testing = require 'src/testing'

local suite = {}

local function make_reporter()
  local container = {output = ''}
  
  local function report(...)
    report_text = table.concat({...}, ' ')
    container.output = container.output .. report_text .. ';'
  end
  
  return container, report
end

function suite.empty_test_suite_report()
  container, report = make_reporter()
  
  local suite_to_test = {}
  
  testing.run_all_in_suite(suite_to_test, report)
  
  return container.output == 'summary 0 ok;summary 0 failed;ok;'
end

function suite.failed_test_suite_reports_failed()
  container, report = make_reporter()
  
  local suite_to_test = {}
  
  function suite_to_test.fail()
    return false
  end
  
  testing.run_all_in_suite(suite_to_test, report)
  
  return container.output == 'summary 0 ok;summary 1 failed;failed;'
end

testing.run_all_in_suite(suite, print)