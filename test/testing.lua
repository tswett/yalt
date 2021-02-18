testing = require 'src/testing'

suite = {}

function suite.empty_test_suite_report()
  local output = ''
  
  local function report(...)
    report_text = table.concat({...}, ' ')
    output = output .. report_text .. ';'
  end
  
  local suite_to_test = {}
  
  testing.run_all_in_suite(suite_to_test, report)
  
  return output == 'summary 0 ok;summary 0 failed;ok;'
end

function suite.failed_test_suite_reports_failed()
  local output = ''
  
  local function report(...)
    report_text = table.concat({...}, ' ')
    output = output .. report_text .. ';'
  end
  
  local suite_to_test = {}
  
  function suite_to_test.fail()
    return false
  end
  
  testing.run_all_in_suite(suite_to_test, report)
  
  return output == 'summary 0 ok;summary 1 failed;failed;'
end

testing.run_all_in_suite(suite, print)