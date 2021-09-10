function [window, reset] = test_sliding_window_buff_1khz()
% function to test 1kHz buffer sliding window approach

% Generate a dummy input signal
init = zeros(1, 4);
u2 = ones(1, 1);
Ip = 10;
tp.ip_thr = 1;

window = [];
reset = [];
% Test sliding window function
for istep = 1:6
  [slice, reset(istep)] = buffer_func(init,u2, Ip, tp); 
  window = [window slice];
end
end
