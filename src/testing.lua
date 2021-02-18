testing = {}

function testing.run_all_in_suite(suite, report)
  local success_count = 0
  local failure_count = 0
  
  for name, test_case in pairs(suite) do
    ran_ok, result = pcall(test_case)
    
    if ran_ok and (result == true) then
      success_count = success_count + 1
    else
      failure_count = failure_count + 1
    end
  end
  
  report('summary', success_count, 'ok')
  report('summary', failure_count, 'failed')
  
  if failure_count == 0 then
    report('ok')
  else
    report('failed')
  end
end

return testing