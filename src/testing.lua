testing = {}

function testing.run_all_in_suite(suite, report)
  local success = true
  
  for name, test_case in pairs(suite) do
    ran_ok, result = pcall(test_case)
    
    if not ran_ok or (result ~= true) then
      success = false
    end
  end
  
  if success then
    report('ok')
  else
    report('failed')
  end
end

return testing