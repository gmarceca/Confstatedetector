function [window_t, reset] = buffer_func(init,u2, Ip, tp)
% This function receives FIR and PD samples. These are concatenated
% in a vector until reaching a certain size.
% Then it moves the window one time-step forward (sliding window).

% Inputs: 
% init: Only used for the first step. It infers aumatically the dimensions from the
% output window_t
% u2: FIR and PD samples
%Ip: plasma current
% tp: tunable params

%#codegen
% for output
persistent data
% counter
persistent index 

input_size = size(u2,1);

% for the first time step
if isempty(data)
  data =  init;
  index = 0;
end

window_size = size(data,2);

enable = index*input_size>=window_size;

% true only if index <= window size or ip < ip_thr (reset LSTM hidden states)
reset = ((index*input_size) <= window_size || abs(Ip) < tp.ip_thr);

index = index +1;

data(:, 1:window_size-1*input_size) = data(:, input_size+1:window_size);
data(:, end-(input_size-1):end) = u2';

window_t = single(data*enable);

