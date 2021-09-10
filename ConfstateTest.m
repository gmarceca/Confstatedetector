classdef ConfstateTest < matlab.unittest.TestCase
  % Class which defines the functions we want to
  % test for confstate detector.
  methods (TestClassSetup)
    function setup_config(testCase)
      SCDalgo_confstate_init(true); % stand-alone test
    end
  end
  
  methods (TestClassTeardown)
    function close_clear_all(testCase)
      bdclose all;
      Simulink.data.dictionary.closeAll('-discard');
    end
  end
  
  methods(Test)
    function Buffertest(testCase)
      %%% call func to get actual values
      [window, reset] = test_sliding_window_buff_1khz();
      % Expected values
      exp_reset = ones(1,6); exp_reset(end) = 0;
      exp_window = single(zeros(1,24)); exp_window(end-7:end) = single(1);
      testCase.verifyEqual(reset, exp_reset);
      testCase.verifyEqual(window, exp_window);
      clear all
    end
    function PolicyTest(testCase)
      %%% call func to get actual values
      result = test_policy_det();
      actual_LDH = sum(result.Data==1);
      expected_LDH =[559 0 2449]; % [L, D, H] modes
      testCase.verifyEqual(actual_LDH, expected_LDH);
    end
    
    function IntegratedTest(testCase)
      SCDalgo_confstate_harness_run;
    end
  end
end
