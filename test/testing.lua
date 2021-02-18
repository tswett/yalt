testing = require 'src/testing'

suite = {}

function suite.failed_test_suite_reports_failed()
  local suite_to_test = {}
  function suite_to_test.fail()
    return false
  end
  
  local result
  local function report_result(r)
    result = r
  end
  
  testing.run_all_in_suite(suite_to_test, report_result)
  
  return result == 'failed'
end

testing.run_all_in_suite(suite, print)