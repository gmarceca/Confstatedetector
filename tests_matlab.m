function tests_matlab(test_case)
try
    fprintf('\n Running test file: %s\n',mfilename('fullpath'));
    fprintf('     Time: %s\n',datestr(now));
    
    % start directly the testsuite
    import matlab.unittest.TestSuite;
    suite = TestSuite.fromClass(?ConfstateTest);
    results = run(suite);
    disp(table(results));
    
    if all([results.Passed])
        fprintf('\nPassed all tests\n')
        passed = true;
    else
        passed = false;
    end
    exit_code_flag = int32(~passed); % convert to bash shell convention
catch ME
    disp(getReport(ME))
    exit_code_flag = 1;
end
exit(exit_code_flag);
