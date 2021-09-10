function fp = SCDalgo_confstate_loadfp(obj)

%% Timing
if nargin>0
    fp.timing = obj.gettiming;            %get t_struct from object
else
    fp.timing.t_start = 0;
    fp.timing.t_stop = 2.5;
end
fp.timing.dt = 1e-3;
%% Load other fixed parameters
fp.window_size = 40; % Convolutional window size
fp.downsampling_factor = 10; % if sampling rate of input is 10khz
fp.fir_norm = 1e-19; % Normalization for the FIR
fp.pd_norm = 1; % Normalization for the PD
fp.n_signals = 2; % Two signals used as input: PD and FIR
end